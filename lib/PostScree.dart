
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
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Expanded(child: StreamBuilder(stream: ref.onValue, builder: (context, AsyncSnapshot<DatabaseEvent>snapshot){
            //   if(!snapshot.hasData){
            //     return CircularProgressIndicator();
            //   }else{
            //     Map<dynamic, dynamic> map = snapshot.data!.snapshot.value as dynamic;
            //     List<dynamic> list = [];
            //     list.clear();
            //     list = map.values.toList();
            //     return ListView.builder(
            //         itemCount: snapshot.data!.snapshot.children.length,
            //         itemBuilder: (context, index){
            //           return ListTile(
            //             title: Text(list[index]['title']),
            //             subtitle: Text(list[index]['title']),
            //           );
            //         });
            //   }
            // })),
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
