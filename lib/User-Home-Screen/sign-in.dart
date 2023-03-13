import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mybixbite/Controller-Provider/User-Controller/user-signup-signin.dart';
import 'package:mybixbite/Routes/routes.dart';
import 'package:mybixbite/User-Home-Screen/sign-up.dart';
import 'package:mybixbite/widgets/elevated-button.dart';
import 'package:mybixbite/widgets/sized-box.dart';
import 'package:mybixbite/widgets/textformfield.dart';
import 'package:provider/src/provider.dart';

class UserClientLoginPage extends StatefulWidget {
  const UserClientLoginPage({Key? key}) : super(key: key);

  @override
  _UserClientLoginPageState createState() => _UserClientLoginPageState();
}

class _UserClientLoginPageState extends State<UserClientLoginPage> {
  final TextEditingController _emailText = TextEditingController();
  final TextEditingController _passwordText = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isHidden = true;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text("Log In"),
          ),
          body: SingleChildScrollView(
            reverse: true,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  addVerticalSpace(20),
                  Container(
                    width: 200.0,
                    height: 220.0,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/images/beryl_logo_clear.png"),
                          fit: BoxFit.fill),
                      // boxShadow: <BoxShadow>[
                      //   BoxShadow(
                      //       color: Colors.black54,
                      //       blurRadius: 15.0,
                      //       offset: Offset(0.0, 0.75))
                      // ],
                      //color: Colors.white60,
                    ),
                  ),
                  addVerticalSpace(20),
                  TextFormFields.textFormFields("Email", "Email", _emailText,
                      widget: null,
                      sufixIcon: null,
                      obscureText: false,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next, validator: (value) {
                    if (value!.isEmpty) {
                      return ("Email is required");
                    } else if (!value!.contains("@")) {
                      return ("Invalid Email Format");
                    }
                  }),
                  addVerticalSpace(20),
                  TextFormFields.textFormFields("Password", "Password", _passwordText,
                      widget: null,
                      sufixIcon: IconButton(
                        icon: Icon(
                          _isHidden ? Icons.visibility : Icons.visibility_off,
                          color: Colors.orange,
                        ),
                        onPressed: () {
                          // This is the trick

                          _isHidden = !_isHidden;

                          (context as Element).markNeedsBuild();
                        },
                      ),
                      obscureText: _isHidden,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done, validator: (value) {
                    if (value!.isEmpty) {
                      return ("Password is required ");
                    }
                  }),
                  addVerticalSpace(20),
                  ElevatedButtonStyle.elevatedButton("Login", onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      context
                          .read<SignUpSignInController>()
                          .signIn(_emailText.text, _passwordText.text, context);
                    }
                  }),

                  // ElevatedButton(
                  //     child: Text("Login "),
                  //     onPressed: () {
                  //       // Navigator.pushNamed(context, '/user-client-login-page');
                  //     }),
                  addVerticalSpace(20),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                    Text("Don't have an account? "),
                    GestureDetector(
                      onTap: () {
                        NavigateRoute.gotoPage(context, const UserClientRegisterPage());
                      },
                      child: const Text(
                        "SignUp",
                        style: TextStyle(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    )
                  ]),
                  addVerticalSpace(20),
                ],
              ),
            ),
          )),
    );
  }
}
