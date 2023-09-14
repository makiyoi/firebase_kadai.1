import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_sub/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
class Chat extends StatefulWidget {
  const Chat({super. key }); //: super(key: key);

  //  final String userId;
 @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {

  final _firestoreService = FirestoreService();
  final _messageEditingController = TextEditingController();
  final _listScrollController = ScrollController();
  final double _inputHeight = 60;
  late Stream<QuerySnapshot> _messagesStream; //= FirebaseFirestore.instance.collection('users').snapshots();

  Stream<QuerySnapshot> _getMessagesStream() {
    return _firestoreService.getMessagesStream(limit: 10);
  }

  Future<void> _addMessage() async {
    try {
      await _firestoreService.addMessage({
        'text': _messageEditingController.text,
        'date': DateTime.now().millisecondsSinceEpoch
      });
      _messageEditingController.clear();
      _listScrollController.jumpTo(_listScrollController.position.maxScrollExtent);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('メッセージを送信できませんでした'),
            margin: EdgeInsets.only(bottom: _inputHeight),
          )
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _messagesStream = _getMessagesStream();
  }

  @override
  void dispose() {
    super.dispose();
    _messageEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Messages'),),
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
              stream: _messagesStream,
              //FirebaseFirestore.instance.collection('').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<DocumentSnapshot> messagesData = snapshot.data!.docs;
                  return Expanded(
                    child: ListView.builder(
                      controller: _listScrollController,
                      itemCount: messagesData.length,
                      itemBuilder: (context, index) {
                        final messageData = messagesData[index].data()! as Map<String, dynamic>;
                        return MessageCard(messageData: messageData,);
                      },
                    ),
                  );
                }
                return const Center(child: CircularProgressIndicator(),);
              }
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            height: _inputHeight,
            child: Row(
              children: [
                Flexible(
                  child: TextFormField(
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 5,
                    controller: _messageEditingController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder()),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  child: IconButton(
                    onPressed: () {
                      if (_messageEditingController.text!='') {
                        _addMessage();
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
       child: ListTile(
         //tileColor: Colors.lightGreenAccent,
         title: Text(messageData['text'] is String? messageData['text']:'無効なメッセージ'),
         subtitle: Text(DateFormat('yyyy/MM/dd HH:mm')
             .format(DateTime.fromMillisecondsSinceEpoch(messageData['date'] is int? messageData['date']:0))),
         tileColor:   ? Colors.amber[100] : Colors.blue[100],


       ),
    );
  }
}
