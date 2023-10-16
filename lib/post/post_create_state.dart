import 'dart:developer';

import 'package:flutter/material.dart';

class PostCreateState extends ChangeNotifier {
  final BuildContext context;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  bool isChecked = false;

  PostCreateState({
    required this.context,
  }) {
    initState();
  }

  void initState() {
    log('Instance "PostCreateState" has been created');
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    log('Instance "PostCreateState" has been removed');
    super.dispose();
  }

  void clearTitleTextField() {
    titleController.clear();
    notifyListeners();
  }

  void clearContentTextField() {
    contentController.clear();
    notifyListeners();
  }

  void toggleChecked(){
    isChecked = !isChecked;
    notifyListeners();
  }

  void updateTextField() {
    notifyListeners();
  }
}
