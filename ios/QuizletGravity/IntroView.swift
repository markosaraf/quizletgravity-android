import UIKit

/// The supplied square artwork remains unrounded, including throughout the crossfade.
final class IntroView: UIView {
    private let pictures = ["LogoGoldBackground", "LogoBlack", "LogoWhite", "LogoGold"]
    private let chip = UIImageView()
    private let incoming = UIImageView()
    private let title = UILabel()
    private let message = UILabel()
    private let retry = UIButton(type: .system)
    private var motion: UIViewPropertyAnimator?
    private var index = 0
    private var ready = false
    private var failed = false
    private var started = false
    var onRetry: (() -> Void)?
    var onReveal: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(red: 66/255, green: 85/255, blue: 1, alpha: 1)
        chip.image = UIImage(named: pictures[0])
        [chip, incoming].forEach {
            $0.contentMode = .scaleAspectFit
            $0.isAccessibilityElement = false
            addSubview($0)
        }
        title.text = "Quizlet Gravity"
        title.textColor = .white
        title.font = .boldSystemFont(ofSize: 28)
        title.textAlignment = .center
        title.adjustsFontSizeToFitWidth = true
        title.minimumScaleFactor = 0.75
        message.textColor = .white
        message.textAlignment = .center
        message.numberOfLines = 0
        message.font = .preferredFont(forTextStyle: .body)
        retry.setTitle("Try again", for: .normal)
        retry.tintColor = .white
        retry.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        retry.addTarget(self, action: #selector(retryTapped), for: .touchUpInside)
        [title, message, retry].forEach { addSubview($0) }
        message.isHidden = true
        retry.isHidden = true
        accessibilityViewIsModal = true
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func layoutSubviews() {
        super.layoutSubviews()
        let size = min(CGFloat(156), bounds.width * 0.46, bounds.height * 0.34)
        let centerY = bounds.midY - 35
        chip.bounds = CGRect(x: 0, y: 0, width: size, height: size)
        chip.center = CGPoint(x: bounds.midX, y: centerY)
        incoming.bounds = chip.bounds
        incoming.center = chip.center
        title.frame = CGRect(x: 20, y: centerY + size/2 + 24, width: bounds.width-40, height: 40)
        message.frame = CGRect(x: 24, y: title.frame.maxY + 12, width: bounds.width-48, height: 64)
        retry.frame = CGRect(x: 24, y: message.frame.maxY, width: bounds.width-48, height: 48)
    }

    func start() {
        guard !started else { return }
        started = true
        if UIAccessibility.isReduceMotionEnabled {
            chip.image = UIImage(named: "LogoGold")
        } else { cycle() }
    }

    func pageReady() {
        guard !failed else { return }
        ready = true
        if UIAccessibility.isReduceMotionEnabled { reveal() }
    }

    private func cycle() {
        guard !failed else { return }
        if ready { morph(); return }
        let next = (index + 1) % 3
        incoming.image = UIImage(named: pictures[next])
        incoming.alpha = 0
        incoming.transform = CGAffineTransform(translationX: bounds.width * 0.4, y: 0).scaledBy(x: 0.75, y: 0.75)
        animate(duration: 0.8, animations: {
            self.chip.transform = CGAffineTransform(translationX: -self.bounds.width * 0.4, y: 0).scaledBy(x: 0.75, y: 0.75)
            self.chip.alpha = 0
            self.incoming.transform = .identity
            self.incoming.alpha = 1
        }) { [weak self] in
            guard let self else { return }
            self.index = next
            self.chip.image = UIImage(named: self.pictures[next])
            self.chip.transform = .identity
            self.chip.alpha = 1
            self.incoming.alpha = 0
            self.cycle()
        }
    }

    private func morph() {
        incoming.image = UIImage(named: "LogoGold")
        incoming.transform = .identity
        incoming.alpha = 0
        animate(duration: 0.55, animations: {
            self.incoming.alpha = 1
            self.chip.alpha = 0
        }) { [weak self] in self?.reveal() }
    }

    private func reveal() {
        guard !failed else { return }
        // A property animator makes both the hold and fade pause with the app.
        animate(duration: UIAccessibility.isReduceMotionEnabled ? 0.01 : 1.65, animations: {
            UIView.animateKeyframes(withDuration: 1.65, delay: 0, options: [], animations: {
                UIView.addKeyframe(withRelativeStartTime: 1 / 1.65, relativeDuration: 0.65 / 1.65) {
                    self.alpha = 0
                }
            })
        }) { [weak self] in self?.onReveal?() }
    }

    private func animate(duration: TimeInterval, animations: @escaping () -> Void, completion: @escaping () -> Void) {
        let animator = UIViewPropertyAnimator(duration: duration, curve: .easeInOut, animations: animations)
        animator.addCompletion { [weak self] position in
            guard position == .end, self?.failed == false else { return }
            completion()
        }
        motion = animator
        animator.startAnimation()
        if UIApplication.shared.applicationState != .active { animator.pauseAnimation() }
    }

    func pause() { if motion?.state == .active { motion?.pauseAnimation() } }
    func resume() { if motion?.state == .active { motion?.continueAnimation(withTimingParameters: nil, durationFactor: 1) } }
    func stop() { motion?.stopAnimation(true); motion = nil }

    func showError() {
        failed = true
        stop()
        alpha = 1
        chip.image = UIImage(named: "LogoGold")
        chip.transform = .identity
        chip.alpha = 1
        incoming.alpha = 0
        message.text = "The game couldn’t load. Check your internet connection and try again."
        message.isHidden = false
        retry.isHidden = false
        UIAccessibility.post(notification: .screenChanged, argument: message)
    }

    @objc private func retryTapped() { onRetry?() }
}
