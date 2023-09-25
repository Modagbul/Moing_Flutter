
import 'package:flutter/material.dart';

import '../../const/color/colors.dart';
import '../../const/style/text_field.dart' as style;

class OutlinedTextField extends StatefulWidget {
  final int maxLength;
  final int maxLines;
  final ValueChanged<String> onChanged;
  final VoidCallback onClearButtonPressed;
  final TextEditingController controller;
  final String labelText;
  final String counterText;
  final String hintText;
  final TextStyle labelTextStyle;
  final TextStyle counterTextStyle;
  final TextStyle inputTextStyle;

  const OutlinedTextField({
    super.key,
    required this.maxLength,
    required this.onChanged,
    required this.controller,
    required this.onClearButtonPressed,
    this.maxLines = 1,
    this.labelText = '',
    this.counterText = '',
    this.hintText = '',
    this.labelTextStyle = style.backgroundTextFieldStyle,
    this.counterTextStyle = style.backgroundTextFieldStyle,
    this.inputTextStyle = style.inputTextFieldStyle,
  });

  @override
  State<OutlinedTextField> createState() => _OutlinedTextFieldState();
}

class _OutlinedTextFieldState extends State<OutlinedTextField> {
  final FocusNode _focusNode = FocusNode();
  bool hasFocus = false;

  @override
  void initState() {
    super.initState();

    // 포커스 변경 이벤트를 감지하고 포커스 여부를 업데이트
    _focusNode.addListener(() {
      setState(() {
        hasFocus = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 레이블 텍스트 - 기본값 = '' (off)
        if (widget.labelText != '')
          Text(
            widget.labelText,
            // Textfield 포커스시 색상 변경
            style: widget.labelTextStyle.copyWith(
              color: hasFocus ? coralGrey200 : grayScaleGrey550,
            ),
          ),
        const SizedBox(
          height: 4.0,
        ),
        TextField(
          // 최대 길이
          maxLength: widget.maxLength,

          // 컨트롤러
          controller: widget.controller,

          // 텍스트 입력 감지
          onChanged: (value) {
            widget.onChanged(value);
          },

          // 포커스 컨트롤
          focusNode: _focusNode,

          maxLines: widget.maxLines,

          // 데코레이션
          decoration: InputDecoration(
            // 카운터 텍스트 - 기본값 == '' (off)
            counterText: widget.counterText,
            // 카운터 텍스트 스타일
            counterStyle: widget.counterTextStyle,

            // 힌트 텍스트 - 기본값 == '' (off)
            hintText: widget.hintText,
            // 힌트 텍스트 스타일
            hintStyle: widget.inputTextStyle.copyWith(
              color: grayScaleGrey550,
            ),

            // 배경색 활성화
            filled: true,
            // 배경색
            fillColor: grayScaleGrey700,

            // 외각선 색상 - 포커스
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: coralGrey200),
            ),

            // 삭제 버튼 - 값을 입력할 경우 활성화
            suffixIcon: widget.controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.close),
                    color: grayScaleGrey550,
                    // 버튼을 누를 경우 - 입력값 삭제
                    onPressed: widget.onClearButtonPressed,
                  )
                : null,
          ),

          // 입력 텍스트 스타일
          style: widget.inputTextStyle,

          // 커서 색상
          cursorColor: coralGrey200,
        ),
      ],
    );
  }
}