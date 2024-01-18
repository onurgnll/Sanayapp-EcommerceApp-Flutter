import 'package:flutter/material.dart';
import 'package:sanayapp2/HomePage.dart';
import 'package:sanayapp2/helpers/ShowSnackBar.dart';
import 'package:sanayapp2/helpers/colorPalette.dart';
import 'package:sanayapp2/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void kayitOl(BuildContext context) async {
    var querySnapshot = await firestore
        .collection('users')
        .where('email', isEqualTo: _emailController.text)
        .get();

    if (querySnapshot.docs.isEmpty) {
      Map<String, dynamic> eklenecekUser = {
        'email': _emailController.text,
        'name': _usernameController.text,
        'password': _passwordController.text
      };

      await firestore.collection('users').add(eklenecekUser).then((value) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(
              email: _emailController.text,
            ),
          ),
        );
        showSnackbar(context, "Başarıyla Kayıt Olundu", snackBarSuccess);
      });
    } else {
      showSnackbar(context, "Bu e-posta adresine sahip kullanıcı zaten var.",
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
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                margin: const EdgeInsets.only(
                    left: 85, right: 85, top: 130, bottom: 10),
                padding: const EdgeInsets.only(
                    left: 10, right: 10, top: 0, bottom: 0),
                child: TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    hintText: 'İsim Soyisim',
                    labelStyle: TextStyle(fontFamily: 'Arial', fontSize: 20),
                    border: InputBorder.none,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                margin: const EdgeInsets.only(
                    left: 85, right: 85, top: 7, bottom: 10),
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
                      return '';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                margin: const EdgeInsets.only(
                    left: 85, right: 85, top: 7, bottom: 10),
                padding: const EdgeInsets.only(
                    left: 10, right: 10, top: 0, bottom: 0),
                child: TextFormField(
                  obscureText: true,
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    hintText: 'Şifre',
                    labelStyle: TextStyle(fontFamily: 'Arial', fontSize: 20),
                    border: InputBorder.none,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '';
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
                    kayitOl(context);
                  } else {
                    showSnackbar(context, "Email ve Şifre Boş Bırakılamaz",
                        snackBarDanger);
                  }
                },
                child: const Text(
                  'Kayıt Ol',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 10), // Boşluk ekleyebilirsiniz
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyApp(),
                    ),
                  );
                },
                child: const Text(
                  'Zaten Hesabınız Var Mı?',
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
