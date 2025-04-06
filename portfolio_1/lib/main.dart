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
          backgroundColor: Colors.blue[900],
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
                  style: TextStyle(fontSize: 40, color: Colors.white),
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
                    color: Colors.grey[850],
                    alignment: Alignment.center,
                    child: Container(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        'TAMK',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),

                  // Dark grey box (Flutter!) rotated vertically
                  Container(
                    height: 140,
                    width: 80,
                    color: Colors.grey[700],
                    alignment: Alignment.center,
                    child: Text(
                      'Flutter!',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),

                  // Light grey box (THWS)
                  Container(
                    height: 100,
                    width: 80,
                    color: Colors.grey[500],
                    alignment: Alignment.center,
                    child: Container(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        'THWS',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // THWS logo at the bottom
              SizedBox(
                height: 200,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue[900],
                    border: Border.all(color: Colors.black, width: 1),
                  ),

                  child: Image.asset(
                    'assets/thws_logo.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
