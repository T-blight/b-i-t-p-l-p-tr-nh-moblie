import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UTH SmartTasksa',
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
      routes: {
        '/profile': (_) => const ProfileScreen(),
      },
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      Navigator.pushReplacementNamed(context, '/profile');
    } catch (e, stackTrace) {
      print("❌ Đăng nhập thất biiại: $e");
      print("🔍 Stacktrace: $stackTrace");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đăng nhập thất bại. Vui lòng thử lại.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          // Logo UTH
          Image.asset(
          'assets/img/uth.png',
          height: 120,
        ),
        const SizedBox(height: 24),

        // Tiêu đề
        const Text(
          'SmartTasks',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
          ),
        ),

        const SizedBox(height: 4),

        // Phụ đề
        const Text(
          'A simple and efficient to-do app',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),

        const SizedBox(height: 48),

        // Welcome
        const Text(
          'Welcome',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        const Text(
          'Ready to explore? Log in to get started.',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 32),
        ElevatedButton.icon(
          icon: const Icon(Icons.login),
          label: const Text('Sign in with Google'),
          onPressed: () => signInWithGoogle(context),
        ),
      ]
      ),
      )
    );
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String birth = 'Loading...';

  @override
  void initState() {
    super.initState();
    loadBirthDate();
  }

  Future<void> loadBirthDate() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      final data = doc.data();
      setState(() {
        birth = data?['birth'] ?? 'N/A';
      });
    } else {
      setState(() {
        birth = 'Not logged in';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: user == null
            ? const Center(child: Text("Không tìm thấy thông tin người dùng."))
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(user.photoURL ?? ''),
              ),
            ),
            const SizedBox(height: 20),
            Text("👤 Name: ${user.displayName ?? 'N/A'}"),
            Text("🎂 Birth: $birth"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                GoogleSignIn().signOut();
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: const Text('Logouttt'),
            ),
          ],
        ),
      ),
    );
  }
}