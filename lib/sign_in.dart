//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key }) : super(key: key);

  //  final String userId;
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {

   final _messageEditingController = TextEditingController();
    final _listScrollController = ScrollController();
   final double _inputHeight = 60;
   final  Stream<QuerySnapshot> _messagesStream  = FirebaseFirestore.instance.collection('users').snapshots();

   @override

   void initState(){
    super.initState();
    _messagesStream;
    _messageEditingController;
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
                          return  MessageCard(messageData : messageData,);
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
                      maxLines: 10,
                      controller:  _messageEditingController,
                      decoration: const InputDecoration(border: OutlineInputBorder()),
                    ),

                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    child: IconButton(
                      onPressed: () {
                        if(
                        _messageEditingController.text!='') {
                            _messageEditingController.clear();

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

class MessageCard extends StatelessWidget {
  const MessageCard({Key? key,required this.messageData}) : super(key: key);
final Map<String, dynamic> messageData;
  @override
  Widget build(BuildContext context) {
    return  Card(
      margin: EdgeInsets.all(5),
     child: ListTile(
       tileColor: Colors.lightGreenAccent,
       title: Text(messageData['text'] is String? messageData['text']:'無効なメッセージ'),
     ),
    );

  }
}
