import 'package:flutter/material.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/mypage/profile_setting_state.dart';
import 'package:moing_flutter/utils/text_field/outlined_text_field.dart';
import 'package:provider/provider.dart';

class ProfileSettingPage extends StatelessWidget {
  const ProfileSettingPage({super.key});

  static const routeName = '/mypage/setting';

  static route(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => ProfileSettingState(context: context)),
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
      onTap: () {},
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 40.0,
                backgroundImage: defaultProfileImg,
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: editProfileImg,
              ),
            ],
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
          onClearButtonPressed: () =>
              context.read<ProfileSettingState>().clearNameTextField(),
        ),
        OutlinedTextField(
          maxLength: 50,
          maxLines: 10,
          labelText: '한줄다짐',
          counterText:
              '(${context.watch<ProfileSettingState>().resolutionController.text.length}/50)',
          hintText: '마이페이지에서 확인할 수 있어요.',
          onChanged: (value) =>
              context.read<ProfileSettingState>().updateTextField(),
          controller: context.read<ProfileSettingState>().resolutionController,
          onClearButtonPressed: () =>
              context.read<ProfileSettingState>().clearResolutionTextField(),
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
      onPressed: () {},
      child: const Text('수정 완료'),
    );
  }
}
