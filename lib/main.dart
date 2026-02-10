import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: WindTheme.toThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: Center(
          child: WCard(
            className: 'shadow-lg rounded-lg m-4 p-4 bg-blue-500',
            child: WFlex(
              className: 'flex-col axis-min gap-2 items-start',
              children: [
                WText('Welcome to Wind', className: 'text-2xl font-bold text-white'),
                WText('Utility-first styling for Flutter', className: 'text-white'),
                WText(
                  'This is styled using Tailwind-like class names!',
                  className: 'text-blue-100 text-xs',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}