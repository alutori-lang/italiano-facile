# Fonts

The app asks for **Plus Jakarta Sans** (the approved design typeface) and
**Noto Nastaliq Urdu**, and falls back to the Noto fonts the phone already has
for Gurmukhi, Bengali, Sinhala, Arabic and Chinese.

To bundle the typefaces so no device can ever show empty boxes:

1. Download the .ttf files
   - Plus Jakarta Sans: https://fonts.google.com/specimen/Plus+Jakarta+Sans
   - Noto Nastaliq Urdu: https://fonts.google.com/noto/specimen/Noto+Nastaliq+Urdu
2. Put them in this folder with exactly these names:
   - PlusJakartaSans-Regular.ttf
   - PlusJakartaSans-Medium.ttf
   - PlusJakartaSans-Bold.ttf
   - PlusJakartaSans-ExtraBold.ttf
   - NotoNastaliqUrdu-Regular.ttf
   - NotoNastaliqUrdu-Bold.ttf
3. Uncomment the `fonts:` block at the bottom of pubspec.yaml and run
   `flutter pub get`.

Both families are licensed under the SIL Open Font License, so they may be
shipped inside the app.
