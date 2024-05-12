import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'forgot_password_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:text_form_field_validator/text_form_field_validator.dart';

import '../../services/color_manager.dart';
import '../../services/device_helper.dart';
import '../../services/jwt_helper.dart';
import '../../services/login_helper.dart';
import '../../services/prefs_helper.dart';
import '../../widgets/primary_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final phoneNumberController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();
  bool isSubmitInProgress = false;
  bool passwordVisible = false;
  String state = 'LOGIN';

  void showSnackBar(String content) {
    final scaffoldContext = scaffoldKey.currentState?.context;
    if (scaffoldContext == null) {
      debugPrint('Cant show snack bar');
      return;
    }
    ScaffoldMessenger.of(scaffoldContext).hideCurrentSnackBar();
    ScaffoldMessenger.of(scaffoldContext)
        .showSnackBar(SnackBar(content: Text(content)));
  }

  void showInternetAlertDialog() {
    final scaffoldContext = scaffoldKey.currentState?.context;
    if (scaffoldContext == null) {
      debugPrint('Cant show dialog');
      return;
    }
    showDialog(
      context: scaffoldContext,
      builder: (context) {
        return AlertDialog(
          title: const Text('ALERT'),
          content: const Text('No internet connection!'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'))
          ],
        );
      },
    );
  }

  void changeState() {
    if (state == 'LOGIN') {
      state = 'SIGN UP';
    } else {
      state = 'LOGIN';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 2.5,
              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.cover,
              ),
            ),
            loginForm(),
          ],
        ),
      ),
    );
  }

  Form loginForm() {
    var visibleButton = IconButton(
      onPressed: () {
        setState(() {
          passwordVisible = !passwordVisible;
        });
      },
      icon: Icon(
        passwordVisible ? Icons.visibility : Icons.visibility_off,
      ),
    );
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 10),
            TextFormField(
              controller: phoneNumberController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                prefixIcon: Icon(Icons.phone),
              ),
              validator: (value) => FormValidator.validate(
                value,
                required: true,
                min: 10,
                max: 10,
                regex: RegExp(
                  r'^0[0-9]{9}$',
                ),
                regexMessage: 'Phone number must start with number 0',
                stringFormat: StringFormat.numbers,
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: passwordController,
              keyboardType: TextInputType.visiblePassword,
              obscureText: !passwordVisible,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
                labelText: 'Password',
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: visibleButton,
              ),
              validator: (value) => FormValidator.validate(
                value,
                required: true,
              ),
            ),
            const SizedBox(height: 10),
            Visibility(
              visible: state == 'SIGN UP',
              child: TextFormField(
                controller: passwordConfirmController,
                keyboardType: TextInputType.visiblePassword,
                obscureText: !passwordVisible,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                  labelText: 'Password Confirm',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: visibleButton,
                ),
                validator: (value) => FormValidator.validate(
                  value,
                  required: state == 'SIGN UP',
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Submit button
            Visibility(
              visible: !isSubmitInProgress,
              replacement: const SizedBox(
                height: 40,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              child: GestureDetector(
                onTap: () async {
                  setState(() {
                    isSubmitInProgress = true;
                  });
                  await submitHandle();
                  setState(() {
                    isSubmitInProgress = false;
                  });
                },
                child: PrimaryButton(text: state),
              ),
            ),
            const SizedBox(height: 20),
            Visibility(
              visible: state == 'LOGIN',
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return const ForgotPasswordPage();
                    },
                  ));
                },
                child: const Text(
                  'Forgotten your password?',
                  style: TextStyle(
                    fontSize: 16,
                    decoration: TextDecoration.underline,
                    color: ColorManager.primaryColor,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  changeState();
                });
              },
              child: Center(
                child: Text(
                  (state == 'LOGIN'
                      ? 'Do not have an account yet?'
                      : 'Already have an account?'),
                  style: const TextStyle(
                    fontSize: 16,
                    decoration: TextDecoration.underline,
                    color: ColorManager.primaryColor,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Future<void> submitHandle() async {
    if (!await InternetConnection().hasInternetAccess) {
      showInternetAlertDialog();
      return;
    }
    if (!formKey.currentState!.validate()) return;
    final phoneNumber = phoneNumberController.text;
    final password = passwordController.text;
    final passwordConfirm = passwordConfirmController.text;
    final userRef = FirebaseDatabase.instance.ref('users/$phoneNumber');
    if (state == 'LOGIN') {
      String? loginCheck = await LoginHelper.loginCheck(phoneNumber, password);
      if (loginCheck != null) {
        showSnackBar(loginCheck);
        return;
      }
      // Login accept
      final jwt = JWT(phoneNumber);
      final token = jwt.sign(JWTHelper.key);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(PrefsHelper.loginToken, token);
      await userRef.update({'device_id': await DeviceHelper.deviceId});
      showSnackBar('Login successful!');
      final scaffoldContext = scaffoldKey.currentState?.context;
      if (scaffoldContext != null && scaffoldContext.mounted) {
        Navigator.pop(scaffoldContext);
        Navigator.pushReplacementNamed(scaffoldContext, '/account');
      }
      return;
    }
    if (state == 'SIGN UP') {
      String? signUpCheck =
          await LoginHelper.signUpCheck(phoneNumber, password, passwordConfirm);
      if (signUpCheck != null) {
        showSnackBar(signUpCheck);
        return;
      }
      await userRef.set({'name': phoneNumber, 'password': password});
      showSnackBar('Sign up successful!');
      setState(() {
        changeState();
      });
      return;
    }
  }
}
