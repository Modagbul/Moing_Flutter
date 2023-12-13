import 'dart:io';

import 'package:flutter/material.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/mypage/profile_setting_state.dart';
import 'package:moing_flutter/utils/text_field/outlined_text_field.dart';
import 'package:provider/provider.dart';

import '../const/style/text.dart';

class ProfileSettingPage extends StatelessWidget {
  const ProfileSettingPage({super.key});

  static const routeName = '/mypage/setting/profile';

  static route(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProfileSettingState(
            context: context,
          ),
        ),
      ],
      builder: (context, _) {
        return const ProfileSettingPage();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _renderAppBar(context: context),
      backgroundColor: grayBackground,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                const SizedBox(height: 40),
                _Profile(),
                const SizedBox(height: 32),
                const _TextFields(),
                Spacer(),
                _SubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _renderAppBar({required BuildContext context}) {
    return AppBar(
      backgroundColor: grayBackground,
      elevation: 0.0,
      title: const Text('프로필 설정'),
      centerTitle: false,
      leading: IconButton(
        icon: const Icon(
          Icons.close,
        ),
        onPressed: context.read<ProfileSettingState>().pressCloseButton,
      ),
    );
  }
}

class _Profile extends StatelessWidget {
  _Profile();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => context.read<ProfileSettingState>().imageUpload(context),
      child: Stack(
        children: [
          // 프로필 사진이 없을 때
          if(context.watch<ProfileSettingState>().profileData?.profileImage == null ||
              context.watch<ProfileSettingState>().profileData!.profileImage!.isEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Image.asset(
                'asset/image/icon_user_profile.png',
                width: 80.0,
                height: 80.0,
              ),
            ),
          // 프로필 사진이 있고, 수정 전일 때
          if (context.watch<ProfileSettingState>().avatarFile == null &&
              context.watch<ProfileSettingState>().profileData?.profileImage != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Image.network(
                context.watch<ProfileSettingState>().profileData!.profileImage!,
                fit: BoxFit.cover,
                width: 80.0,
                height: 80.0,
              ),
            ),
          if(context.watch<ProfileSettingState>().avatarFile != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Image.file(
                File(context.watch<ProfileSettingState>().avatarFile!.path),
                fit: BoxFit.cover,
                width: 80.0,
                height: 80.0,
              ),
            ),
          Positioned(
            bottom: 0,
              right: 0,
              child: Image.asset(
                'asset/image/icon_gallery.png',
                width: 32.0,
                height: 32.0,
              ),
          ),
        ],
      ),
    );
  }
}

class _TextFields extends StatelessWidget {
  const _TextFields();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            OutlinedTextField(
              maxLength: 10,
              maxLines: 1,
              labelText: '닉네임',
              counterText:
                  '(${context.watch<ProfileSettingState>().nameController.text.length}/10)',
              hintText: '나를 잘 표현하는 닉네임으로 설정해주세요.',
              onChanged: (value) =>
                  context.read<ProfileSettingState>().updateTextField(),
              controller: context.read<ProfileSettingState>().nameController,
              inputTextStyle: contentTextStyle.copyWith(color: grayBlack2),
              onClearButtonPressed:
                  context.read<ProfileSettingState>().clearNameTextField,
              borderSideColor: context.watch<ProfileSettingState>().isNickNameOverlapped ? errorColor : null,
            ),
            if(context.watch<ProfileSettingState>().isNickNameOverlapped)
            Positioned(
                left: 0,
                bottom: 0,
                child: Text(
                  '중복된 닉네임이에요',
                  style: bodyTextStyle.copyWith(color: errorColor, fontWeight: FontWeight.w500),
                ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        OutlinedTextField(
          maxLength: 50,
          maxLines: 10,
          labelText: '한줄다짐',
          counterText:
              '(${context.watch<ProfileSettingState>().introduceController.text.length}/50)',
          onChanged: (value) =>
              context.read<ProfileSettingState>().updateTextField(),
          controller: context.read<ProfileSettingState>().introduceController,
          inputTextStyle: bodyTextStyle.copyWith(color: grayBlack2),
        ),
      ],
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32.0),
      child: SizedBox(
        width: double.infinity,
        height: 62,
        child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: (context.watch<ProfileSettingState>().isSubmit)
                  ? MaterialStateProperty.all(grayScaleWhite)
                  : MaterialStateProperty.all(grayScaleGrey700),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
            ),
            overlayColor: (context.watch<ProfileSettingState>().isAvatarChanged ||
                context.watch<ProfileSettingState>().isIntroduceChanged ||
                context.watch<ProfileSettingState>().isNameChanged )
              ? null
                : MaterialStateProperty.all(Colors.transparent),
          ),
          onPressed: context.read<ProfileSettingState>().savePressed,
          child: Text('수정 완료', style: TextStyle(
        color: (context.watch<ProfileSettingState>().isSubmit)
         ? grayScaleGrey900 : grayScaleGrey500,
        fontSize: 18.0,
        fontWeight: FontWeight.w600,
      ),),
        ),
      ),
    );
  }
}
