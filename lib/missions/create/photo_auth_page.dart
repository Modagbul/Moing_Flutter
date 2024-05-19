import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moing_flutter/const/style/text.dart';
import 'package:moing_flutter/missions/create/photo_auth_state.dart';
import 'package:provider/provider.dart';
import 'package:speech_balloon/speech_balloon.dart';

import '../../const/color/colors.dart';
import '../../utils/text_field/outlined_text_field.dart';

class PhotoAuthPage extends StatelessWidget {
  static const routeName = '/missions/auth/photo';
  const PhotoAuthPage({Key? key}) : super(key: key);

  static route(BuildContext context) {
    final XFile file = ModalRoute.of(context)?.settings.arguments as XFile;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => PhotoAuthState(context: context, avatarFile: file),
          lazy: false,
        ),
      ],
      builder: (context, _) {
        return const PhotoAuthPage();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var state = context.watch<PhotoAuthState>();
    final controller = ScrollController();
    return Scaffold(
      backgroundColor: grayScaleGrey900,
      appBar: renderAppBar(context: context, title: '사진으로 인증하기'),
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: SingleChildScrollView(
          controller: controller,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 32),
                    Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 265,
                          decoration: BoxDecoration(
                            color: grayScaleGrey700,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.file(
                              File(state.avatarFile.path),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 16, bottom: 16,
                          child: _changePhoto(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    OutlinedTextField(
                      maxLength: 1000,
                      maxLines: 10,
                      counterText: '(${context.watch<PhotoAuthState>().textController.text.length}/1000)',
                      hintText: '(선택) 사진과 함께 올릴 나만의 글을 작성해보세요',
                      onChanged: (value) => context.read<PhotoAuthState>().updateTextField(),
                      controller: context.read<PhotoAuthState>().textController,
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
                Positioned(
                  right: 4, top: 275,
                  child: state.isShowBalloon? _balloonText(context) : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _completeButton(context),
    );
  }

  Widget _changePhoto(BuildContext context) {
    return GestureDetector(
      onTap: () => context.read<PhotoAuthState>().changePhoto(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        height: 36,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          color: grayScaleGrey600,
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              'asset/icons/image_upload.svg',
              fit: BoxFit.fill,
              width: 20,
              height: 20,
            ),
            const SizedBox(width: 4),
            Text('사진변경', style: bodyTextStyle.copyWith(color: grayScaleGrey200))
          ],
        ),
      ),
    );
  }

  Widget _balloonText(BuildContext context) {
    return SpeechBalloon(
      color: coralGrey500,
      width: MediaQuery.of(context).size.width * 0.55,
      height: 33,
      borderRadius: 24,
      nipLocation: NipLocation.bottom,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '이제 사진과 글을 함께 쓸 수 있어요',
            style: bodyTextStyle.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _completeButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 32, top: 16),
      child: SizedBox(
        width: 353,
        height: 62,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: grayScaleWhite,
            disabledBackgroundColor: grayScaleGrey700,
            disabledForegroundColor: grayScaleGrey500,
            padding: const EdgeInsets.all(16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
          ),
          onPressed: () => context.read<PhotoAuthState>().submit(),
          child: const Text(
            '인증하기',
            style: TextStyle(
              color: grayScaleGrey700,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget renderAppBar({
    required BuildContext context,
    required String title,
  }) {
    return AppBar(
      backgroundColor: grayScaleGrey900,
      elevation: 0,
      title: Text(title),
      centerTitle: false,
      leading: IconButton(
        icon: const Icon(Icons.close), // 뒤로 가기 아이콘
        onPressed: () => context.read<PhotoAuthState>().showEndRepeatModal(context: context),
      ),
    );
  }
}
