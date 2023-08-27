import 'package:flutter/material.dart';

class SocialSignOutButton extends StatelessWidget {
  final void Function() onTap;
  const SocialSignOutButton({
    required this.onTap,
    super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          const Color(0xff0165E1),
        ),
      ),
      child: const Text('로그아웃'),
    );
  }
}
