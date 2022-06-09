import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:poc/view/dashboard.dart';
import 'package:poc/utils/validator.dart';
import 'package:poc/view/signup.dart';
import 'package:poc/viewmodels/loginviewmodel.dart';
import 'package:stacked/stacked.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => Dashboard(user: user),
        ),
      );
    }
    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
      viewModelBuilder: () => LoginViewModel(),
      builder: (context, model, child) => buildLayout(model)
    );
  }

  buildLayout( LoginViewModel model){
      return GestureDetector(
      onTap: () {
        model.focusEmail.unfocus();
        model.focusPassword.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
        ),
        body: FutureBuilder(
          future: _initializeFirebase(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Padding(
                padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Text(
                        'Login',
                        style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
                      ),
                    ),
                    Form(
                      key: model.formKey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: model.emailTextController,
                            focusNode: model.focusEmail,
                            validator: (value) => Validator.validateEmail(
                              email: value,
                            ),
                            decoration: InputDecoration(
                              hintText: "Email",
                              errorBorder: UnderlineInputBorder(
                                borderRadius: BorderRadius.circular(6.0),
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          TextFormField(
                            controller: model.passwordTextController,
                            focusNode: model.focusPassword,
                            obscureText: true,
                            validator: (value) => Validator.validatePassword(
                              password: value,
                            ),
                            decoration: InputDecoration(
                              hintText: "Password",
                              errorBorder: UnderlineInputBorder(
                                borderRadius: BorderRadius.circular(6.0),
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24.0),
                          model.isProcessing
                              ? const CircularProgressIndicator()
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          model.focusEmail.unfocus();
                                          model.focusPassword.unfocus();

                                          if (model.formKey.currentState!
                                              .validate()) {
                                            setState(() {
                                              model.isProcessing = true;
                                            });

                                            User? user = await model.signInUsingEmailPassword(
                                              email: model.emailTextController.text,
                                              password:
                                                  model.passwordTextController.text,
                                            );

                                            setState(() {
                                              model.isProcessing = false;
                                            });

                                            if (user != null) {
                                              Navigator.of(context)
                                                  .pushReplacement(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      Dashboard(user: user),
                                                ),
                                              );
                                            }
                                          }
                                        },
                                        child: const Text(
                                          'Log In',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 24.0),
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  SignUp(),
                                            ),
                                          );
                                        },
                                        child: const Text(
                                          'SignUp',
                                          style: const TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                        ],
                      ),
                    )
                  ],
                ),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}