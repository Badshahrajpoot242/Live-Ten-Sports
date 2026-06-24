import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  final String appName;
  const AboutScreen({required this.appName, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About Us')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text('$appName\n\nCricket Live HD brings live cricket streaming to your device. All content is controlled from Firebase.', style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}
