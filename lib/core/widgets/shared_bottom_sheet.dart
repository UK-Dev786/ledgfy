import 'package:flutter/material.dart';
import 'package:ledgify/core/extensions/context_extensions.dart';

import '../constants/app_sizes.dart';
import 'my_card.dart';

class SharedBottomSheet extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? cardPadding;
  final double maxHeightFactor;

  const SharedBottomSheet({
    super.key,
    required this.child,
    this.cardPadding,
    this.maxHeightFactor = 0.9,
  });

  @override
  Widget build(BuildContext context) {
    final keyboardInset = MediaQuery.viewInsetsOf(context).bottom;
    final bottomPadding = context.h * 2 + context.paddingBottom;

    return AnimatedPadding(
      padding: EdgeInsets.only(bottom: keyboardInset),
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            context.w * 4,
            context.h * 2,
            context.w * 4,
            bottomPadding,
          ),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              builder: (context, value, animatedChild) {
                return FadeTransition(
                  opacity: AlwaysStoppedAnimation(value),
                  child: Transform.scale(
                    scale: 0.96 + (0.04 * value),
                    child: animatedChild,
                  ),
                );
              },
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight:
                      (context.screenHeight - keyboardInset) * maxHeightFactor,
                ),
                child: MyCard(
                  tint: MyCardTint.dark,
                  borderRadius: AppSizes.radiusLg,
                  blur: 30,
                  padding:
                      cardPadding ??
                      EdgeInsets.fromLTRB(
                        context.w * 5,
                        context.h * 3,
                        context.w * 5,
                        context.h * 3,
                      ),
                  child: SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    child: SizedBox(width: double.infinity, child: child),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
