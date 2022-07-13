import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:horizonlabs_exam/src/repositories/darkmode/theme_controller.dart';

class Profile extends ConsumerWidget {
  const Profile({super.key});

  static const routeName = '/profile';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 50),
            const CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(
                'https://i.pravatar.cc/500',
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Anton Guinto',
              style: Theme.of(context).textTheme.headline5?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 40),
            SwitchListTile(
              value: ref.watch(isDarkTheme),
              onChanged: (_) {
                ref.watch(themeControllerProvider.notifier).updateThemeMode();
              },
              title: const Text('Dark Mode 🌙'),
            ),
          ],
        ),
      ),
    );
  }
}
