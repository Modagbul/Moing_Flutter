import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget {
  final String notificationCount;
  final void Function() onTap;

  const HomeAppBar({
    required this.notificationCount,
    required this.onTap,
    super.key});


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset(
          'asset/image/logo_moing.png',
          width: 65,
          height: 15,
        ),
        Spacer(),
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 21,
              height: 25,
              decoration: BoxDecoration(
                color: Color(0xffFF6464),
                shape: BoxShape.circle,
              ),
            ),
            Text(
              notificationCount,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        SizedBox(width: 4.0,),
        GestureDetector(
          onTap: onTap,
          child: Image.asset(
            'asset/image/notification.png',
            width: 24.0,
            height: 24.0,
          ),
        ),
      ],
    );
  }
}
