// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:testbar4/routes/export.dart';
import 'package:testbar4/routes/routes.dart';
// import 'package:testbar4/provider/provider_userData.dart';
// import 'package:testbar4/screens/guest/login/p5_aftersign_inwithG.dart';

class P2Login extends StatelessWidget {
  P2Login({super.key});

  //text editing controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  final IconPath iconPath = IconPath();
  // final GoogleSignInService signinGoogle = GoogleSignInService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFEEA),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 80,
                ),
                // lock logo
                Image.asset(
                  iconPath.appBarIcon("lock_outline"),
                  height: 150,
                  width: 150,
                ),

                const SizedBox(
                  height: 50,
                ),

                //text welcome
                const Text(
                  'Welcome to PixART Running Tracking',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey),
                ),

                const SizedBox(
                  height: 25,
                ),
                //username field
                MyTextField(
                  controller: usernameController,
                  hintText: 'username',
                  obscure: false,
                ),

                const SizedBox(
                  height: 15,
                ),

                //password field
                MyTextField(
                  controller: passwordController,
                  hintText: 'password',
                  obscure: true,
                ),

                const SizedBox(
                  height: 15,
                ),
                //forgot password
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, Routes.p9),
                        child: Text(
                          'Forgot password?',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  height: 3,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, Routes.p8),
                        child: Text(
                          'Register',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      )
                    ],
                  ),
                ),

                const SizedBox(
                  height: 15,
                ),
                //login button
                MyButton(
                  usernameController: usernameController,
                  passwordController: passwordController,
                ),

                const SizedBox(
                  height: 50,
                ),

                //login by thirdparty
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                          child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[500],
                      )),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'Or continue with',
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                      ),
                      Expanded(
                          child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[500],
                      )),
                    ],
                  ),
                ),

                const SizedBox(
                  height: 10.0,
                ),
                // for logo to login
                GestureDetector(
                  onTap: () async {
                    // await signinGoogle.signInWithGoogle(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 110,
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.grey[200],
                        ),
                        child: Column(
                          children: [
                            Image.asset(
                              iconPath.appBarIcon('google_outline'),
                              width: 50,
                              height: 50,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text('google')
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Container(
                        width: 110,
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.grey[200],
                        ),
                        child: Column(
                          children: [
                            Image.asset(
                              iconPath.appBarIcon('facebook_outline'),
                              width: 50,
                              height: 50,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text('facebook')
                          ],
                        ),
                      ),
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
}
