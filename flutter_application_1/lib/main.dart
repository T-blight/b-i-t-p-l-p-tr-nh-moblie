import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _ageController = TextEditingController();
  var _information = "";
  void _showInformation([int? age]) {
    setState(() {
      if (age == null) {
        _information = "vui lòng nhập thông tin";
      } else if (age < 2) {
        _information = "em bé";
      } else if (age < 6) {
        _information = "trẻ em";
      } else if (age < 65) {
        _information = "người lớn";
      } else {
        _information = "người già";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Bài thực hành 1:',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 80,
                        child: Text('Họ và tên', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      SizedBox(
                        width: 80,
                        child: Text('Tuổi', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Expanded(
                        child: TextField(
                          controller: _ageController, 
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      int? age = int.tryParse(_ageController.text);
                      _showInformation(age);
                    },
                    child: Text('Kiểm tra'),
                  ),
                  SizedBox(height: 12),
                  Text(
                    _information,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
