import 'package:flutter/material.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/const/style/text.dart';
import 'package:moing_flutter/login/date/component/custom_date_picker_scroll_view_options.dart';
import 'package:moing_flutter/login/date/component/custom_scroll_date_picker.dart';
import 'package:moing_flutter/login/date/sign_up_date_state.dart';
import 'package:moing_flutter/utils/button/white_button.dart';
import 'package:provider/provider.dart';

class SignUpDatePage extends StatelessWidget {
  const SignUpDatePage({super.key});

  static const routeName = '/sign/up/date';

  static route(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => SignUpDateState(context: context)),
      ],
      builder: (context, _) {
        return const SignUpDatePage();
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: grayBackground,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Image.asset(
            'asset/image/arrow_left.png',
          ),
        ),
      ),
      backgroundColor: grayBackground,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 64,
              ),
              Container(
                padding:
                const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
                decoration: BoxDecoration(
                  color: grayScaleGrey600,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: const Text(
                  '간단 프로필 등록 2/2',
                  style: TextStyle(
                    color: grayScaleGrey550,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              const Text(
                '모닥불님의',
                style: headerTextStyle,
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                '생일은 언제인가요?',
                style: headerTextStyle,
              ),
              const SizedBox(height: 52.0),
              SizedBox(
                height: 250,
                child: ScrollDatePicker(
                  selectedDate: context.watch<SignUpDateState>().selectedDate,
                  locale: const Locale('ko'),
                  scrollViewOptions: const DatePickerScrollViewOptions(
                    year: ScrollViewDetailOptions(
                      label: '년',
                      margin: const EdgeInsets.only(right: 8),
                    ),
                    month: ScrollViewDetailOptions(
                      label: '월',
                      margin: const EdgeInsets.only(right: 8),
                    ),
                    day: ScrollViewDetailOptions(
                      label: '일',
                    )
                  ),
                  onDateTimeChanged: (DateTime value) {
                    context.read<SignUpDateState>().changeDate(value);
                  },
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 32.0),
                child: WhiteButton(
                    onPressed: (){
                      context.read<SignUpDateState>().nextPressed();
                    },
                    text: '다음으로'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
