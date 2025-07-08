import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
Widget titleUTH(){
  return Column(
      children: <Widget>[
        Image.asset(
          'assets/uth.png',
          width: 180,
        ),
        Text(
          "UTH SmartTasks",
          style: TextStyle(
              color: Colors.blue, fontSize: 30, fontFamily: 'Righteous'
          ),
        )
      ]
  );
}

class _MyHomePageState extends State<MyHomePage> {
  String yourEmail = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            titleUTH(),
            Container(
              width: 381,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  pageOne(context, (value) {
                    yourEmail = value;
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget pageOne(BuildContext context, Function(String) onEmailChanged) {
    final TextEditingController _controller = TextEditingController();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 17),
        const Text(
          "Forget Password?",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          textAlign: TextAlign.center,
        ),
        const Text(
          "Enter your Email, We will send you a verification code",
          style: TextStyle(
            fontSize: 18,
          ),
          textAlign: TextAlign.center,
        ),
        TextField(
          controller: _controller,
          decoration: const InputDecoration(
            labelText: 'Your email',
            prefixIcon: Icon(Icons.mail),
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            onEmailChanged(value);
          },
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: 150,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PageTwo(
                    yourEmail: yourEmail,
                    onChangeOtp: (otp) {
                      print("OTP nhập: $otp");
                    },
                  ),
                ),
              );
            },
            child: const Text(
              'Next',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}

class PageTwo extends StatelessWidget {
  final Function(String) onChangeOtp;
  final String yourEmail;

  const PageTwo({Key? key, required this.onChangeOtp, required this.yourEmail})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<FocusNode> _focusNodes = List.generate(5, (_) => FocusNode());
    final List<TextEditingController> _controllers =
    List.generate(5, (_) => TextEditingController());

    void updateOtp() {
      String otp = _controllers.map((c) => c.text).join();
      onChangeOtp(otp);
    }

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            titleUTH(),
            const Text(
              'Nhập mã OTP',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(5, (index) {
                return SizedBox(
                  width: 50,
                  child: TextField(
                    controller: _controllers[index],
                    focusNode: _focusNodes[index],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      counterText: '',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      if(_controllers[index].text.isNotEmpty){
                        FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
                      }
                      if (value.isNotEmpty && index < 4) {
                        FocusScope.of(context).requestFocus(_focusNodes[index + 1]);

                      } else if (value.isEmpty && index > 0) {
                        FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
                      }
                      print(onChangeOtp);
                      updateOtp();
                    },
                    onSubmitted: (_) => FocusScope.of(context).unfocus(),
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                updateOtp();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PageThree(email: yourEmail),
                  ),
                );
              },
              child: const Text('Xác nhận'),
            ),
          ],
        ),
      ),
    );
  }
}

class PageThree extends StatefulWidget {
  final String email;
  const PageThree({Key? key, required this.email}) : super(key: key);

  @override
  State<PageThree> createState() => _PageThreeState();
}

class _PageThreeState extends State<PageThree> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  String _errorText = '';

  void _validatePassword() {
    String pass = _passwordController.text;
    String confirm = _confirmController.text;

    setState(() {
      if (pass.isEmpty || confirm.isEmpty) {
        _errorText = "Vui lòng nhập đầy đủ mật khẩu.";
      } else if (pass != confirm) {
        _errorText = "Mật khẩu không khớp.";
      } else {
        _errorText = "";
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Mật khẩu hợp lệ!")),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            titleUTH(),
            const Text(
              "Thiết lập mật khẩu",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Mật khẩu",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _confirmController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Nhập lại mật khẩu",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            if (_errorText.isNotEmpty)
              Text(
                _errorText,
                style: const TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_errorText.isEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PageFour(
                        email: widget.email,
                        password: _passwordController.text,
                        repassword: _confirmController.text,
                      ),
                    ),
                  );
                }
              },
              child: const Text("Xác nhận"),
            ),
          ],
        ),
      ),
    );
  }
}

class PageFour extends StatefulWidget {
  final String email;
  final String password;
  final String repassword;

  const PageFour({
    Key? key,
    required this.email,
    required this.password,
    required this.repassword,
  }) : super(key: key);

  @override
  State<PageFour> createState() => _PageFourState();
}

class _PageFourState extends State<PageFour> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _repasswordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.email);
    _passwordController = TextEditingController(text: widget.password);
    _repasswordController = TextEditingController(text: widget.repassword);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _repasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            titleUTH(),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.mail),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _repasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Re-password',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock_outline),
              ),
            ),
            ElevatedButton(onPressed: (){
              Navigator.popUntil(context, (route) => route.isFirst);
            }, child: Text(
              "xác nhận"
            ))
          ],
        ),
      ),
    );
  }
}
