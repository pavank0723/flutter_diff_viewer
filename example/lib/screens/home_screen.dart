import 'package:flutter/material.dart';

import 'change_navigation_screen.dart';
import 'character_diff_screen.dart';
import 'custom_theme_screen.dart';
import 'dark_mode_screen.dart';
import 'enterprise_screen.dart';
import 'large_document_screen.dart';
import 'side_by_side_screen.dart';
import 'stacked_screen.dart';
import 'unified_screen.dart';
import 'word_diff_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final demos = [
      _DemoItem(
        title: 'Side-by-Side Diff',
        subtitle: 'Classic GitHub 2-column view',
        icon: Icons.splitscreen,
        screen: const SideBySideScreen(),
      ),
      _DemoItem(
        title: 'Unified Diff',
        subtitle: 'Single column git diff view',
        icon: Icons.subject,
        screen: const UnifiedScreen(),
      ),
      _DemoItem(
        title: 'Stacked / Mobile Diff',
        subtitle: 'Top/bottom panels for mobile',
        icon: Icons.view_agenda,
        screen: const StackedScreen(),
      ),
      _DemoItem(
        title: 'Word-Level Granularity',
        subtitle: 'Highlights changed words inline',
        icon: Icons.title,
        screen: const WordDiffScreen(),
      ),
      _DemoItem(
        title: 'Character-Level Granularity',
        subtitle: 'Highlights changed characters inline',
        icon: Icons.font_download,
        screen: const CharacterDiffScreen(),
      ),
      _DemoItem(
        title: 'Dark Mode Theme',
        subtitle: 'GitHub-style dark theme',
        icon: Icons.dark_mode,
        screen: const DarkModeScreen(),
      ),
      _DemoItem(
        title: 'Custom Theme',
        subtitle: 'Customized colors and styles',
        icon: Icons.palette,
        screen: const CustomThemeScreen(),
      ),
      _DemoItem(
        title: 'Large Document Performance',
        subtitle: 'Virtualized rendering for 500+ lines',
        icon: Icons.speed,
        screen: const LargeDocumentScreen(),
      ),
      _DemoItem(
        title: 'Enterprise Showcase',
        subtitle: 'Privacy Notice PN00736 v1.2 vs v1.3',
        icon: Icons.business,
        screen: const EnterpriseScreen(),
      ),
      _DemoItem(
        title: 'Change Navigation',
        subtitle: 'Programmatic controller navigation',
        icon: Icons.navigation,
        screen: const ChangeNavigationScreen(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Diff Viewer Showcase'),
        centerTitle: false,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: demos.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = demos[index];
          return Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 8,
              ),
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Icon(
                  item.icon,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              title: Text(
                item.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(item.subtitle),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute<void>(builder: (_) => item.screen));
              },
            ),
          );
        },
      ),
    );
  }
}

class _DemoItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Widget screen;

  _DemoItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.screen,
  });
}
