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
        appBar: AppBar(
          title: const Text('First Portfolio Exam'),
          backgroundColor: Colors.blue,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),

              // "Welcome" box
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  border: Border.all(color: Colors.black, width: 3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Welcome',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),

              const SizedBox(height: 40),

              // Row with three boxes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Black box (TAMK)
                  Container(
                    height: 100,
                    width: 80,
                    color: Colors.black,
                    alignment: Alignment.center,
                    child: const Text(
                      'TAMK',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),

                  // Dark grey box (Flutter!) rotated vertically
                  Container(
                    height: 120,
                    width: 60,
                    color: const Color.fromARGB(255, 96, 96, 96),
                    alignment: Alignment.center,
                    child: const RotatedBox(
                      quarterTurns: 3,
                      child: Text(
                        'Flutter!',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),

                  // Light grey box (THWS)
                  Container(
                    height: 100,
                    width: 80,
                    color: const Color.fromARGB(255, 129, 129, 129),
                    alignment: Alignment.center,
                    child: const Text(
                      'THWS',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // THWS logo at the bottom
              SizedBox(
                height: 200,
                child: Image.asset('assets/thws_logo.png', fit: BoxFit.contain),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
