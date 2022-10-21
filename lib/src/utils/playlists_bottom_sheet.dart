import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:humm/src/app/colors.dart';

import '../app/global_provider.dart';

Future<int?> openBottomSheet(BuildContext context) async {
  final int? val = await showModalBottomSheet<int>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 12),
              child: Text(
                "Add To Playlist",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Consumer(builder: (context, ref, child) {
              final value = ref.watch(listOfPlaylistProvider);
              return value.when(
                data: (lst) {
                  return ListView.builder(
                    padding: const EdgeInsets.only(top: 4, bottom: 16),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.offWhite,
                          radius: 36,
                          child: Icon(
                            Icons.music_note_rounded,
                            size: 26,
                          ),
                        ),
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
          ],
        );
      });
  return val;
}
