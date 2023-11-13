import 'package:flutter/material.dart';
import 'package:moing_flutter/const/color/colors.dart';

class ListCustomTile extends StatelessWidget {
  final String listName;
  final String imagePath;
  final VoidCallback onTap;

  const ListCustomTile({
    super.key,
    required this.listName,
    required this.imagePath,
    required this.onTap,
  });


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        title: Text(
          listName,
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            color: grayScaleGrey100,
          ),
        ),
        trailing: Container(
          height: 24.0,
          width: 24.0,
          child: Image.asset(imagePath),
        ),
        onTap: onTap,
      ),
    );
  }
}