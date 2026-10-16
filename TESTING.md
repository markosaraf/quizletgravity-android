# Phone checks

Build verification covers Java compilation, Android resource processing, lint, URL-policy unit tests and APK signing. These checks do not replace running the app on a phone. The first release is prepared for owner testing; phone behaviour has not yet been verified.

Please check:

1. The launcher shows the gold Q on indigo. Opening the app shows only the logo, with no title, loading text or spinner, followed by the website without browser controls.
2. Paste a Quizlet share message with a public set URL and import it. Confirm the editable cards are complete and start a game.
3. Import a CSV or text file through the Android file picker. Switch back to pasted terms and try that too.
4. Type answers, including accents. Confirm the keyboard leaves the input visible, and rotate the phone to check the game remains in place.
5. Leave an active game for another app, then return. The game should be paused with the website's Resume control available.
6. Change theme/preferences, close the app and reopen it. Imported cards and supported preferences should remain on the same device.
7. Press Android Back. It should return through web history, or ask before closing the app at the root page.
8. Launch without internet. Confirm a useful error/retry screen, then reconnect and retry.

Do not expect data to be shared with the phone's separate browser or offline imports to work.
