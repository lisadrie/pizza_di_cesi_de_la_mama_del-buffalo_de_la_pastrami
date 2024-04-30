import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';
import 'package:pizzas/user.dart';
import 'package:pizzas/userProvider.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Login et Signup'),
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Login'),
                Tab(text: 'Signup'),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              LoginCard(),
              SignupCard(),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginCard extends StatefulWidget {
  const LoginCard({super.key});

  @override
  State<LoginCard> createState() => _LoginCardState();
}

class _LoginCardState extends State<LoginCard> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                login(emailController.text, passwordController.text)
                    .then((User? user) {

                      Provider.of<UserProvider>(context, listen:false).login(user!);
                  if (user!=null) context.go('/home');
                });
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }

  Future<User?> login(String email, String password) async {
    try {
      Response response = await Dio().post(
        'https://pizzas.shrp.dev/auth/login',
        data: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
        options: Options(
          contentType: 'application/json; charset=UTF-8',
        ),
      );

      if (response.statusCode == 200) {
        return User.fromJson(response.data['data']);
      } else {
        final errorMessage = response.data['message'];
        print(errorMessage);
        return null;
      }
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }
}

class SignupCard extends StatefulWidget {
  const SignupCard({
    super.key,
  });

  @override
  State<SignupCard> createState() => _SignupCardState();
}

class _SignupCardState extends State<SignupCard> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: fullNameController,
              decoration: const InputDecoration(labelText: 'Full Name'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                signup(fullNameController.text, emailController.text,
                    passwordController.text);
                context.go("/connexion");
              },
              child: const Text('Signup'),
            ),
          ],
        ),
      ),
    );
  }

  void signup(String fullName, String email, String password) async {
    try {
      Response response = await Dio().post(
        'https://pizzas.shrp.dev/items/pizzas/users',
        data: jsonEncode(<String, String>{
          'role': 'bad526d9-bc5a-45f1-9f0b-eafadcd4fc15',
          'email': email,
          'password': password,
        }),
        options: Options(
          contentType: 'application/json; charset=UTF-8',
        ),
      );

      if (response.statusCode == 200) {
        print("ok");
      } else {
        final errorMessage = jsonDecode(response.data)['message'];
        print(errorMessage);
      }
    } catch (e) {
      print("Error: $e");
    }
  }
}
