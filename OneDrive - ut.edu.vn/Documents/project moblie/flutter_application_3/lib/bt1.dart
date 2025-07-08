import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
  List<String> book() {
    return [
      'Lập trình Dart cơ bản',
      'Flutter cho người mới bắt đầu',
      'Phát triển ứng dụng di động với Flutter',
      'Cấu trúc dữ liệu và giải thuật',
      'Lập trình hướng đối tượng với Dart'
    ];
  }
  List<String> studentBorrowBook(String name) {
    Map<String, List<String>> borrowedBooks = {
      'Lâm Văn An': ['Lập trình Dart cơ bản', 'OOP với Dart'],
      'Bình Chi ký': ['Flutter cho người mới', 'UI nâng cao'],
      'Chi Phan Thân': ['Cấu trúc dữ liệu'],
      'Hồ chí bình': ['Giải thuật nâng cao'],
      'Lâm Văn như': ['OOP với Dart', 'Clean Code']
    };

    return borrowedBooks[name] ?? [];
  }
  List<String> listStudent() {
    return ['Lâm Văn An', 'Bình Chi ký', 'Chi Phan Thân', "Hồ chí bình", "Lâm Văn như"];
  }
  List<String> returnList = [];
  String name = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          "Hệ thông \nquản lý thư viện",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              width: 381,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // căn trái các widget bên trong
                      children: <Widget>[
                        const Text(
                          'Sinh viên',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,

                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                onChanged: (it) {
                                    name = it;
                                },
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Nhập thông tin',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                              ),
                              onPressed: () {
                                setState(() {
                                  returnList = studentBorrowBook(name);
                                });
                              },
                              child: Text(
                                "Thay đổi",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 22),
                        Text(
                          "Danh sách sách",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold

                          ),
                        ),
                      ]
                  ),
                  SizedBox(height: 22),
                  Container(
                    width: 381,
                    height: 300,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10), // bo tròn 50 pixel
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: returnList.isEmpty
                            ? [
                          Text(
                            "Bạn chưa mượn cuốn sách nào",
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "Hãy chọn sách để mượn!",
                            style: TextStyle(color: Colors.black),
                            textAlign: TextAlign.center,

                          ),
                        ]
                            : [
                          for (var k in returnList) ...[
                            SizedBox(height: 12),
                            Container(
                              width: 341,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: EdgeInsets.all(10),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    k,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    )
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: EdgeInsets.symmetric(horizontal: 60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12), // bo góc
                        ),
                      ),
                      onPressed: () {
                        print("Đã nhấn nút");
                      },
                      child: Text(
                          "Thêm",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                          )
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
          color: Colors.white, // màu nền BottomAppBar
        ),
        child: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              Icon(Icons.home),
              Icon(Icons.list),
              Icon(Icons.person_3_rounded),
            ],
          ),
        ),
      ),
    );
  }
}
