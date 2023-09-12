import 'package:flutter/material.dart';

class OnBoardingComponent extends StatelessWidget {
  final void Function() onPressed;
  final String imagePath;
  final String onBoardingPhase1, onBoardingPhase2;

  const OnBoardingComponent({
    required this.imagePath,
    required this.onPressed,
    required this.onBoardingPhase1,
    required this.onBoardingPhase2,
    super.key,
});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [


              const SizedBox(height: 32.0,),
              const Text(
                '모잉불과 함께 \n우리 모임을 불태울 수 있어요',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Color(0xffF4F6F8),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 88.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                      onBoardingPhase1,
                  ),
                  const SizedBox(width: 8.0,),
                  Image.asset(
                      onBoardingPhase2,
                  ),
                  const SizedBox(width: 8.0,),
                  Image.asset(
                      onBoardingPhase2,
                  ),
                ],
              ),
              const SizedBox(height: 72.0,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ElevatedButton(
                  onPressed: onPressed,
                  style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all(
                        Size(MediaQuery.of(context).size.width, 60),
                      ),
                      backgroundColor: MaterialStateProperty.all(Colors.transparent),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: const BorderSide(color: Color(0xff9B9999),
                          ),
                        ),
                      )
                  ),
                  child: const Text(
                    '다음으로',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Color(0xffF1F1F1),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
