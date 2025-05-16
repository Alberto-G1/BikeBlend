import 'package:flutter/material.dart';

class SmoothPageIndicator extends StatelessWidget {
  final int count;
  final int activeIndex;
  final Color activeColor;
  final Color inactiveColor;
  final double dotWidth;
  final double dotHeight;
  final double spacing;
  final double radius;

  const SmoothPageIndicator({
    Key? key,
    required this.count,
    required this.activeIndex,
    this.activeColor = Colors.teal,
    this.inactiveColor = Colors.grey,
    this.dotWidth = 8.0,
    this.dotHeight = 8.0,
    this.spacing = 8.0,
    this.radius = 4.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (index) {
        final isActive = index == activeIndex;
        return Container(
          margin: EdgeInsets.symmetric(horizontal: spacing / 2),
          width: isActive ? dotWidth * 2 : dotWidth,
          height: dotHeight,
          decoration: BoxDecoration(
            color: isActive ? activeColor : inactiveColor,
            borderRadius: BorderRadius.circular(radius),
          ),
        );
      }),
    );
  }
}

class AnimatedSmoothIndicator extends StatelessWidget {
  final PageController controller;
  final int count;
  final Color activeColor;
  final Color inactiveColor;
  final double dotWidth;
  final double dotHeight;
  final double spacing;
  final double radius;
  final Axis axisDirection;
  final Function(int)? onDotClicked;

  const AnimatedSmoothIndicator({
    Key? key,
    required this.controller,
    required this.count,
    this.activeColor = Colors.teal,
    this.inactiveColor = Colors.grey,
    this.dotWidth = 8.0,
    this.dotHeight = 8.0,
    this.spacing = 8.0,
    this.radius = 4.0,
    this.axisDirection = Axis.horizontal,
    this.onDotClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final activeIndex = _calculateActiveIndex();
        return _buildIndicator(activeIndex);
      },
    );
  }

  double _calculateActiveIndex() {
    try {
      final position = controller.page ?? controller.initialPage.toDouble();
      return position;
    } catch (e) {
      return controller.initialPage.toDouble();
    }
  }

  Widget _buildIndicator(double activeIndex) {
    return axisDirection == Axis.horizontal
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: _buildDots(activeIndex),
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: _buildDots(activeIndex),
          );
  }

  List<Widget> _buildDots(double activeIndex) {
    return List.generate(count, (index) {
      final isActive = (index == activeIndex.floor() && activeIndex % 1 < 0.5) ||
          (index == activeIndex.ceil() && activeIndex % 1 >= 0.5);
      
      // Calculate width based on how close this dot is to being active
      double width = dotWidth;
      if (index == activeIndex.floor() && index == activeIndex.ceil()) {
        width = dotWidth * 2; // Fully active
      } else if (index == activeIndex.floor()) {
        width = dotWidth + (dotWidth * (1 - (activeIndex % 1)));
      } else if (index == activeIndex.ceil()) {
        width = dotWidth + (dotWidth * (activeIndex % 1));
      }
      
      return GestureDetector(
        onTap: onDotClicked != null ? () => onDotClicked!(index) : null,
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: axisDirection == Axis.horizontal ? spacing / 2 : 0,
            vertical: axisDirection == Axis.vertical ? spacing / 2 : 0,
          ),
          width: axisDirection == Axis.horizontal ? width : dotWidth,
          height: axisDirection == Axis.vertical ? width : dotHeight,
          decoration: BoxDecoration(
            color: isActive ? activeColor : inactiveColor,
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
      );
    });
  }
}
