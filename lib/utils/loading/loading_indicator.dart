import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  final Color color;
  final double strokeWidth;

  const LoadingIndicator({
    super.key,
    this.color = Colors.grey,
    this.strokeWidth = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(color),
      strokeWidth: strokeWidth,
    );
  }
}
