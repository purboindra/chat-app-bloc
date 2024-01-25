import 'package:chat_app/domain/bloc/auth_bloc.dart';
import 'package:chat_app/domain/event/auth_event.dart';
import 'package:chat_app/domain/state/auth_state.dart';
import 'package:chat_app/route/route_name.dart';
import 'package:chat_app/utils/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({
    super.key,
  });

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  final emailC = TextEditingController();
  final passwordC = TextEditingController();

  bool _changeSignInScreen = false;
  final bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailC.dispose();
    passwordC.dispose();
    super.dispose();
  }

  // Future<void> _signUp() async {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   final response =
  //       await widget.authRepository.signUp(emailC.text, passwordC.text);
  //   setState(() {
  //     _isLoading = false;
  //   });
  // }

  // Future<void> _signIn() async {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   final response =
  //       await widget.authRepository.signIn(emailC.text, passwordC.text);
  //   setState(() {
  //     _isLoading = false;
  //   });
  //   if (response["status_code"] == 200) {
  //     await Future.delayed(Duration.zero, () {
  //       Navigator.of(context).pushReplacement(MaterialPageRoute(
  //         builder: (context) => const HomeScreen(),
  //       ));
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: ListView(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: emailC,
                      decoration: const InputDecoration(hintText: "Email"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: passwordC,
                      decoration: const InputDecoration(hintText: "Password"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              BlocConsumer<AuthenticationBloc, AuthenticationState>(
                listener: (context, state) {
                  if (state is ErrorAuthState) {
                    AppSnakcbar.showSnackbar(context, message: state.message);
                  } else if (state is SuccessAuthState) {
                    context.push(AppRouteName.mainScreen);
                  }
                },
                builder: (context, state) {
                  if (_changeSignInScreen) {
                    return ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          // await _signUp();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Data tidak boleh kosong...')),
                          );
                        }
                      },
                      child: const Text("Sign Up"),
                    );
                  } else {
                    return ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          context
                              .read<AuthenticationBloc>()
                              .add(SignUpEvent(emailC.text, passwordC.text));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Data tidak boleh kosong...')),
                          );
                        }
                      },
                      child: Text(
                          state is LoadingAuthState ? "Loading..." : "Sign Up"),
                    );
                  }
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _changeSignInScreen = !_changeSignInScreen;
                  });
                },
                child: Text(_changeSignInScreen
                    ? "Havent account? Sign Up"
                    : "Already Account? Sign In"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
