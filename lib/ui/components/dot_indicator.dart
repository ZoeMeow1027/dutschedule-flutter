import 'package:flutter/material.dart';

class DotIndicator extends StatelessWidget {
  DotIndicator({
    super.key,
    required this.count,
    required this.activeIndex,
    this.colorActive = Colors.black,
    this.colorInactive = Colors.black26,
    this.showNavButton = true,
    this.navBackClick,
    this.navForwardClick,
    this.showFinishOnEndOfList = true,
  });

  final int count;
  final int activeIndex;
  final Color colorActive;
  final Color colorInactive;
  final double size = 13;
  final EdgeInsets padding = EdgeInsets.symmetric(horizontal: 2);
  final bool showNavButton;
  final bool showFinishOnEndOfList;
  final Function()? navBackClick;
  final Function(bool)? navForwardClick;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (showNavButton)
          Padding(
            padding: EdgeInsets.only(right: 40),
            child: IconButton(
              onPressed: activeIndex == 1 ? null : navBackClick,
              icon: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Icon(Icons.arrow_back),
              ),
            ),
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(
            count,
            (index) => _DotIndicatorShape(
              padding: padding,
              size: size,
              inactiveDot: colorInactive,
              activeDot: colorActive,
              isActive: index + 1 == activeIndex,
            ),
          ),
        ),
        if (showNavButton)
          Padding(
            padding: EdgeInsets.only(left: 40),
            child: IconButton(
              onPressed: showFinishOnEndOfList
                  ? navForwardClick?.call(activeIndex == count)
                  : activeIndex == count
                      ? null
                      : navForwardClick?.call(activeIndex == count),
              icon: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Icon(activeIndex == count ? Icons.check : Icons.arrow_forward),
              ),
            ),
          ),
      ],
    );
  }
}

class _DotIndicatorShape extends StatelessWidget {
  const _DotIndicatorShape({
    super.key,
    this.size = 20,
    this.inactiveDot = Colors.grey,
    this.activeDot = Colors.grey,
    this.padding = EdgeInsets.zero,
    this.isActive = false,
  });

  final double size;
  final Color inactiveDot;
  final Color activeDot;
  final EdgeInsets padding;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.circle,
          size: size,
          color: isActive ? activeDot : inactiveDot,
        ),
      ),
    );
  }
}
