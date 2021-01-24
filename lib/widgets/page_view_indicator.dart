import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';

class PageViewSliderIndicator extends StatefulWidget {
  double currentIndexPage;
  PageViewSliderIndicator({this.currentIndexPage});

  @override
  _PageViewSliderIndicatorState createState() => _PageViewSliderIndicatorState();
}

class _PageViewSliderIndicatorState extends State<PageViewSliderIndicator> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DotsIndicator(
            dotsCount: 3,
            position: widget.currentIndexPage
        ),
      ],
    )
    ;
  }
}
