# Quizlet Gravity for Android

An Android app for [quizletgravity.com](https://www.quizletgravity.com/), with a gold-on-indigo launcher icon and launch screen. The app displays the live mobile website in Android System WebView, so web improvements appear without reinstalling the app.

**[Download the latest Android APK](https://github.com/markosaraf/quizletgravity-android/releases/latest)**

## Install

1. Open the latest release on your Android phone.
2. Download `QuizletGravity-1.1.0.apk` from **Assets**.
3. Open the downloaded file. If Android asks, allow this installation from your browser/file manager.
4. Open **Quizlet Gravity**.

Android 8.0 or newer and a current Android System WebView are required. Internet access is needed to load the site and import Quizlet sets. This is not an offline copy of the game.

## Included

- The live website’s set import, paste-terms workflow, editable preview and game.
- File import through Android’s document picker (CSV, TSV and text), without storage permissions.
- Local website storage for imported cards and preferences.
- Keyboard and system-bar insets, portrait/landscape resizing without reloading the game.
- Android Back navigation with confirmation before closing at the root page.
- The existing game’s Pause control is invoked when leaving the app, followed by WebView timer suspension.
- An offline/error screen with retry, rather than a blank browser error page.
- External links open in the browser. Only the exact HTTPS website domains open inside the app.
- Adaptive and monochrome launcher icons, plus an opening carousel of the supplied square colour variants and “Quizlet Gravity”. Once the website is drawable, the carousel morphs to gold-on-indigo, holds for one second and fades into the site. No loading message or spinner.

The app does not contain the Firecrawl API key or the website backend. Set imports use the existing website backend. Website analytics and its privacy terms still apply. Android WebView storage is separate from Chrome/Safari storage.

## Source and builds

- App source: this repository.
- Website source: [quizletgravityLAUNCH](https://github.com/markosaraf/quizletgravityLAUNCH).
- Building/signing: [BUILDING.md](BUILDING.md).
- Phone checks: [TESTING.md](TESTING.md).

The starting artwork is `quizlet-q-chip-gold-on-indigo-3.svg`, supplied by the site owner. Its unrounded background is separated from the gold Q so Android can apply its own launcher shape. The foreground is kept inside the adaptive icon safe area. No raster logo is stretched or artificially rounded twice.

The opening carousel uses the full, unmodified square proportions from `quizlet-q-chip-indigo-on-gold-3.svg`, `quizlet-q-chip-black-on-indigo3.svg`, `quizlet-q-chip-white-on-indigo-3.svg` and finally `quizlet-q-chip-gold-on-indigo-3.svg`. The source SVGs are in `artwork/`. Android draws their shared vector path directly. If the page is slow, the alternatives continue cycling. Errors stop the carousel and show retry. Android's disabled-animation setting is respected.

Reference: [Android adaptive icon guidance](https://developer.android.com/develop/ui/views/launch/icon_design_adaptive), [Android splash screens](https://developer.android.com/develop/ui/views/launch/splash-screen), [WebView file-access security](https://developer.android.com/privacy-and-security/risks/webview-unsafe-file-inclusion).

This independent app is for quizletgravity.com; it is not an official Quizlet app.
