import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Chat extends StatefulWidget {
  const Chat({super.key, });

  //  final String userId;
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
   final _messageEditingController = TextEditingController();
    final _listScrollController = ScrollController();
   final double _inputHeight = 60;
  @override



  Widget build(BuildContext context) {
    return Scaffold(
    body:
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<DocumentSnapshot> messagesData = snapshot.data!.docs;
                  return ListView.builder(
                      controller: _listScrollController,
                      itemCount: messagesData.length,
                      itemBuilder: (context, index) {
                        return const ListTile(
                          title: Text(''),
                        );
                      },
                    );
                  }else{
                  return const Center(child: CircularProgressIndicator(),);
                }
              }
              ),
           const SizedBox(height: 150,),
          Container(
            height: _inputHeight,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Flexible(
                  child: TextFormField(
                   keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 5,
                    controller:  _messageEditingController,
                    decoration: const InputDecoration(border: OutlineInputBorder()),
                  ),

                ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                child: IconButton(
                  onPressed: () {
                   _messageEditingController.clear();
                    },
                  icon: const Icon(Icons.send),
                ),
              ),
              ],
            ),
          ),
          ],
        ),
      )
    );
  }
}
