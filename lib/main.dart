import 'package:flutter/material.dart';
import 'package:login_animation/loadingIndicator.dart';
import 'package:rive/rive.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const title = "Hello\nFlutter x Rive";
  final correctEmail = "test@test.com";
  final correctPw = "test1234";

  final emailController = TextEditingController();
  FocusNode emailFocusNode = FocusNode();

  final passwordController = TextEditingController();
  FocusNode passwordFocusNode = FocusNode();

  SMIInput<bool>? _isChecking;
  SMIInput<bool>? _isHandsUp;
  SMIInput<double>? _lookAt;
  SMIInput<bool>? _triggerSuccess;
  SMIInput<bool>? _triggerFail;

  late StateMachineController _controller;

  void _printLatestValue(type, text) {
    // ignore: avoid_print
    print('$type field: $text');
  }

  void emailFocus() {
    _isChecking?.change(emailFocusNode.hasFocus);
  }

  void passwordFocus() {
    _isHandsUp?.change(passwordFocusNode.hasFocus);
  }

  @override
  void initState() {
    emailFocusNode.addListener(emailFocus);
    passwordFocusNode.addListener(passwordFocus);
    super.initState();
  }

  @override
  void dispose() {
    emailFocusNode.removeListener(emailFocus);
    passwordFocusNode.removeListener(passwordFocus);
    emailController.dispose();
    passwordController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFD6E2EA),
        body: GestureDetector(
          onTap: () {
            emailFocusNode.unfocus();
            passwordFocusNode.unfocus();
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
            child: Center(
                child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                        color: Colors.white, shape: BoxShape.circle),
                    child: const FlutterLogo(
                      size: 50,
                    ),
                  ),
                  const Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 40,
                    ),
                  ),
                  SizedBox(
                    height: 250,
                    child: RiveAnimation.asset(
                      "assets/login_screen_character.riv",
                      onInit: (artboard) {
                        _controller = StateMachineController.fromArtboard(
                            artboard, "State Machine 1")!;
                        artboard.addController(_controller);
                        _isChecking = _controller.findInput("Check");
                        _isHandsUp = _controller.findInput("hands_up");
                        _lookAt = _controller.findInput("Look");
                        _triggerSuccess = _controller.findInput("success");
                        _triggerFail = _controller.findInput("fail");
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 5),
                          decoration: BoxDecoration(
                              color: const Color(0xFFE7F2F7),
                              borderRadius: BorderRadius.circular(10)),
                          child: TextField(
                            controller: emailController,
                            focusNode: emailFocusNode,
                            onChanged: (val) {
                              _lookAt?.change(val.length.toDouble() * 1.5);
                            },
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Email',
                            ),
                            //style: TextStyle(color: Colors.red),
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 5),
                          decoration: BoxDecoration(
                              color: const Color(0xFFE7F2F7),
                              borderRadius: BorderRadius.circular(10)),
                          child: TextField(
                            controller: passwordController,
                            focusNode: passwordFocusNode,
                            obscureText: true,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Password',
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 64,
                          child: ElevatedButton(
                            onPressed: () async {
                              emailFocusNode.unfocus();
                              passwordFocusNode.unfocus();

                              final email = emailController.text;
                              final password = passwordController.text;

                              showLoadingDialog(context);

                              await Future.delayed(
                                  const Duration(milliseconds: 1000));
                              if (mounted) Navigator.pop(context);
                              if (email == correctEmail &&
                                  password == correctPw) {
                                _triggerSuccess?.change(true);
                              } else {
                                _triggerFail?.change(true);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )),
          ),
        ));
  }
}
