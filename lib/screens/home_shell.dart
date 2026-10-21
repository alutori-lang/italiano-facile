import 'package:flutter/material.dart';

import '../app_scope.dart';
import '../l10n/app_localizations.dart';
import '../ui/theme.dart';
import 'quiz_category_screen.dart';
import 'search_screen.dart';
import 'settings_screen.dart';
import 'today_screen.dart';
import 'topics_screen.dart';

/// The four persistent tabs. Each keeps its own state, and Settings opens as
/// a separate screen from the Search header.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key, this.initialTab = 0});

  final int initialTab;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  late int _tab = widget.initialTab;

  // Owned here, above the tab that actually shows it, so the query and its
  // results survive leaving and returning to the Search tab even though only
  // the active tab's screen stays built — see the comment on `body` below.
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // At first launch the user picks the one language translations are
    // shown in; the interface itself is always Italian.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (!AppScope.of(context).settings.hasChosenLanguage) {
        showTranslationLanguagePicker(context, firstLaunch: true);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _select(int index) {
    if (index == _tab) return;
    setState(() => _tab = index);
  }

  Widget _buildTab(int index) {
    switch (index) {
      case 0:
        return SearchScreen(controller: _searchController);
      case 1:
        return const TodayScreen();
      case 2:
        return const QuizCategoryScreen();
      case 3:
      default:
        return const TopicsScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations t = AppLocalizations.of(context);

    return Scaffold(
      // Only the active tab is built. Keeping all four mounted at once (via
      // an IndexedStack or an Offstage) would leave every tab's list or grid
      // in the tree together, and then more than one Scrollable exists at
      // the same time — which breaks any test, and any assistive or testing
      // tool, that asks to scroll "the" list without naming which one.
      // Search is the one tab whose content should survive switching away
      // and back, so its query lives in `_searchController` above rather
      // than inside the screen itself.
      body: _buildTab(_tab),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // A thin Italian tricolour strip, as in the approved design.
          Row(
            children: AppColors.tricolour
                .map(
                  (Color colour) => Expanded(
                    child: Container(height: 3, color: colour),
                  ),
                )
                .toList(),
          ),
          // Our own bar rather than NavigationBar: a Material destination
          // label wraps onto a second line when the word is long (Urdu
          // "موضوعات") or the phone is narrow, and then it no longer fits the
          // bar's fixed height. Here every label is one line that shortens
          // with an ellipsis instead.
          Material(
            key: const ValueKey<String>('bottom-nav'),
            color: context.surface,
            child: SafeArea(
              top: false,
              child: SizedBox(
                height: 64,
                child: Row(
                  children: <Widget>[
                    _Tab(
                      tabKey: const ValueKey<String>('tab-search'),
                      icon: Icons.search_rounded,
                      label: t.tabSearch,
                      selected: _tab == 0,
                      onTap: () => _select(0),
                    ),
                    _Tab(
                      tabKey: const ValueKey<String>('tab-today'),
                      icon: Icons.calendar_today_rounded,
                      label: t.tabToday,
                      selected: _tab == 1,
                      onTap: () => _select(1),
                    ),
                    _Tab(
                      tabKey: const ValueKey<String>('tab-quiz'),
                      icon: Icons.fact_check_rounded,
                      label: t.tabQuiz,
                      selected: _tab == 2,
                      onTap: () => _select(2),
                    ),
                    _Tab(
                      tabKey: const ValueKey<String>('tab-topics'),
                      icon: Icons.grid_view_rounded,
                      label: t.tabTopics,
                      selected: _tab == 3,
                      onTap: () => _select(3),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// One bottom-bar item: icon above a single-line label that shortens rather
/// than wrapping, so the bar keeps its height in every language.
class _Tab extends StatelessWidget {
  const _Tab({
    required this.tabKey,
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final Key tabKey;
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color colour = selected ? AppColors.italianRed : context.muted;
    return Expanded(
      child: Semantics(
        button: true,
        selected: selected,
        label: label,
        child: InkWell(
          key: tabKey,
          onTap: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: 48,
                height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected
                      ? AppColors.italianRed.withValues(alpha: 0.12)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppRadii.pill),
                ),
                child: Icon(icon, size: 22, color: colour),
              ),
              const SizedBox(height: 2),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    height: 1.2,
                    fontWeight: FontWeight.w600,
                    color: colour,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
