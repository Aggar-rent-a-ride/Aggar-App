import 'package:aggar/core/extensions/context_colors_extension.dart';
import 'package:aggar/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class TimeAndNumberOfMsgChatView extends StatefulWidget {
  const TimeAndNumberOfMsgChatView({
    super.key,
    required this.time,
    required this.numberMsg,
    this.delay = const Duration(milliseconds: 500),
  });

  final String time;
  final int numberMsg;
  final Duration delay;

  @override
  State<TimeAndNumberOfMsgChatView> createState() =>
      _TimeAndNumberOfMsgChatViewState();
}

class _TimeAndNumberOfMsgChatViewState extends State<TimeAndNumberOfMsgChatView>
    with SingleTickerProviderStateMixin {
  bool _isVisible = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    Future.delayed(widget.delay, () {
      if (mounted) {
        setState(() {
          _isVisible = true;
        });
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isVisible
        ? FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                Text(
                  widget.time,
                  style: AppStyles.medium14(context).copyWith(
                    color: context.theme.black50,
                  ),
                ),
                const Gap(6),
                widget.numberMsg == 0
                    ? const SizedBox(
                        height: 25,
                        width: 25,
                      )
                    : Container(
                        height: 25,
                        width: 25,
                        decoration: BoxDecoration(
                          color: context.theme.blue100_3,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Center(
                          child: Text(
                            widget.numberMsg.toString(),
                            style: AppStyles.medium12(context),
                          ),
                        ),
                      ),
              ],
            ),
          )
        : const SizedBox.shrink();
  }
}
