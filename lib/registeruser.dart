import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:loginscreen/loginpage.dart';


class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final FocusNode usernameFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode confirmPasswordFocusNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isObscure = true;
  bool _isConfirmObscure = true;
  String errorMessage = '';

  Future<void> _register(BuildContext context) async {
  if (_formKey.currentState!.validate()) {
    
    String password = sha256.convert(utf8.encode(passwordController.text)).toString();
    String confirmPassword = sha256.convert(utf8.encode(confirmPasswordController.text)).toString();

    if (password != confirmPassword) {
      setState(() {
        errorMessage = 'パスワードが一致しません';
      });
      return;
    }

    final response = await http.post(
      Uri.parse('https://your-api-url.com/register'),
      body: {
        'username': usernameController.text,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final success = responseData['success'];

      if (success) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const Login()));
      } else {
        setState(() {
          errorMessage = 'ユーザー登録に失敗しました';
        });
      }
    } else {
      setState(() {
        errorMessage = 'ネットワークエラー： ${response.statusCode}';
      });
    }
  }
}


  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xff0054A7);
    const Color secondaryColor = Color(0xff5B5B5B);

    return Scaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'ユーザー登録',
                  style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 24),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: usernameController,
                  focusNode: usernameFocusNode,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    usernameFocusNode.unfocus();
                    FocusScope.of(context).requestFocus(passwordFocusNode);
                  },
                  decoration: InputDecoration(
                    hintText: 'ユーザー名',
                    hintStyle: const TextStyle(color: Colors.black, fontSize: 16),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: secondaryColor),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: secondaryColor.withOpacity(0.5)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: passwordController,
                  focusNode: passwordFocusNode,
                  obscureText: _isObscure,
                  onFieldSubmitted: (_) {
                    passwordFocusNode.unfocus();
                    FocusScope.of(context).requestFocus(confirmPasswordFocusNode);
                  },
                  decoration: InputDecoration(
                    hintText: 'パスワード',
                    hintStyle: const TextStyle(color: Colors.black, fontSize: 16),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      },
                      icon: _isObscure ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: secondaryColor),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: confirmPasswordController,
                  focusNode: confirmPasswordFocusNode,
                  obscureText: _isConfirmObscure,
                  onFieldSubmitted: (_) {
                    confirmPasswordFocusNode.unfocus();
                    _register(context);
                  },
                  decoration: InputDecoration(
                    hintText: 'パスワード再入力',
                    hintStyle: const TextStyle(color: Colors.black, fontSize: 16),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _isConfirmObscure = !_isConfirmObscure;
                        });
                      },
                      icon: _isConfirmObscure ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: secondaryColor),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _register(context);
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    minimumSize: MaterialStateProperty.all(const Size(200.0, 50.0)),
                    backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
                  ),
                  child: const Text('作成する', style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
                const SizedBox(height: 5),
                if (errorMessage.isNotEmpty) Text(errorMessage, style: const TextStyle(color: Colors.red, fontSize: 14)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
