import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/helper/get_file_extention.dart';
import 'package:aggar/core/helper/get_file_name.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class NameAndMessageChatView extends StatelessWidget {
  const NameAndMessageChatView({
    super.key,
    required this.name,
    required this.msg,
    required this.isMsg,
  });
  final String name;
  final String msg;
  final bool isMsg;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            overflow: TextOverflow.ellipsis,
            style: AppStyles.bold20(context).copyWith(
              color: context.theme.blue100_2,
            ),
          ),
          const Gap(6),
          isMsg == true
              ? Text(
                  msg,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyles.medium16(context)
                      .copyWith(color: context.theme.black50),
                )
              : getFileExtension(msg) == "JPG" ||
                      getFileExtension(msg) == "PNG" ||
                      getFileExtension(msg) == "GIF"
                  ? Row(
                      spacing: 5,
                      children: [
                        Icon(
                          Icons.image_outlined,
                          color: context.theme.black50,
                        ),
                        Text(
                          'Photo',
                          overflow: TextOverflow.ellipsis,
                          style: AppStyles.medium16(context)
                              .copyWith(color: context.theme.black50),
                        )
                      ],
                    )
                  : Row(
                      spacing: 5,
                      children: [
                        Icon(
                          Icons.file_copy_outlined,
                          color: context.theme.black50,
                        ),
                        Expanded(
                          child: Text(
                            getFileName(msg),
                            overflow: TextOverflow.ellipsis,
                            style: AppStyles.medium16(context)
                                .copyWith(color: context.theme.black50),
                          ),
                        )
                      ],
                    )
        ],
      ),
    );
  }
}
