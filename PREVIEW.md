# Quizzlet Gravity preview apps

Separate from the stable apps:
- Display name: **Quizzlet Gravity**
- Android ID: `com.quizletgravity.preview.android`
- iOS ID: `com.quizletgravity.preview.ios`
- Backend/site: https://quizzlet-gravity-preview.vercel.app

The apps share the preview accounts, public sets and leaderboards. Google sign-in opens the system browser, then securely returns through a short-lived, single-use PKCE handoff. Username/password and named guest sign-in remain inside the app. No credentials are bundled in either app.

## Artifacts

Downloads → Quizzlet Gravity Preview contains a separately signed Android APK for installation, an Android AAB for store preparation, a simulator app ZIP, and an unsigned iOS archive ZIP.

Android release signing is in `~/.config/quizzlet-gravity-preview/android-signing.properties`, outside git. Preserve it for future updates.

The iOS simulator build and unsigned device archive pass. A signed archive is currently blocked: Xcode rejected the saved Apple-account login and has no provisioning profile for the new bundle ID. Sign back into Xcode → Settings → Accounts, then archive with team `K2273P6PJC`. The unsigned ZIP is not installable and is not an IPA.

## Checks

`./gradlew assembleDebug testDebugUnitTest lintDebug`

`QUIZLETGRAVITY_SIGNING_PROPERTIES=$HOME/.config/quizzlet-gravity-preview/android-signing.properties ./gradlew assembleRelease bundleRelease`

`xcodebuild -project ios/QuizletGravity.xcodeproj -scheme QuizletGravity -sdk iphonesimulator CODE_SIGNING_ALLOWED=NO build`

Before wider distribution, test a real device: account/guest login, Google browser-return, import/paste/file upload, shared-link opening, gameplay keyboard, completed score display, background/resume and offline retry. The owner's phone was not used to install or launch these preview apps.
