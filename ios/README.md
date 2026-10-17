# Quizlet Gravity for iPhone and iPad

Native UIKit/WKWebView app for the live https://www.quizletgravity.com game. The name and original square logo variants are unchanged. It supports iOS 16 and later, persistent website storage, the system file picker, external links, safe-area layout, a native opening carousel, reduced motion, and retry after connection failures. No JavaScript-to-native bridge or API credentials are included.

Open `QuizletGravity.xcodeproj`, select the shared **QuizletGravity** scheme and your Apple Developer team under **Signing & Capabilities**. The provisional bundle ID is `com.quizletgravity.ios`; register it under your team before submission.

## Build

Use Xcode 26 or later with the iOS 26 SDK (Apple's current upload requirement). The GitHub `iOS release preparation` workflow builds the simulator target and creates a device archive with signing disabled. Its artifact is a **build verification archive, not an installable IPA or an App Store upload**.

For a signed archive on a suitably equipped Mac:

```sh
xcodebuild -project ios/QuizletGravity.xcodeproj -scheme QuizletGravity \
  -configuration Release -destination 'generic/platform=iOS' \
  -archivePath ios/build/QuizletGravity.xcarchive \
  DEVELOPMENT_TEAM=YOUR_TEAM_ID -allowProvisioningUpdates archive
```

With the membership signed in to Xcode, open the archive in Organizer and choose **Distribute App → App Store Connect**. Keep certificates and provisioning profiles outside git. Do not put Apple passwords or signing keys in issues or source files.

## Owner checks before submission

On a real iPhone/iPad or TestFlight build, check the carousel, reduced motion, paste/import/edit/play, the Files picker, keyboard sizing, background/pause/resume, portrait/landscape and network-off retry. This project has not been interactively tested on an iPhone by Codex. Follow the release checklist in `store/README.md`.

The assets are generated from the checked-in source SVGs. `scripts/generate-assets.cjs` uses Sharp; `scripts/generate-project.rb` uses Ruby's xcodeproj gem. The generated project and PNG assets are committed, so neither generator is needed to build.
