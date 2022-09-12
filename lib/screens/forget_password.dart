import 'package:email_validator/email_validator.dart';

import 'package:flutter/material.dart';

class ForgetScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  ForgetScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Forget Password ?',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  'Enter email to change password',
                  style: TextStyle(color: Colors.grey[500]),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.grey[200],
                  ),
                  child: TextFormField(
                    validator: (email) =>
                        email != null && !EmailValidator.validate(email)
                            ? 'Enter valid email'
                            : null,
                    controller: _emailController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Email',
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      forgetPassword(context);
                    },
                    child: const Text('Send reset link'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> forgetPassword(context) async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      // showDialog(
      //     context: context,
      //     barrierDismissible: false,
      //     builder: (context) {
      //       return const Center(
      //         child: CircularProgressIndicator(),
      //       );
      //     });

      // try {
      //   await FirebaseAuth.instance
      //       .sendPasswordResetEmail(email: _emailController.text)
      //       .then((value) => {
      //             Navigator.of(context).pushAndRemoveUntil(
      //                 MaterialPageRoute(
      //                     builder: (context) => const AuthScreen()),
      //                 (route) => false)
      //           });
      // } on FirebaseAuthException catch (e) {
      //   GlobalSnackBar.show(context, e.message);
      //   Navigator.of(context).pop();
      // }
    }
  }
}
