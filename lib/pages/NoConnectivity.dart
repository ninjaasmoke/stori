import 'package:flutter/material.dart';

class NoConnectivityPage extends StatelessWidget {
  const NoConnectivityPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/conn.png'),
      ),
    );
  }
}
