import 'package:flutter/material.dart';
import 'package:flutter_app_framework/shared/widgets/text/app_text.dart';

class ExamplePage extends StatelessWidget {
  const ExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: AppText('ExamplePage', fontSize: 30)),
    );
  }
}
