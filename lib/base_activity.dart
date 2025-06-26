import 'package:flutter/material.dart';

class BaseActivity extends StatelessWidget {
  final String title;
  final Widget body;

  const BaseActivity({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color.fromARGB(255, 66, 62, 62),
        foregroundColor: Colors.red,
      ),
      body: Container(
        decoration: BoxDecoration(
          // image: DecorationImage(
          //   image: AssetImage('assets/images/erickfy.png'),
          //   fit: BoxFit.cover,
          // ),
        ),
        child: body,
      ),
    );
  }
}
