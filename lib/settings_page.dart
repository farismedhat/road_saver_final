import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:road_saver/providers/language_provider.dart';
import 'package:road_saver/providers/theme_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          languageProvider.locale.languageCode == 'ar' ? 'الإعدادات' : 'Settings',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Language Selection
            Text(
              languageProvider.locale.languageCode == 'ar' ? 'اللغة' : 'Language',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                ChoiceChip(
                  label: const Text('English'),
                  selected: languageProvider.locale.languageCode == 'en',
                  onSelected: (selected) {
                    if (selected) languageProvider.setLanguage('en');
                  },
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('العربية'),
                  selected: languageProvider.locale.languageCode == 'ar',
                  onSelected: (selected) {
                    if (selected) languageProvider.setLanguage('ar');
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Theme Selection
            Text(
              languageProvider.locale.languageCode == 'ar' ? 'المظهر' : 'Theme',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              title: Text(
                languageProvider.locale.languageCode == 'ar'
                    ? (themeProvider.isDarkMode ? 'الوضع الداكن' : 'الوضع الفاتح')
                    : (themeProvider.isDarkMode ? 'Dark Mode' : 'Light Mode'),
              ),
              value: themeProvider.isDarkMode,
              onChanged: (value) => themeProvider.toggleTheme(),
            ),
          ],
        ),
      ),
    );
  }
} 