
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:phone_auth/Utils.dart';
import 'package:phone_auth/add_post.dart';

class Postscreen extends StatefulWidget {
  const Postscreen({super.key});

  @override
  State<Postscreen> createState() => _PostscreenState();
}

class _PostscreenState extends State<Postscreen> {
  TextEditingController Search  = TextEditingController();
  TextEditingController editingController = TextEditingController();
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
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: Search,
                decoration: InputDecoration(
                  hintText: 'Search',
                   border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20)
                  )
                ),
                onChanged: (String Value){
                  setState(() {
                  });
                },
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: FirebaseAnimatedList(query: ref,
                  defaultChild: loading ? CircularProgressIndicator(): Text('Loading'),
                  itemBuilder: ( context, snapshot, animation, index) {
                    final title = snapshot.child('title').value.toString();
                    final key = snapshot.key!;
                    if (Search.text.isEmpty) {
                      return ListTile(
                        title: Text(snapshot.child('title').value.toString()),
                        subtitle: Text(snapshot.child('id').value.toString()),
                        trailing: PopupMenuButton( icon: Icon(Icons.more_vert) ,
                            itemBuilder: (context)=> [
                              PopupMenuItem(value: 1, child: ListTile(
                                onTap: (){
                                  Navigator.pop(context);
                                  showMyDialog(title, key);
                                },
                                title: Text('Edit'),
                                leading: Icon(Icons.edit),
                              )),
                              PopupMenuItem(
                                  value: 1,
                                  child:ListTile(
                                    onTap: () {
                                      Navigator.pop(context);
                                      // ref.child(snapshot.child(key).value.toString()).remove();
                                      ref.child(key).remove();
                                    },
                                    title: Text('Delete'),
                                    leading: Icon(Icons.delete),
                                  ) )
                            ],
                        ),
                      );
                    }else if(title.toLowerCase().contains(Search.text.toLowerCase().toLowerCase())){
                      return ListTile(
                        title: Text(snapshot.child('title').value.toString()),
                        subtitle: Text(snapshot.child('id').value.toString()),
                      );
                    }
                    else{
                      return Container();
                    }
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
  Future<void> showMyDialog(String title, String id) async{
    editingController.text = title;
    return showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        title: Text('Update'),
        actions: [
          TextButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text('Cancel')),
      TextButton(onPressed: (){
        Navigator.pop(context);
        ref.child(id).update({
      'title': editingController.text.toLowerCase(),
      }).then((value){
      Utils().tomsg('Post Updated');
      }).onError((error, stackTrace){
      Utils().tomsg(error.toString());
      });
      }, child: Text('Update'))
        ],
        content: Container(
          child: TextFormField(
            controller: editingController,
            decoration: InputDecoration(
              hintText: 'Edit'
            ),
          ),
        ),
      );
    });
  }

}

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

