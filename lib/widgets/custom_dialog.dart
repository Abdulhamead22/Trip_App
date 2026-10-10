import 'package:flutter/material.dart';

Future<T?> customDialog<T>({
  required String title,
  required BuildContext context,
  Widget? content,
  List<Widget>? actions,
}) {
  return showDialog<T>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text(title),
        content: content,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
            },
            child: const Text('Cancel'),
          ),
          //معناها انو اذا ضفت شي ضيفو جنب الزر

          if (actions != null) ...actions,
        ],
      );
    },
  );
}
