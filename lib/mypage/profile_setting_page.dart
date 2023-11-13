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
      appBar: _renderAppBar(context: context),
      backgroundColor: grayBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),
              _Profile(),
              const _TextFields(),
              const _SubmitButton(),
            ],
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

  final AssetImage defaultProfileImg = const AssetImage(
    'asset/image/icon_user_profile.png',
  );

  final Image editProfileImg = Image.asset(
    'asset/image/icon_gallery.png',
    width: 24.0,
    height: 24.0,
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => context.read<ProfileSettingState>().imageUpload(context),
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircleAvatar(
            radius: 40.0,
            backgroundImage: defaultProfileImg,
          ),
          CircleAvatar(
            radius: 40.0,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(40.0),
                child: _buildImage(context),
              ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    if (context.watch<ProfileSettingState>().avatarFile == null &&
        context.watch<ProfileSettingState>().getProfileImageUrl != null) {
      return Image.network(
          context.watch<ProfileSettingState>().getProfileImageUrl!,
          fit: BoxFit.cover,
          width: 80.0,
          height: 80.0,
          );
    } else if (context.watch<ProfileSettingState>().avatarFile != null) {
      return Image.file(
        File(context.watch<ProfileSettingState>().avatarFile!.path),
        fit: BoxFit.cover,
        width: 80.0,
        height: 80.0,
      );
    } else {
      return Image(
        image: defaultProfileImg,
        fit: BoxFit.cover,
        width: 80.0,
        height: 80.0,
      );
    }
  }
}

class _TextFields extends StatelessWidget {
  const _TextFields();

  @override
  Widget build(BuildContext context) {
    return Column(
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
        ),
        OutlinedTextField(
          maxLength: 50,
          maxLines: 10,
          labelText: '한줄다짐',
          counterText:
              '(${context.watch<ProfileSettingState>().resolutionController.text.length}/50)',
          onChanged: (value) =>
              context.read<ProfileSettingState>().updateTextField(),
          controller: context.read<ProfileSettingState>().introduceController,
          inputTextStyle: bodyTextStyle.copyWith(color: grayBlack2),
          onClearButtonPressed:
              context.read<ProfileSettingState>().clearIntroduceTextField,
        ),
      ],
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: grayScaleWhite,
        foregroundColor: grayScaleGrey900,
        disabledBackgroundColor: grayScaleGrey700,
        disabledForegroundColor: grayScaleGrey500,
        textStyle: const TextStyle(
          color: grayScaleGrey900,
          fontSize: 18.0,
          fontWeight: FontWeight.w600,
        ),
        padding: const EdgeInsets.all(16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      onPressed: context.read<ProfileSettingState>().savePressed,
      child: const Text('수정 완료'),
    );
  }
}
