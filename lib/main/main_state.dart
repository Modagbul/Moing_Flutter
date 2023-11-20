import 'package:flutter/material.dart';
import 'package:moing_flutter/utils/dynamic_link/dynamic_link.dart';

class MainState extends ChangeNotifier {
  final BuildContext context;

  MainState({required this.context}) {
    print('Instance "MainState" has been created');
    DynamicLinkService(context: context);
  }
}
