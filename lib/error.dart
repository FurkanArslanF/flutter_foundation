import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ErrorView extends StatelessWidget {
  const ErrorView({super.key, this.message});
  final String? message;

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Error')));
  }
}

class CheckInternet extends StatelessWidget {
  const CheckInternet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off, size: 10.w, color: Colors.white),
            const Text(
              "No Internet Connection",
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
