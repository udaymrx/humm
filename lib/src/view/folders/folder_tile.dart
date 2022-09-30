import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:humm/src/app/colors.dart';
import 'package:humm/src/app/router/router.gr.dart';

class FolderTile extends StatelessWidget {
  const FolderTile({super.key, required this.folder});

  final String folder;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        context.router.push(FolderRoute(path: folder));
      },
      title: Text(folder.split('/').last),
      leading: const Icon(
        Icons.folder,
        color: AppColors.primary,
        size: 48,
      ),
      trailing: IconButton(
        onPressed: () {},
        icon: const Icon(Icons.more_vert),
      ),
    );
  }
}
