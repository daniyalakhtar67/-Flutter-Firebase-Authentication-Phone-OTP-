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
      appBar: AppBar(
        title: Text('Login'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: phone,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Enter Phone Number (e.g. 03001234567)',
                suffixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
            SizedBox(height: 20),
            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: () async {
                if (phone.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter a phone number')),
                  );
                  return;
                }

                setState(() => isLoading = true);

                // Strip leading 0 before adding country code
                String rawNumber = phone.text.trim();
                if (rawNumber.startsWith('0')) {
                  rawNumber = rawNumber.substring(1);
                }

                // Adjust +92 to your country code if needed
                String fullPhoneNumber = '+92$rawNumber';

                print('Sending phone number: $fullPhoneNumber');

                await FirebaseAuth.instance.verifyPhoneNumber(
                  phoneNumber: fullPhoneNumber,
                  verificationCompleted: (PhoneAuthCredential credential) async {
                    print('Auto-verification completed');
                    await FirebaseAuth.instance.signInWithCredential(credential);
                  },
                  verificationFailed: (FirebaseException ex) {
                    print('Verification failed: ${ex.code} - ${ex.message}');
                    setState(() => isLoading = false);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: ${ex.message}')),
                    );
                  },
                  codeSent: (String verificationId, int? token) {
                    print('Code sent, verificationId: $verificationId');
                    setState(() => isLoading = false);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Optscreen(verificationId: verificationId),
                      ),
                    );
                  },
                  codeAutoRetrievalTimeout: (String verificationId) {
                    print('Auto retrieval timeout, verificationId: $verificationId');
                  },
                );
              },
              child: Text('Verify Phone Number'),
            ),
          ],
        ),
      ),
    );
  }
}