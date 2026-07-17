
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:phone_auth/add_post.dart';

class Postscreen extends StatefulWidget {
  const Postscreen({super.key});

  @override
  State<Postscreen> createState() => _PostscreenState();
}

class _PostscreenState extends State<Postscreen> {

  final ref = FirebaseDatabase.instance.ref('Data');
  bool loading = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post Screen', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
        backgroundColor: Colors.lightBlue.shade200,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Expanded(
            //   child: StreamBuilder(
            //     stream: ref.onValue,
            //     builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
            //       if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
            //         return Center(child: CircularProgressIndicator());
            //       }
            //
            //       final raw = snapshot.data!.snapshot.value;
            //
            //       if (raw is! Map) {
            //         return Center(child: Text('No data found'));
            //       }
            //
            //       Map<dynamic, dynamic> map = raw;
            //       List<dynamic> list = map.values.toList();
            //
            //       return ListView.builder(
            //         itemCount: list.length,
            //         itemBuilder: (context,int index) {
            //           return ListTile(
            //             title: Text(list[index]['title'].toString()),
            //             subtitle: Text(list[index]['id'].toString()),
            //           );
            //         },
            //       );
            //     },
            //   ),
            // ),
            Expanded(
              child: FirebaseAnimatedList(query: ref,
                  defaultChild: loading ? CircularProgressIndicator(): Text('Loading'),
                  itemBuilder: ( context, snapshot, animation, index){
                return ListTile(
                  title: Text(snapshot.child('title').value.toString()),
                  subtitle: Text(snapshot.child('id').value.toString()),
                );
                    }
                    ),
            ),
            FloatingActionButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => AddPost()));
            }, child: Center(child: Icon(Icons.add, color: Colors.black,)))
          ],
        ),
      ),
    );
  }
}
