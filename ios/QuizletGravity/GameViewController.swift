import UIKit
import WebKit

final class GameViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {
    private let home = URL(string: "https://www.quizletgravity.com/")!
    private var webView: WKWebView!
    private var intro: IntroView?
    private var timeout: Timer?
    private var generation = 0
    private var loaded = false
    private var failed = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 66/255, green: 85/255, blue: 1, alpha: 1)
        let configuration = WKWebViewConfiguration()
        configuration.websiteDataStore = .default()
        // No privileged JavaScript bridge or shared native credentials.
        webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        webView.isOpaque = false
        webView.backgroundColor = view.backgroundColor
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        NotificationCenter.default.addObserver(self, selector: #selector(inactive), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(active), name: UIApplication.didBecomeActiveNotification, object: nil)
        loadGame()
    }

    private func showIntro() {
        intro?.stop()
        intro?.removeFromSuperview()
        let overlay = IntroView(frame: view.bounds)
        overlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        overlay.onRetry = { [weak self] in self?.loadGame() }
        overlay.onReveal = { [weak self, weak overlay] in
            guard self?.intro === overlay else { return }
            self?.webView.accessibilityElementsHidden = false
            overlay?.removeFromSuperview()
            self?.intro = nil
            UIAccessibility.post(notification: .screenChanged, argument: self?.webView)
        }
        webView.accessibilityElementsHidden = true
        view.addSubview(overlay)
        intro = overlay
        overlay.layoutIfNeeded()
        overlay.start()
    }

    private func loadGame() {
        generation += 1
        loaded = false
        failed = false
        webView.stopLoading()
        showIntro()
        armTimeout()
        webView.load(URLRequest(url: home, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30))
    }

    private func armTimeout() {
        timeout?.invalidate()
        timeout = Timer.scheduledTimer(withTimeInterval: 30, repeats: false) { [weak self] _ in self?.fail() }
    }

    private func fail() {
        guard !failed else { return }
        failed = true
        timeout?.invalidate()
        generation += 1
        webView.stopLoading()
        if intro == nil { showIntro() }
        intro?.showError()
    }

    private func isInternal(_ url: URL) -> Bool {
        url.scheme?.lowercased() == "https" && ["quizletgravity.com", "www.quizletgravity.com"].contains(url.host?.lowercased() ?? "") && url.user == nil && url.password == nil && (url.port == nil || url.port == 443)
    }

    func webView(_ webView: WKWebView, decidePolicyFor action: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = action.request.url else { decisionHandler(.cancel); return }
        if isInternal(url) {
            if action.targetFrame == nil { webView.load(action.request); decisionHandler(.cancel) }
            else { decisionHandler(.allow) }
            return
        }
        if action.navigationType == .linkActivated, ["https", "http", "mailto"].contains(url.scheme?.lowercased() ?? "") {
            UIApplication.shared.open(url)
        }
        decisionHandler(.cancel)
    }

    func webView(_ webView: WKWebView, decidePolicyFor response: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        if response.isForMainFrame, let http = response.response as? HTTPURLResponse, http.statusCode >= 400 {
            decisionHandler(.cancel)
            fail()
        } else { decisionHandler(.allow) }
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        guard let url = webView.url, isInternal(url) else { fail(); return }
        if let scriptURL = Bundle.main.url(forResource: "AppFooter", withExtension: "js"),
           let script = try? String(contentsOf: scriptURL, encoding: .utf8) {
            webView.evaluateJavaScript(script, completionHandler: nil)
        }
        let expected = generation
        // Two browser frames allow layout/paint before fading the native cover.
        webView.callAsyncJavaScript("await new Promise(resolve => requestAnimationFrame(() => requestAnimationFrame(resolve)));", arguments: [:], in: nil, in: .page) { [weak self] result in
            guard let self, self.generation == expected else { return }
            if case .failure = result { self.fail(); return }
            self.loaded = true
            self.timeout?.invalidate()
            self.intro?.pageReady()
        }
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) { handle(error) }
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) { handle(error) }
    private func handle(_ error: Error) { if (error as NSError).code != NSURLErrorCancelled { fail() } }
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) { fail() }

    @objc private func inactive() {
        intro?.pause()
        timeout?.invalidate()
        guard let url = webView.url, isInternal(url) else { return }
        webView.evaluateJavaScript("(function(){var b=Array.from(document.querySelectorAll('button')).find(function(b){return !b.disabled && (b.getAttribute('aria-label')==='Pause' || b.textContent.trim()==='Pause');});if(b)b.click();})()", completionHandler: nil)
    }
    @objc private func active() {
        intro?.resume()
        if !loaded && !failed { armTimeout() }
    }

    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: "Quizlet Gravity", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in completionHandler() })
        present(alert, animated: true)
    }
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: "Quizlet Gravity", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in completionHandler(false) })
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in completionHandler(true) })
        present(alert, animated: true)
    }
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        let alert = UIAlertController(title: "Quizlet Gravity", message: prompt, preferredStyle: .alert)
        alert.addTextField { $0.text = defaultText }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in completionHandler(nil) })
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in completionHandler(alert.textFields?.first?.text) })
        present(alert, animated: true)
    }

    deinit { timeout?.invalidate(); NotificationCenter.default.removeObserver(self) }
}
