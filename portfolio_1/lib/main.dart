import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Portfolio Layout',
      home: Scaffold(
        appBar: AppBar(title: const Text('First Portfolio Exam')),
        body: Column(
          children: [
            // Orange box (fixed height, border)
            Container(
              height: 80,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.orange,
                border: Border.all(color: Colors.black),
              ),
              alignment: Alignment.center,
              child: const Text(
                'Orange Box',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),

            // Middle area (flexible height)
            Expanded(
              child: Column(
                children: [
                  // First grey box (fixed size)
                  Container(
                    height: 100,
                    width: double.infinity,
                    color: Colors.grey,
                    alignment: Alignment.center,
                    child: const Text('Grey Box 1'),
                  ),

                  // Spacer to make the space between grey boxes flexible
                  const Spacer(),

                  // Second grey box (fixed size)
                  Container(
                    height: 100,
                    width: double.infinity,
                    color: Colors.grey,
                    alignment: Alignment.center,
                    child: const Text('Grey Box 2'),
                  ),
                ],
              ),
            ),

            // Blue box (fixed height, border) with logo
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.blue,
                border: Border.all(color: Colors.black),
              ),
              // Replace with your own logo asset
              child: Center(
                child: Image(
                  image: AssetImage('assets/thws_logo.png'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
