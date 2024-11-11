import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jira_project/controllers/auth.dart';
import 'package:provider/provider.dart';

class Login extends StatelessWidget {
  Login({Key? key}) : super(key: key);

  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 26),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                controller: emailController,
              ),
              const SizedBox(height: 20),
              Consumer<AuthState>(
                  builder: (context, state, child) => state.authStatus !=
                          AuthenticationStatus.inProgress
                      ? ElevatedButton(
                          onPressed: () {
                            Provider.of<AuthState>(context, listen: false)
                                .authorizeUser(emailController.text, context);
                          },
                          child: Text('Login'))
                      : CircularProgressIndicator())
            ],
          )),
    );
  }
}
