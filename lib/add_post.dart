import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:phone_auth/Utils.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  bool isLoading = false;
  final dbRef = FirebaseDatabase.instance.ref('Data'); // here table works as a table
  final post = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ADD POST',
          style: TextStyle(color: Colors.blue.shade200, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 20),
            TextFormField(
              controller: post,
              maxLines: 4,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'What is in your mind',
              ),
            ),
            SizedBox(height: 20),
            isLoading
                ? CircularProgressIndicator()
                : InkWell(
              onTap: () async {
                setState(() => isLoading = true);
                String id = DateTime.now().microsecondsSinceEpoch.toString();
                try {
                  await dbRef.child(id).set({
                    'id': id,
                    'title': post.text.toString(),
                    // 'text': post.text.trim(),
                  }).then((value){
                    Utils().tomsg('Post Added');
                  });
                  print('Post added successfully');
                } catch (e) {
                  print('Error adding post: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
                setState(() => isLoading = false);
              },
              child: Text(
                'Add',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}