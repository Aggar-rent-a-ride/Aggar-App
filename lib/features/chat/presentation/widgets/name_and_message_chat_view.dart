import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class NameAndMessageChatView extends StatelessWidget {
  const NameAndMessageChatView({
    super.key,
    required this.name,
    required this.msg,
  });
  final String name;
  final String msg;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.64,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(6),
          Text(
            msg,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
