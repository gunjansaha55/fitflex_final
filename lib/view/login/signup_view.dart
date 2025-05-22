import 'package:fitness/services/auth/auth_exceptions.dart';
import 'package:fitness/services/bloc/auth_bloc.dart';
import 'package:fitness/services/bloc/auth_event.dart';
import 'package:fitness/services/bloc/auth_state.dart';
import 'package:fitness/common/colo_extension.dart';
import 'package:fitness/common_widget/round_button.dart';
import 'package:fitness/common_widget/round_textfield.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  bool isCheck = false;
  late final TextEditingController _emailcontroller;
  late final TextEditingController _passwordcontroller;
  late final TextEditingController _confirmPasswordcontroller;
  late final TextEditingController _firstNamecontroller;
  late final TextEditingController _lastNamecontroller;
  bool obscurepasswordText = true;
  bool obscureconfpasswordText = true;
  final _formKey = GlobalKey<FormState>();
  final RegExp emailValid = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

  @override
  void initState() {
    _emailcontroller = TextEditingController();
    _passwordcontroller = TextEditingController();
    _confirmPasswordcontroller = TextEditingController();
    _firstNamecontroller = TextEditingController();
    _lastNamecontroller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailcontroller.dispose();
    _passwordcontroller.dispose();
    _confirmPasswordcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateRegistering) {
          if (state.exception is WeakPasswordAuthException) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Weak password'),
              ),
            );
          } else if (state.exception is EmailAlreadyInUseAuthException) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Email already in use'),
              ),
            );
          } else if (state.exception is GenericAuthException) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('An error occurred'),
              ),
            );
          } else if (state.exception is InvalidEmailAuthException) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Invalid email'),
              ),
            );
          }
        }
      },
      child: Scaffold(
        backgroundColor: TColor.white,
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Hey there,",
                      style: TextStyle(color: TColor.gray, fontSize: 16),
                    ),
                    Text(
                      "Create an Account",
                      style: TextStyle(
                          color: TColor.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      height: media.width * 0.05,
                    ),
                    RoundTextField(
                      hitText: "First Name",
                      icon: "assets/img/user_text.png",
                      controller: _firstNamecontroller,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter your first name";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: media.width * 0.04,
                    ),
                    RoundTextField(
                      hitText: "Last Name",
                      controller: _lastNamecontroller,
                      icon: "assets/img/user_text.png",
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter your last name";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: media.width * 0.04,
                    ),
                    RoundTextField(
                      hitText: "Email",
                      icon: "assets/img/email.png",
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailcontroller,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter your email";
                        }
                        if (!emailValid.hasMatch(value)) {
                          return "Please enter a valid email";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: media.width * 0.04,
                    ),
                    RoundTextField(
                      hitText: "Password",
                      icon: "assets/img/lock.png",
                      obscureText: obscurepasswordText,
                      controller: _passwordcontroller,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter your password";
                        }
                        if (value.length < 6) {
                          return "Password must be at least 6 characters";
                        }
                        return null;
                      },
                      rigtIcon: TextButton(
                          onPressed: () {
                            setState(() {
                              obscurepasswordText = !obscurepasswordText;
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: 20,
                            height: 20,
                            child: obscurepasswordText
                                ? Image.asset("assets/img/show_password.png")
                                : const Icon(
                                    Icons.remove_red_eye,
                                    color: Colors.black,
                                  ),
                          )),
                    ),
                    SizedBox(
                      height: media.width * 0.04,
                    ),
                    RoundTextField(
                      hitText: "Confirm Password",
                      icon: "assets/img/lock.png",
                      obscureText: obscureconfpasswordText,
                      controller: _confirmPasswordcontroller,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter your password";
                        }
                        if (value != _passwordcontroller.text) {
                          return "Password does not match";
                        }
                        return null;
                      },
                      rigtIcon: TextButton(
                          onPressed: () {
                            setState(() {
                              obscureconfpasswordText =
                                  !obscureconfpasswordText;
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: 20,
                            height: 20,
                            child: obscureconfpasswordText
                                ? Image.asset("assets/img/show_password.png")
                                : const Icon(
                                    Icons.remove_red_eye,
                                    color: Colors.black,
                                  ),
                          )),
                    ),
                    Row(
                      // crossAxisAlignment: CrossAxisAlignment.,
                      children: [
                        Checkbox(
                            value: isCheck,
                            onChanged: (value) {
                              setState(() {
                                isCheck = value ?? false;
                              });
                            }),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            "By continuing you accept our Privacy Policy and\nTerm of Use",
                            style: TextStyle(color: TColor.gray, fontSize: 10),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: media.width * 0.4,
                    ),
                    RoundButton(
                        title: "Register",
                        onPressed: () {
                          if (!isCheck) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Please accept our Privacy Policy and Term of Use'),
                              ),
                            );
                            return;
                          }
                          if (_formKey.currentState!.validate()) {
                            final email = _emailcontroller.text;
                            final password = _passwordcontroller.text;
                            final firstName = _firstNamecontroller.text;
                            final lastName = _lastNamecontroller.text;
                            final fullName = "$firstName $lastName";
                            context.read<AuthBloc>().add(AuthEventRegister(
                                  email,
                                  password,
                                  fullName,
                                ));
                          }
                        }),
                    SizedBox(
                      height: media.width * 0.04,
                    ),
                    Row(
                      // crossAxisAlignment: CrossAxisAlignment.,
                      children: [
                        Expanded(
                            child: Container(
                          height: 1,
                          color: TColor.gray.withOpacity(0.5),
                        )),
                        Text(
                          "  Or  ",
                          style: TextStyle(color: TColor.black, fontSize: 12),
                        ),
                        Expanded(
                            child: Container(
                          height: 1,
                          color: TColor.gray.withOpacity(0.5),
                        )),
                      ],
                    ),
                    SizedBox(
                      height: media.width * 0.04,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            context.read<AuthBloc>().add(
                                  const AuthEventSignInWithGoogle(),
                                );
                          },
                          child: Container(
                            width: 50,
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: TColor.white,
                              border: Border.all(
                                width: 1,
                                color: TColor.gray.withOpacity(0.4),
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Image.asset(
                              "assets/img/google.png",
                              width: 20,
                              height: 20,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: media.width * 0.04,
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: 50,
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: TColor.white,
                              border: Border.all(
                                width: 1,
                                color: TColor.gray.withOpacity(0.4),
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Image.asset(
                              "assets/img/facebook.png",
                              width: 20,
                              height: 20,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: media.width * 0.04,
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(
                              const AuthEventLogout(),
                            );
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Already have an account? ",
                            style: TextStyle(
                              color: TColor.black,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            "Login",
                            style: TextStyle(
                                color: TColor.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w700),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: media.width * 0.04,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
