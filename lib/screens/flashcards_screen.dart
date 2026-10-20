import 'package:flutter/material.dart';

import '../app_scope.dart';
import '../l10n/app_localizations.dart';
import '../models/learner_language.dart';
import '../models/word.dart';
import '../ui/theme.dart';
import '../ui/widgets/audio_button.dart';
import '../ui/widgets/button_content.dart';
import '../ui/widgets/picture_box.dart';

/// Flashcards: a different arrangement again — the Italian word alone, huge
/// and centred, with the translation hidden until the card is tapped.
class FlashcardsScreen extends StatefulWidget {
  const FlashcardsScreen({
    super.key,
    required this.words,
    required this.title,
  });

  final List<Word> words;
  final String title;

  @override
  State<FlashcardsScreen> createState() => _FlashcardsScreenState();
}

class _FlashcardsScreenState extends State<FlashcardsScreen> {
  final PageController _pages = PageController();
  final Set<int> _flipped = <int>{};
  int _index = 0;

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations t = AppLocalizations.of(context);
    final LearnerLanguage lang = AppScope.languageOf(context);

    return Scaffold(
      appBar: AppBar(
        title: AppBarTitle('${widget.title} · ${t.flashcards}'),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpace.xl,
                vertical: AppSpace.s,
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      t.todayProgress(_index + 1, widget.words.length),
                      style: context.texts.bodySmall,
                    ),
                  ),
                  // Flexible, or a long translation of the hint pushes the
                  // row past the edge of a narrow phone.
                  Flexible(
                    child: Text(
                      t.flashcardTapToFlip,
                      textAlign: TextAlign.end,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: context.texts.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                key: const ValueKey<String>('flashcards-pager'),
                controller: _pages,
                itemCount: widget.words.length,
                onPageChanged: (int index) => setState(() => _index = index),
                itemBuilder: (BuildContext context, int index) {
                  final Word word = widget.words[index];
                  final bool shown = _flipped.contains(index);
                  return Padding(
                    padding: const EdgeInsets.all(AppSpace.xl),
                    child: GestureDetector(
                      key: ValueKey<String>('flashcard:$index'),
                      onTap: () => setState(() {
                        if (!_flipped.add(index)) _flipped.remove(index);
                      }),
                      child: Container(
                        decoration: BoxDecoration(
                          color: context.surface,
                          borderRadius: BorderRadius.circular(AppRadii.card),
                          border: Border.all(color: context.border),
                        ),
                        padding: const EdgeInsets.all(AppSpace.xl),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              PictureBox(
                                word: word,
                                size: 110,
                                radius: AppRadii.card,
                              ),
                              const SizedBox(height: AppSpace.xl),
                              Text(
                                word.it,
                                textAlign: TextAlign.center,
                                style: context.texts.displaySmall?.copyWith(
                                  fontSize: 32,
                                  color: AppColors.italianRed,
                                ),
                              ),
                              const SizedBox(height: AppSpace.m),
                              AudioButtonPair(text: word.it),
                              const SizedBox(height: AppSpace.xl),
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 220),
                                child: shown
                                    ? Column(
                                        key: const ValueKey<String>('back'),
                                        children: <Widget>[
                                          Text(
                                            word.translation(lang),
                                            textAlign: TextAlign.center,
                                            style: context.texts.titleMedium,
                                          ),
                                          const SizedBox(height: AppSpace.s),
                                          Text(
                                            word.explanation(lang),
                                            textAlign: TextAlign.center,
                                            style: context.texts.bodyMedium,
                                          ),
                                        ],
                                      )
                                    : Text(
                                        t.flashcardTapToFlip,
                                        key: const ValueKey<String>('front'),
                                        textAlign: TextAlign.center,
                                        style: context.texts.bodySmall,
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpace.xl,
                0,
                AppSpace.xl,
                AppSpace.l,
              ),
              child: FilledButton(
                key: const ValueKey<String>('flashcards-next'),
                onPressed: _index + 1 < widget.words.length
                    ? () => _pages.nextPage(
                          duration: const Duration(milliseconds: 240),
                          curve: Curves.easeOut,
                        )
                    : () => Navigator.of(context).maybePop(),
                child: ButtonContent(
                  icon: _index + 1 < widget.words.length
                      ? Icons.arrow_forward_rounded
                      : Icons.check_rounded,
                  label: _index + 1 < widget.words.length ? t.next : t.done,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
