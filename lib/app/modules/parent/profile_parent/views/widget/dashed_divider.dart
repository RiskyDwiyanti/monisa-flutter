import 'package:flutter/material.dart';

/// Garis horizontal putus-putus, dipakai sebagai pemisah antar item menu.
class DashedDividerParent extends StatelessWidget {
  final double height;
  final Color color;
  final double dashWidth;
  final double dashGap;

  DashedDividerParent({
    super.key,
    this.height = 1,
    this.color = Colors.black,
    this.dashWidth = 10,
    this.dashGap = 6,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final boxWidth = constraints.constrainWidth();
        final dashCount = (boxWidth / (dashWidth + dashGap)).floor();
        return Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.start,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: height,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }).expand((widget) => [widget, SizedBox(width: dashGap)]).toList(),
        );
      },
    );
  }
}