import 'package:flutter/material.dart';
import 'package:zakat_edoc/helpers/login_helper.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var usernameFieldController = TextEditingController();
  var passwordFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Center(
            child: Text(
              "Login",
              style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  fontFamily: "sans"),
            ),
          ),
          SizedBox(
            width: 550,
            child: TextField(
              controller: usernameFieldController,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(labelText: "Username"),
            ),
          ),
          SizedBox(
            width: 550,
            child: TextField(
              keyboardType: TextInputType.visiblePassword,
              controller: passwordFieldController,
              textAlign: TextAlign.center,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: SizedBox(
              height: 50,
              width: 550,
              child: OutlinedButton.icon(
                onPressed: tryLogin,
                icon: const Icon(Icons.login),
                label: const Text("Login"),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void tryLogin() async {
    var username = usernameFieldController.value.text;
    var password = passwordFieldController.value.text;

    var loginResponse = await LoginHelper.login(username, password);

    showSnackbar(loginResponse.responseMessage);
  }

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
