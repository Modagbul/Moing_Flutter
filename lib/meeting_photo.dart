import 'dart:io';

import 'package:flutter/material.dart';
import 'package:moing_flutter/const/color/colors.dart';
import 'package:moing_flutter/meeting_photo_state.dart';
import 'package:provider/provider.dart';

class MeetingPhotoPage extends StatelessWidget {
  static const routeName = '/meeting/photo';

  static route(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => MeetingPhotoState(context: context)),
      ],
      builder: (context, _) {
        return MeetingPhotoPage();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {} // Navigator.of(context).pop(),
            ),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 34.0,
              ),
              Text(
                '우리 소모임을 나타내는\n사진이 필요해요!',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                  color: grayScaleGrey100,
                ),
              ),
              SizedBox(
                height: 12.0,
              ),
              Text(
                '소모임의 대표 사진은 홈 화면에서의 썸네일로 적용되어요.\n소모임 개설 이후 자유롭게 변경 가능하니 걱정마세요!',
                style: TextStyle(
                  fontSize: 14,
                  color: grayScaleGrey550,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: 104.0,
              ),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () =>
                    context.read<MeetingPhotoState>().imageUpload(context),
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
                          context.watch<MeetingPhotoState>().avatarFile == null
                              ? 205
                              : 255,
                      child:
                          context.watch<MeetingPhotoState>().avatarFile == null
                              ? _ContainerText()
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(32.0),
                                  child: Image.file(
                                    File(context
                                        .watch<MeetingPhotoState>()
                                        .avatarFile!
                                        .path),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
              context.watch<MeetingPhotoState>().avatarFile == null
                  ? SizedBox.shrink()
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
                            .read<MeetingPhotoState>()
                            .imageUpload(context),
                        child: Text(
                          '다시 고르기',
                          style: TextStyle(
                            color: grayScaleGrey100,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
              Spacer(),
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
                          onPressed: () {},
                          child: Text(
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
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 60,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: grayScaleWhite,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(16), // 버튼의 모서리 둥글게
                            ),
                          ),
                          onPressed: () {},
                          child: Text(
                            '만들기',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: grayScaleGrey900,
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
      SizedBox(
        width: 12.0,
      ),
      Text(
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
