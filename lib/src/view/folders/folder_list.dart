import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:humm/src/view/folders/folder_tile.dart';

import '../../app/global_provider.dart';

final folderProvider = FutureProvider<List<String>>((ref) async {
  final audioService = ref.read(audioQueryProvider);
  return await audioService.getFoldersPath();
});

class FolderList extends ConsumerWidget {
  const FolderList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final res = ref.watch(folderProvider);
    return res.when(
        data: (data) {
          return ListView.builder(
            itemBuilder: (context, index) {
              return FolderTile(
                folder: data[index],
              );
            },
            itemCount: data.length,
          );
        },
        error: (error, st) => Center(child: Text(error.toString())),
        loading: () => const Center(child: CircularProgressIndicator()));
  }
}
