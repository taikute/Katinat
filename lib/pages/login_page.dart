import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../color_manager.dart';
import '../services/phone_number_validate.dart';
import 'package:text_form_field_validator/text_form_field_validator.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final phoneNumberController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();
  String state = 'LOGIN';
  void changeState() {
    if (state == 'LOGIN') {
      state = 'REGISTER';
    } else {
      state = 'LOGIN';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            const SizedBox(height: 10),
            Text(
              state,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                color: ColorManager.primaryColor,
              ),
            ),
            loginForm(context),
          ],
        ),
      ),
    );
  }

  Form loginForm(BuildContext context) {
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            TextFormField(
              controller: phoneNumberController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                icon: Icon(Icons.phone),
                labelText: 'Phone Number',
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
            TextFormField(
              controller: passwordController,
              keyboardType: TextInputType.visiblePassword,
              decoration: const InputDecoration(
                icon: Icon(Icons.password),
                labelText: 'Password',
              ),
              validator: (value) => FormValidator.validate(
                value,
                required: true,
              ),
            ),
            Visibility(
              visible: state == 'REGISTER',
              child: TextFormField(
                controller: passwordConfirmController,
                keyboardType: TextInputType.visiblePassword,
                decoration: const InputDecoration(
                  icon: Icon(Icons.password),
                  labelText: 'Password Confirm',
                ),
                validator: (value) => FormValidator.validate(
                  value,
                  required: state == 'REGISTER',
                ),
              ),
            ),
            const SizedBox(height: 20),
            submitButton(context),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                setState(() {
                  changeState();
                });
              },
              child: Center(
                child: Text(
                  (state == 'LOGIN'
                      ? 'Unregistered? Register now'
                      : 'Registered? Login now'),
                  style: const TextStyle(
                    fontSize: 16,
                    decoration: TextDecoration.underline,
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

  GestureDetector submitButton(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (!formKey.currentState!.validate()) return;
        final phoneNumber = phoneNumberController.text;
        final password = passwordController.text;
        final userRef = FirebaseDatabase.instance.ref('users/$phoneNumber');

        if (state == 'LOGIN') {
          final userSnapshot = await userRef.get();
          if (!context.mounted) return;
          if (userSnapshot.exists) {
            final jsonUser = userSnapshot.value! as Map;
            if (password != jsonUser['password']) {
              showSnack(context, 'Password incorrect!');
              return;
            }
            showSnack(context, 'Login successful!');
            return;
          } else {
            setState(() {
              changeState();
            });

            showSnack(context, 'Phone number has not been registered!');
            return;
          }
        }

        final passwordConfirm = passwordConfirmController.text;
        if (state == 'REGISTER') {
          if (password != passwordConfirm) {
            showSnack(context, 'Incorrect password confirm!');
            return;
          }
          final isValid = await PhoneNumberValidate.isValid(phoneNumber);
          if (!context.mounted) return;
          if (!isValid) {
            showSnack(context, 'Phone number is not valid!');
            return;
          }
          final jsonUser = await userRef.get();
          if (!context.mounted) return;
          if (!jsonUser.exists) {
            userRef.set({'password': password});
            setState(() {
              changeState();
            });
            showSnack(context, 'Register successful!');
            return;
          }
          setState(() {
            changeState();
          });
          showSnack(context, 'Phone number is exists!');
          return;
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: ColorManager.primaryColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Text(
            state,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnack(
      BuildContext context, String msg) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
      ),
    );
  }
}
