import 'package:flutter/material.dart';
import 'package:zakat_edoc/helpers/login_helper.dart';
import 'package:zakat_edoc/route.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.light(),
      home: Login(),
    );
  }
}

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var usernameFieldController = TextEditingController();
  var passwordFieldController = TextEditingController();

  bool isLoggingIn = false;

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
                onPressed: isLoggingIn ? null : tryLogin,
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
    setState(() {
      isLoggingIn = true;
    });

    var username = usernameFieldController.value.text;
    var password = passwordFieldController.value.text;

    var loginResponse = await LoginHelper.login(username, password);

    showSnackbar(loginResponse.responseMessage);

    if (loginResponse.responseCode == LoginResponseCode.error) {
      setState(() {
        isLoggingIn = false;
      });
    } else {
      await Future.delayed(Duration(milliseconds: 1500));
      moveToDashboard();
    }
  }

  void moveToDashboard() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => dashboard),
    );
  }

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
