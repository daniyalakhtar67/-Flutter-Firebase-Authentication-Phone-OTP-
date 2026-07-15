import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:phone_auth/PostScree.dart';

class Optscreen extends StatefulWidget {
  final String verificationId;
  const Optscreen({super.key, required this.verificationId});

  @override
  State<Optscreen> createState() => _OptscreenState();
}

class _OptscreenState extends State<Optscreen> {
  TextEditingController otp = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OTP Screen'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: otp,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Enter OTP',
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
                if (otp.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter the OTP')),
                  );
                  return;
                }

                setState(() => isLoading = true);

                try {
                  PhoneAuthCredential credential = PhoneAuthProvider.credential(
                    verificationId: widget.verificationId,
                    smsCode: otp.text.trim(),
                  );

                  await FirebaseAuth.instance.signInWithCredential(credential);

                  setState(() => isLoading = false);

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Postscreen()),
                  );
                } catch (ex) {
                  setState(() => isLoading = false);
                  print('OTP verification failed: ${ex.toString()}');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Invalid OTP: ${ex.toString()}')),
                  );
                }
              },
              child: Text('Enter'),
            ),
          ],
        ),
      ),
    );
  }
}