import 'dart:io';

import 'package:flutter/material.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/const/style/text.dart';
import 'package:moing_flutter/make_group/group_create_photo_state.dart';
import 'package:provider/provider.dart';

class GroupCreatePhotoPage extends StatelessWidget {
  static const routeName = '/meeting/photo';

  const GroupCreatePhotoPage({super.key});

  static route(BuildContext context) {
    final Map<String, dynamic> data =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final String category = data['category'] as String;
    final String name = data['name'] as String;
    final String introduce = data['introduce'] as String;
    final String promise = data['promise'] as String;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => GroupCreatePhotoState(
                category: category,
                name: name,
                introduction: introduce,
                promise: promise,
                context: context)),
      ],
      builder: (context, _) {
        return const GroupCreatePhotoPage();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                height: 34.0,
              ),
              const Text(
                '우리 소모임을 나타내는\n사진이 필요해요!',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                  color: grayScaleGrey100,
                  height: 1.3,
                ),
              ),
              const SizedBox(
                height: 12.0,
              ),
              const Text(
                '소모임의 대표 사진은 홈 화면에서의 썸네일로 적용되어요.\n소모임 개설 이후 자유롭게 변경 가능하니 걱정마세요!',
                style: TextStyle(
                  fontSize: 14,
                  color: grayScaleGrey550,
                  fontWeight: FontWeight.w500,
                  height: 1.7,
                ),
              ),
              SizedBox(
                height: context.watch<GroupCreatePhotoState>().avatarFile == null ? 104.0 : 49,
              ),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () =>
                    context.read<GroupCreatePhotoState>().imageUpload(context),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32.0),
                        color: grayScaleGrey700,
                      ),
                      width: MediaQuery.of(context).size.width,
                      height:
                          context.watch<GroupCreatePhotoState>().avatarFile ==
                                  null
                              ? 205
                              : 255,
                      child:
                          context.watch<GroupCreatePhotoState>().avatarFile ==
                                  null
                              ? _ContainerText()
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(32.0),
                                  child: Image.file(
                                    File(context
                                        .watch<GroupCreatePhotoState>()
                                        .avatarFile!
                                        .path),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 16.0,
              ),
              context.watch<GroupCreatePhotoState>().avatarFile == null
                  ? const SizedBox.shrink()
                  : SizedBox(
                      height: 60,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: grayScaleGrey700,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(48), // 버튼의 모서리 둥글게
                          ),
                        ),
                        onPressed: () => context
                            .read<GroupCreatePhotoState>()
                            .imageUpload(context),
                        child: const Text(
                          '다시 고르기',
                          style: TextStyle(
                            color: grayScaleGrey100,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 60,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: grayScaleGrey600,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(16), // 버튼의 모서리 둥글게
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            '이전으로',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: grayScaleGrey300,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 60,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            overlayColor:
                                MaterialStateProperty.all(Colors.transparent),
                            minimumSize: MaterialStateProperty.all<Size>(
                                Size(double.infinity, 60)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                            ),
                            backgroundColor: context
                                        .watch<GroupCreatePhotoState>()
                                        .avatarFile !=
                                    null
                                ? MaterialStateProperty.all(Colors.white)
                                : MaterialStateProperty.all(grayScaleGrey700),
                          ),
                          onPressed: () {
                            context.read<GroupCreatePhotoState>().makePressed();
                          },
                          child: Text(
                            '만들기',
                            style: context
                                        .watch<GroupCreatePhotoState>()
                                        .avatarFile !=
                                    null
                                ? buttonTextStyle
                                : buttonTextStyle.copyWith(
                                    color: grayScaleGrey500,
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget _ContainerText() {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Image.asset(
        'asset/image/image_upload.png',
      ),
      const SizedBox(
        width: 12.0,
      ),
      const Text(
        '사진 업로드하기',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: grayScaleGrey100,
          fontSize: 16,
        ),
      ),
    ],
  );
}
