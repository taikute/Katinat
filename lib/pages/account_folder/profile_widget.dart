import 'package:email_validator/email_validator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/cloudinary_helper.dart';
import '../../widgets/avata.dart';
import 'email_verify_page.dart';
import '../../models/user_model.dart';
import '../../services/color_manager.dart';
import '../../services/snack_bar_helper.dart';

class ProfileWidget extends StatefulWidget {
  final UserModel user;

  const ProfileWidget({
    super.key,
    required this.user,
  });

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  bool avataUploading = false;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  bool isEmailVerified = false;
  final nameFocusNode = FocusNode();
  late final DatabaseReference userRef;
  final imagePicker = ImagePicker();

  Future<XFile?> pickImageFromGallery() async {
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    return pickedFile;
  }

  Future<void> emailVerifyHandled() async {
    final email = emailController.text;
    if (email.isEmpty) {
      SnackBarHelper.hideAndShowSimpleSnackBar(context, 'Enter email!');
      return;
    }
    final userRef = FirebaseDatabase.instance.ref('users');
    final userSnapshot = await userRef.get();
    if (!mounted) return;
    for (final userChildSnapshot in userSnapshot.children) {
      final emailSnapshot = userChildSnapshot.child('email');
      if (emailSnapshot.exists) {
        final emailValue = emailSnapshot.value! as String;
        if (emailValue == email) {
          SnackBarHelper.hideAndShowSimpleSnackBar(context, 'Email exists!');
          return;
        }
      }
    }
    if (!EmailValidator.validate(email)) {
      SnackBarHelper.hideAndShowSimpleSnackBar(context, 'Email invalid!');
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmailVerifyPage(
          email: email,
          phoneNumber: widget.user.phoneNumber,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    userRef = FirebaseDatabase.instance.ref('users/${widget.user.phoneNumber}');
    nameFocusNode.addListener(() {
      if (!nameFocusNode.hasFocus) {
        if (nameController.text.isNotEmpty) {
          userRef.update({'name': nameController.text});
          SnackBarHelper.hideAndShowSimpleSnackBar(context, 'Name updated!');
        }
      }
    });
    if (widget.user.name != widget.user.phoneNumber) {
      setState(() {
        nameController.text = widget.user.name;
      });
    }
    if (widget.user.email != null) {
      setState(() {
        isEmailVerified = true;
        emailController.text = widget.user.email!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          GestureDetector(
            onTap: () async {
              if (avataUploading) {
                return;
              }
              final imageXFile = await pickImageFromGallery();
              if (imageXFile != null) {
                setState(() {
                  avataUploading = true;
                });
                final response = await CloudinaryHelper.cloudinary.upload(
                  file: imageXFile.path,
                  fileName: 'avata',
                  folder: 'katinat/user_images/${widget.user.phoneNumber}',
                );
                final url = response.url;
                await userRef.update({'avata_url': url});
                setState(() {
                  avataUploading = false;
                  widget.user.avataUrl = url;
                });
              }
            },
            child: Visibility(
              visible: !avataUploading,
              replacement: const AvataLoading(),
              child: Avata(url: widget.user.avataUrl),
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            initialValue: widget.user.phoneNumber,
            enabled: false,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.phone),
              labelText: 'Phone Number',
              suffixIcon: Icon(Icons.verified),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            focusNode: nameFocusNode,
            controller: nameController,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.person),
              labelText: 'Name',
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            enabled: !isEmailVerified,
            controller: emailController,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.email),
              labelText: 'Email',
              suffixIcon: isEmailVerified ? const Icon(Icons.verified) : null,
              suffix: !isEmailVerified
                  ? GestureDetector(
                      onTap: emailVerifyHandled,
                      child: const VerifyButton(),
                    )
                  : null,
            ),
          ),
          Visibility(
            visible: !isEmailVerified,
            child: Text(
              '*note: add email to help you reset your password ',
              style: TextStyle(
                color: Colors.red[300],
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class VerifyButton extends StatelessWidget {
  const VerifyButton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Verify',
      style: TextStyle(
        color: ColorManager.secondaryColor,
        decoration: TextDecoration.underline,
        decorationColor: ColorManager.secondaryColor,
      ),
    );
  }
}
