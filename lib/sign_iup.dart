import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  SignUpState createState() => SignUpState();

}
class SignUpState extends State<SignUp> {

  final _emailEditingController = TextEditingController();
  final _passwordEditingController = TextEditingController();
  bool _alreadySignedUp = false;

    void handleSignUP() async {
      try {
        final userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
            email: _emailEditingController.text,
            password: _passwordEditingController.text
        );
           User user = userCredential.user!;
           FirebaseFirestore.instance.collection('users').doc(user.uid).set({
             'id': user.uid,
             'email': user.email,
           });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('既に使用されているメールアドレスです'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ));
        } else if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('パスワードは最低でも６文字必要です'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ));
        } else if (e.code == 'invalid-email') {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('メールアドレスが正しくありません'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ));
        }
      }
    }

    void handleSignIn() async {
      try {
         UserCredential userCredential= await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: _emailEditingController.text,//'cat_blue@exmaple.com',
            password: _passwordEditingController.text);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-in-found') {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('登録されていないメールアドレスです'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ));
        } else {
          if (e.code == 'wrong-password') {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('パスワードが違います'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 2),
            ));
          } else if (e.code == 'invalid-email') {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('メールアドレスが正しくありません'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 2),
            ));
          }
        }
      }
    }

    @override
    Widget build(BuildContext context) {
      return Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width / 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: _emailEditingController,
                decoration: const InputDecoration(
                    labelText: 'メールアドレス', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 20,),
              TextFormField(
                obscureText: true,
                controller: _passwordEditingController,
                decoration: const InputDecoration(
                    labelText: 'パスワード', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 20,),
              _alreadySignedUp ? ElevatedButton(
                onPressed: () {
                    handleSignIn();
                },
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(20),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15))
                ),
                child: const Text(
                  'ログイン', style: TextStyle(color: Colors.white),),
              ) : ElevatedButton(
                onPressed: () {
                  handleSignUP();
                },
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(20),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15))
                ),
                child: const Text(
                  'ユーザー登録', style: TextStyle(color: Colors.white),),
              ),
              const SizedBox(height: 20,),
              TextButton(onPressed: () {
                setState(() {
                  _alreadySignedUp = !_alreadySignedUp;
                });
              },
                  child: Text(
                    _alreadySignedUp ? '新しくアカウントを作成' : '既にアカウントをお持ちですか？',
                    style: const TextStyle(color: Colors.grey,
                      decoration: TextDecoration.underline,),
                  )
              ),
              SizedBox(
                height: 200, width: 300,
                child: Image.asset('assets/mohikan.jpg'),
              ),
            ],
          ),
        ),
      );
    }
  }
