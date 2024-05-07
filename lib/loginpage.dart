import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loginscreen/homepage.dart';
import 'package:loginscreen/registeruser.dart';


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
    final TextEditingController usernamecontroller=TextEditingController();
    final TextEditingController passwordcontroller=TextEditingController();
    final FocusNode usernamefocusnode=FocusNode();
    final FocusNode passwordfocusnode=FocusNode();
    final GlobalKey<FormState> _formKey=GlobalKey<FormState>();
    bool _isObscure=true;
    String errormessage='';
    Future<void> _login(BuildContext context) async{
      String password=sha256.convert(utf8.encode(passwordcontroller.text)).toString();
      final response=await http.post(Uri.parse('https://jsonplaceholder.typicode.com/posts'),
      body:{
        'username':usernamecontroller.text,
        'password':password,
      });

      if(response.statusCode==200){     //navigate to input screen 1
        final responseData=jsonDecode(response.body);
        final success=responseData['success'];

        if(success){
          Navigator.push(context,MaterialPageRoute(builder: (context)=>const Home()));
        }
        else{
          setState(() {
            errormessage='ユーザー名かパスワードが無効';
          });
        }
      }
      else{
        setState(() {
          errormessage='ログインに失敗しました。資格情報を確認してください';
        });
      }
    }
  @override
  Widget build(BuildContext context) {
    const Color primarycolor=Color(0xff0054A7);
    const Color secondarycolor=Color(0xff5B5B5B);
    return Scaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding:const EdgeInsets.all(20),
          child: Form(
            key:_formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children:[
                const Text('名前',style: TextStyle(color: primarycolor,fontWeight: FontWeight.bold,fontSize:24),),
                const SizedBox(height:20),
                const Text('ログイン',style: TextStyle(color: primarycolor,fontWeight:FontWeight.bold,fontSize:24)),
                const SizedBox(height:20),
                TextFormField(
                  controller: usernamecontroller,
                  focusNode: usernamefocusnode,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (String value){
                    usernamefocusnode.unfocus();
                    FocusScope.of(context).requestFocus(passwordfocusnode);
                  },
                  decoration: InputDecoration(
                    hintText: 'ユーザー名',
                    hintStyle: const TextStyle(color:Colors.black,fontSize: 16),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color:secondarycolor),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color:secondarycolor.withOpacity(0.5)),
                      borderRadius: BorderRadius.circular(8),
                    )
                  ),
                ),
                const SizedBox(height:20),
                TextFormField(
                  controller:passwordcontroller,
                  focusNode: passwordfocusnode,
                  obscureText: _isObscure,
                  onFieldSubmitted: (_){
                    passwordfocusnode.unfocus();
                    _login(context);
                  },
                  decoration: InputDecoration(
                    hintText: 'パスワード',
                    hintStyle: const TextStyle(color: Colors.black,fontSize: 16),
                    suffixIcon: IconButton(
                        onPressed: () {
                         setState(() {
                          _isObscure = !_isObscure;
                               });
                            },
                    icon: _isObscure ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility),
                      ),
                      border:OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color:secondarycolor)
                    ),
                    ),
                ),
                const SizedBox(height:20),
                ElevatedButton(
                  onPressed: () {
                   _login(context);
                       },
                  style: ButtonStyle(
                    shape:MaterialStateProperty.all<RoundedRectangleBorder>(
                     RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                     )
                    ),
                    minimumSize: MaterialStateProperty.all(const Size(200.0,50.0)),
                    backgroundColor: MaterialStateProperty.all<Color>(primarycolor),
                  ), 
                  child: const Text('ログイン',style:TextStyle(color:Colors.white,fontSize: 16)),),
                  const SizedBox(height:20),
                  ElevatedButton(
                    onPressed: (){Navigator.push(context,MaterialPageRoute(builder: (context)=>const Register()));
                    }, 
                    style:ButtonStyle(
                      shape:MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        )
                      ),
                      minimumSize: MaterialStateProperty.all(const Size(200.0,50.0)),
                      backgroundColor:MaterialStateProperty.all<Color>(primarycolor),
                    ),
                    child: const Text('新しいユーザーを作成する',style:TextStyle(color:Colors.white,fontSize: 16))),
                  const SizedBox(height:5),
                  if(errormessage.isNotEmpty)
                  Text(errormessage,
                  style:const TextStyle(color:Colors.red,fontSize: 14)),
              ],
              
            ),
          ),
        ),

      ),
    );
  }
}