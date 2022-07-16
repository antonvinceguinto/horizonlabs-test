import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:horizonlabs_exam/src/repositories/darkmode/theme_controller.dart';

class SearchField extends ConsumerWidget {
  const SearchField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      height: 75,
      color: Theme.of(context).backgroundColor,
      child: TextField(
        cursorColor: Colors.blueGrey,
        cursorHeight: 17,
        decoration: InputDecoration(
          iconColor: Colors.grey.shade800,
          prefixIcon: Icon(
            Icons.search,
            color: Colors.blueGrey.shade500,
          ),
          focusColor: Colors.grey.shade800,
          filled: true,
          fillColor:
              ref.watch(isDarkTheme) ? Colors.black : Colors.grey.shade200,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide.none,
            gapPadding: 0,
          ),
          hintText: 'Search',
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }
}
