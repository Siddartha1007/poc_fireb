import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:poc/utils/validator.dart';
import 'package:poc/view/dashboard.dart';
import 'package:poc/viewmodels/signupviewmodel.dart';
import 'package:stacked/stacked.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  // final _registerFormKey = GlobalKey<FormState>();

  // final _nameTextController = TextEditingController();
  // final _emailTextController = TextEditingController();
  // final _passwordTextController = TextEditingController();

  // final _focusName = FocusNode();
  // final _focusEmail = FocusNode();
  // final _focusPassword = FocusNode();

  // bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SignUpViewModel>.reactive(
      viewModelBuilder: () => SignUpViewModel(),
      builder: (context, model, child) => buildLayout(model)
    );
  }

  buildLayout(SignUpViewModel model){
      return GestureDetector(
      onTap: () {
        model.focusName.unfocus();
        model.focusEmail.unfocus();
        model.focusPassword.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('SignUp'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Form(
                  key: model.registerFormKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: model.nameTextController,
                        focusNode: model.focusName,
                        validator: (value) => Validator.validateName(
                          name: value,
                        ),
                        decoration: InputDecoration(
                          hintText: "Name",
                          errorBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            borderSide: const BorderSide(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
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
                      const SizedBox(height: 16.0),
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
                      const SizedBox(height: 32.0),
                      model.isProcessing
                          ? const CircularProgressIndicator()
                          : Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      setState(() {
                                        model.isProcessing = true;
                                      });

                                      if (model.registerFormKey.currentState!
                                          .validate()) {
                                        User? user = await model.registerUsingEmailPassword(
                                          name: model.nameTextController.text,
                                          email: model.emailTextController.text,
                                          password:
                                              model.passwordTextController.text,
                                        );

                                        setState(() {
                                          model.isProcessing = false;
                                        });

                                        if (user != null) {
                                          Navigator.of(context)
                                              .pushAndRemoveUntil(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  Dashboard(user: user),
                                            ),
                                            ModalRoute.withName('/'),
                                          );
                                        }
                                      }
                                    },
                                    child: const Text(
                                      'Sign up',
                                      style: TextStyle(color: Colors.white),
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
          ),
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return GestureDetector(
  //     onTap: () {
  //       _focusName.unfocus();
  //       _focusEmail.unfocus();
  //       _focusPassword.unfocus();
  //     },
  //     child: Scaffold(
  //       appBar: AppBar(
  //         title: const Text('SignUp'),
  //       ),
  //       body: Padding(
  //         padding: const EdgeInsets.all(24.0),
  //         child: Center(
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               Form(
  //                 key: _registerFormKey,
  //                 child: Column(
  //                   children: <Widget>[
  //                     TextFormField(
  //                       controller: _nameTextController,
  //                       focusNode: _focusName,
  //                       validator: (value) => Validator.validateName(
  //                         name: value,
  //                       ),
  //                       decoration: InputDecoration(
  //                         hintText: "Name",
  //                         errorBorder: UnderlineInputBorder(
  //                           borderRadius: BorderRadius.circular(6.0),
  //                           borderSide: const BorderSide(
  //                             color: Colors.red,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                     const SizedBox(height: 16.0),
  //                     TextFormField(
  //                       controller: _emailTextController,
  //                       focusNode: _focusEmail,
  //                       validator: (value) => Validator.validateEmail(
  //                         email: value,
  //                       ),
  //                       decoration: InputDecoration(
  //                         hintText: "Email",
  //                         errorBorder: UnderlineInputBorder(
  //                           borderRadius: BorderRadius.circular(6.0),
  //                           borderSide: const BorderSide(
  //                             color: Colors.red,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                     const SizedBox(height: 16.0),
  //                     TextFormField(
  //                       controller: _passwordTextController,
  //                       focusNode: _focusPassword,
  //                       obscureText: true,
  //                       validator: (value) => Validator.validatePassword(
  //                         password: value,
  //                       ),
  //                       decoration: InputDecoration(
  //                         hintText: "Password",
  //                         errorBorder: UnderlineInputBorder(
  //                           borderRadius: BorderRadius.circular(6.0),
  //                           borderSide: const BorderSide(
  //                             color: Colors.red,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                     const SizedBox(height: 32.0),
  //                     _isProcessing
  //                         ? const CircularProgressIndicator()
  //                         : Row(
  //                             children: [
  //                               Expanded(
  //                                 child: ElevatedButton(
  //                                   onPressed: () async {
  //                                     setState(() {
  //                                       _isProcessing = true;
  //                                     });

  //                                     if (_registerFormKey.currentState!
  //                                         .validate()) {
  //                                       User? user = await FireAuth
  //                                           .registerUsingEmailPassword(
  //                                         name: _nameTextController.text,
  //                                         email: _emailTextController.text,
  //                                         password:
  //                                             _passwordTextController.text,
  //                                       );

  //                                       setState(() {
  //                                         _isProcessing = false;
  //                                       });

  //                                       if (user != null) {
  //                                         Navigator.of(context)
  //                                             .pushAndRemoveUntil(
  //                                           MaterialPageRoute(
  //                                             builder: (context) =>
  //                                                 Dashboard(user: user),
  //                                           ),
  //                                           ModalRoute.withName('/'),
  //                                         );
  //                                       }
  //                                     }
  //                                   },
  //                                   child: const Text(
  //                                     'Sign up',
  //                                     style: TextStyle(color: Colors.white),
  //                                   ),
  //                                 ),
  //                               ),
  //                             ],
  //                           )
  //                   ],
  //                 ),
  //               )
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}