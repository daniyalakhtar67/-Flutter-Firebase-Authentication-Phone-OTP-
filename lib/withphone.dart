import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:phone_auth/optscreen.dart';

class LoginWithPhone extends StatefulWidget {
  const LoginWithPhone({super.key});

  @override
  State<LoginWithPhone> createState() => _LoginWithPhoneState();
}

class _LoginWithPhoneState extends State<LoginWithPhone> {
  TextEditingController phone = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: phone,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(hintText: 'Enter Phone Number'),
            ),
            SizedBox(height: 20),
            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: () async {
                setState(() => isLoading = true);

                // simple phone number: +92 + number without leading 0
                String number = '+92${phone.text.trim().substring(1)}';
                await FirebaseAuth.instance.verifyPhoneNumber(
                  phoneNumber: number,
                  verificationCompleted: (credential) {},
                  verificationFailed: (e) {
                    setState(() => isLoading = false);
                    print(e.message);
                  },
                  codeSent: (String verificationId, resendToken) {
                    setState(() => isLoading = false);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Optscreen(verificationId: verificationId),
                      ),
                    );
                  },
                  codeAutoRetrievalTimeout: (verificationId) {},
                );
              },
              child: Text('Send OTP'),
            ),
          ],
        ),
      ),
    );
  }
}