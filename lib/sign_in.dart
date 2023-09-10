import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key }) : super(key: key);

  //  final String userId;
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {


   messageData (){
     FirebaseFirestore.instance.collection('users');
   }
   final _messageEditingController = TextEditingController();
    final _listScrollController = ScrollController();
   final double _inputHeight = 60;
   final  Stream<QuerySnapshot> _messagesStream= FirebaseFirestore.instance.collection('users').snapshots();
  @override

  void initState(){
    super.initState();
    _messagesStream;
  }
  @override
  void dispose(){
    super.dispose();
    _messageEditingController.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body:
         Column(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream:  _messagesStream,//FirebaseFirestore.instance.collection('').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<DocumentSnapshot> messagesData = snapshot.data!.docs;
                  return Expanded(
                    child: ListView.builder(
                      controller: _listScrollController,
                      itemCount: messagesData.length,
                      itemBuilder: (BuildContext context, int index) {
                        Map<String, dynamic> messageData = messagesData[index]
                            .data()! as Map<String, dynamic>;
                        return // MessageCard(messageData:messageData,);
                        ListTile(
                          title: Text('${messageData['post']}'),);
                      },
                    ),
                  );
                }
                return const Center(child: CircularProgressIndicator(),);
              }
              ),

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
                    if(_messageEditingController.text!='') {
                      _messageEditingController.clear();
                      messageData();
                    }},
                  icon: const Icon(Icons.send),
                ),
              ),
              ],
            ),
          ),
          ],
        ),

    );
  }
}
