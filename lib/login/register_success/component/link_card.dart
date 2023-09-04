import 'package:flutter/material.dart';

class InvitationCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height / 5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: Color(0xff1C1B1B),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50.0, left: 40.0,),
              child: Column(
                children: [
                  Image.asset(
                    'asset/image/fire_circular.png',
                    fit: BoxFit.fill,
                    width: 46.0,
                    height: 46.0,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    '모닥불',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Color(0xff9B9999),
                    ),
                  ),
                ],
              ),
            ),
            Image.asset(
              'asset/image/register_link.png',
              fit: BoxFit.cover,
              width: 260,
              height: 140,
            ),
          ],
        ),
      ),
    );
  }
}
