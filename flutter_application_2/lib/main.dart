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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Image.asset('assets/logo.png'),
            Container(
              width: 301,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  const Text(
                    'Jetpack Compose',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Jetpack Compose is a modern UI toolkit for building native Android applications using a declarative programming approach.',
                  )
                ],
              ),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                minimumSize: MaterialStateProperty.all<Size>(const Size(301, 40)),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyList()),
                );
              },
              child: const Text('TextButton'),
            ),
          ],
        ),
      ),
    );
  }
}

class MyList extends StatelessWidget {
  const MyList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MyHomePage(title: 'My App Title')),
            );
          },
        ),
        centerTitle: true,
        title: const Text(
          'UI Components List',
          style: TextStyle(
            color: Colors.blue,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              sectionTitle('Display'),
              componentCard('Text', 'Display text',onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TextDetail()),
                );
              },),
              componentCard('Image', 'Display an image',onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TextDetail()),
                );
              },),
              sectionTitle('Input'),
              componentCard('TextField', 'Input field for text',onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TextDetail()),
                );
              },),
              componentCard('PasswordField', 'Input field for passwords',onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TextDetail()),
                );
              },),
              sectionTitle('Layout'),
              componentCard('Column', 'Arranges elements vertically',onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TextDetail()),
                );
              },),
              componentCard('Row', 'Arranges elements horizontally',onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TextDetail()),
                );
              },),
            ],
          ),
        ),
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 23,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget componentCard(String title, String subtitle, {VoidCallback? onPressed}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        width: 350,
        decoration: BoxDecoration(
          color: const Color(0xFF71B4EA),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 19,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TextDetail extends StatelessWidget {
  const TextDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MyList()),
            );
          },
        ),
        centerTitle: true,
        title: const Text(
          'Text Detail',
          style: TextStyle(
            color: Colors.blue,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Container(
          width: 230,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
              width: 1,
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: RichText(
            text: const TextSpan(
              style: TextStyle(fontSize: 20, color: Colors.black),
              children: [
                TextSpan(text: 'The '),
                TextSpan(
                  text: 'quick ',
                  style: TextStyle(decoration: TextDecoration.lineThrough),
                ),
                TextSpan(
                  text: 'Brown ',
                  style: TextStyle(
                      color: Colors.brown, fontWeight: FontWeight.bold),
                ),
                TextSpan(text: 'fox '),
                TextSpan(
                  text: 'j u m p s ',
                  style: TextStyle(letterSpacing: 4),
                ),
                TextSpan(
                  text: 'over\n',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic),
                ),
                TextSpan(
                  text: 'the ',
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
                TextSpan(
                  text: 'lazy ',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
                TextSpan(text: 'dog.'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
