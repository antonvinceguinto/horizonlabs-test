import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:horizonlabs_exam/src/repositories/darkmode/theme_controller.dart';

class Profile extends ConsumerWidget {
  const Profile({super.key});

  static const routeName = '/profile';

  Widget _item(
    String label,
    void Function(bool) onChanged,
    WidgetRef ref,
  ) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ref.watch(isDarkTheme) ? Colors.grey : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: SwitchListTile(
        value: ref.watch(isDarkTheme),
        onChanged: onChanged,
        title: Text(label),
      ),
    );
  }

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
            Text(
              'antonvinceguinto@gmail.com',
              style: Theme.of(context).textTheme.subtitle2,
            ),
            const SizedBox(height: 40),
            _item(
              'Dark Mode 🌙',
              (_) {
                ref.watch(themeControllerProvider.notifier).updateThemeMode();
              },
              ref,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: ListTile(
                onTap: () {},
                title: const Text(
                  'Sign Out',
                  style: TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
