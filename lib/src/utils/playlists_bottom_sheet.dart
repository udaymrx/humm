import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app/global_provider.dart';

Future<int?> openBottomSheet(BuildContext context) async {
  final int? val = await showModalBottomSheet<int>(
      context: context,
      builder: (context) {
        return Container(
          width: double.maxFinite,
          padding: const EdgeInsets.all(20),
          child: Consumer(builder: (context, ref, child) {
            final value = ref.watch(listOfPlaylistProvider);
            return value.when(
              data: (lst) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(lst[index].playlistName),
                      onTap: () {
                        context.popRoute(lst[index].key);
                      },
                    );
                  },
                  itemCount: lst.length,
                );
              },
              error: (error, stackTrace) => const SizedBox(
                height: 300,
              ),
              loading: () => const Text("Loading..."),
            );
          }),
        );
      });
  return val;
}
