# Acceptance list — Italian Words: Learn & Play

Every line is a promise the app makes. Each has a real test under
`test/acceptance/` whose name starts with the feature name.

## Word data
- Word data: every entry has ten translations, ten explanations and ten example translations.
- Word data: nouns carry their Italian article (il / lo / la / l' / i / gli / le).
- Word data: Italian accents are correct (perché, città, caffè, ventitré, lunedì, più).
- Word data: every entry belongs to a known topic and every topic shown has words.
- Word data: no entry shows a picture that belongs to a different thing (emoji is either fitting or absent).
- Word data: LatAm Spanish differs from Spain Spanish where the word differs (carro, jugo, papa, boleto).
- Word data: Urdu, Shahmukhi, Gurmukhi, Bengali, Sinhala and Chinese translations are in their own script.

## Search
- Search: typing Italian finds the word ("pomodoro" finds "il pomodoro").
- Search: typing English finds the Italian word ("tomato" finds "il pomodoro").
- Search: typing Urdu, Bengali or Chinese finds the Italian word.
- Search: accents and capitals are ignored ("citta" finds "la città").
- Search: a small typo still finds the word ("pomodroo" finds "il pomodoro").
- Search: a conjugated verb finds the infinitive ("parlo" finds "parlare").
- Search: phrases are searched too ("Quanto costa" is found).
- Search: nothing found gives "did you mean" suggestions.
- Search: the screen shows results while typing and saves the last searches.
- Search: the result card has picture, Italian word, speaker, translation, explanation, example and "Add to my words".
- Search: online lookup is available only as a fallback and never blocks the offline app (needs a real device/network).

## Today
- Today: exactly ten words are chosen for a day.
- Today: two different users get different words on the same date.
- Today: the same user gets the same ten words twice on one date, and different words the next day.
- Today: the daily mix is about four nouns, three verbs, two adjectives and one phrase.
- Today: a word does not come back until all words have been seen.
- Today: the streak counts one more day after a consecutive day and restarts after a gap.
- Today: the screen shows the ten cards, the streak and the mini-quiz button.

## Quiz
- Quiz: a quiz always has exactly twenty questions.
- Quiz: about half the answers are true and half false.
- Quiz: a false question uses a decoy from the same topic.
- Quiz: PASSED only with two mistakes or fewer.
- Quiz: answering shows green or red, and a wrong answer shows the right word.
- Quiz: the result screen shows the score, the mistake list and both retry buttons.
- Quiz: the best score per category is saved.
- Quiz: a category with too few words offers no quiz.

## Topics
- Topics: the grid lists every category with its real word count.
- Topics: a category screen lists its words and opens the word card on tap.
- Topics: each category has a Flashcards button and a Quiz 20 button.
- Topics: a word counts as learned after two correct quiz answers.

## My words
- My words: a word saved in Search appears in My Words and survives a restart.
- My words: the quiz on my words needs at least four saved words.

## Settings
- Settings: the interface language can be changed by hand and is remembered.
- Settings: the app opens in the phone language and falls back to English.
- Settings: dark mode, audio speed and the reminder switch all work.
- Settings: reset progress clears streak, scores and saved words but keeps the purchase.
- Settings: privacy and about screens open and show their text.

## Languages
- Languages: all seventeen interface locales have every key, with no missing text.
- Languages: Urdu and Shahmukhi render right to left.
- Languages: word translations follow the interface language.

## Ads and purchase
- Ads: test ad unit ids are used until real ones are configured.
- Ads: Settings shows a "setup needed" notice while the test ids are still in place.
- Ads: an interstitial is never shown in the first three minutes and never twice within three minutes.
- Ads: no ads at all on the web and none after the purchase.
- Purchase: the product id is remove_ads on Android and prefixed on iOS.
- Purchase: buying remove_ads removes the ads and the entitlement survives a restart (needs a real device/store).
- Purchase: restore purchases asks the store again (needs a real device/store).

## Audio
- Audio: every word and phrase has a speaker button at normal and slow speed.
- Audio: a missing Italian voice shows the install guide and the app keeps working (needs a real device).

## Screenshot mode
- Screenshot mode: ember_screen=0..5 maps to six real screens filled with demo content.
