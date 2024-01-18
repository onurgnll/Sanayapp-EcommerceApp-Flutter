import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sanayapp2/Notification/FirebaseApi.dart';
import 'package:sanayapp2/Notification/notification.dart';
import 'package:sanayapp2/helpers/ShowSnackBar.dart';
import 'package:sanayapp2/helpers/colorPalette.dart';
import 'package:sanayapp2/HomePage.dart';
import 'package:sanayapp2/RegisterPage.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseApi().initNotifications();

  //requestPermission();
  //getToken("email");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void showToastMessage(String message) {}

  void girisYap(BuildContext context) async {
    var querySnapshot = await _firestore
        .collection('users')
        .where('email', isEqualTo: _emailController.text)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      var user = querySnapshot.docs.first;

      if (user['password'] == _passwordController.text) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(
              email: _emailController.text,
            ),
          ),
        );
        showSnackbar(context, "Başarıyla Giriş Yapıldı", snackBarSuccess);
        saveToken(_emailController.text);
      } else {
        showSnackbar(context, "Yanlış Şifre Girdiniz", snackBarDanger);
      }
    } else {
      showSnackbar(context, "Bu e-posta adresine sahip kullanıcı bulunamadı.",
          snackBarDanger);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/login.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                margin: const EdgeInsets.only(
                    left: 85, right: 85, top: 130, bottom: 10),
                padding: const EdgeInsets.only(
                    left: 10, right: 10, top: 0, bottom: 0),
                child: TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    hintText: 'Email',
                    labelStyle: TextStyle(fontFamily: 'Arial', fontSize: 20),
                    border: InputBorder.none,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email boş bırakılamaz';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                margin: const EdgeInsets.only(
                    left: 85, right: 85, top: 7, bottom: 10),
                padding: const EdgeInsets.only(
                    left: 10, right: 10, top: 0, bottom: 0),
                child: TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: 'Şifre',
                    labelStyle: TextStyle(fontFamily: 'Arial', fontSize: 20),
                    border: InputBorder.none,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Şifre boş bırakılamaz';
                    }
                    return null;
                  },
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 40),
                    backgroundColor: Color(iconsColor)),
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    girisYap(context);
                  }
                },
                child: const Text('Giriş Yap',
                    style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 10),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegistrationPage(),
                    ),
                  );
                },
                child: const Text(
                  'Hesabınız yok mu?',
                  style: TextStyle(
                    color: Color(0xFF31304D),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
