import 'package:flutter/material.dart';
import 'package:humm/src/app/colors.dart';
import 'package:humm/src/view/folders/folder_page.dart';

class FolderTile extends StatelessWidget {
  const FolderTile({super.key, required this.folder});

  final String folder;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.pushNamed(context, FolderPage.routeName,arguments: folder);
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
