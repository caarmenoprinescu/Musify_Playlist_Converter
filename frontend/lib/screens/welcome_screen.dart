import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:playlist_converter_app/authentication/spotify_login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildAnimatedBackground(),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 15),
                  Text(
                    "PREMIUM TRANSFER",
                    style: TextStyle(
                      color: Color(0xFF537CFF).withAlpha(180),
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2.0,
                    ),
                  ),
                  const Spacer(flex: 3),

                  _buildHeroVisual(),

                  const SizedBox(height: 40),

                  const Text(
                    "Welcome to\nMusify",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF0D1B3E),
                      fontSize: 42,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1.5,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "The smartest way to move your\nmusic library between platforms.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFF537CFF).withOpacity(0.7),
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      height: 1.4,
                    ),
                  ),

                  const Spacer(flex: 2),

                  _buildStartButton(),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroVisual() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 120,
          width: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF537CFF).withOpacity(0.3),
                blurRadius: 50,
                spreadRadius: 10,
              ),
            ],
          ),
        ),

        Icon(
          Icons.music_note_rounded,
          size: 130,
          color: const Color(0xFF537CFF),
          shadows: [
            Shadow(
              color: Colors.black.withOpacity(0.1),
              offset: const Offset(0, 10),
              blurRadius: 15,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStartButton() {
    return Container(
      width: double.infinity,
      height: 65,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: const LinearGradient(
          colors: [Color(0xFF537CFF), Color(0xFF3F62D7)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF537CFF).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        onPressed: () => Get.to(() => const LoginScreen()),
        child: const Text(
          "Get Started",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [const Color(0xFF537CFF).withAlpha(30), Colors.white],
        ),
      ),
    );
  }
}

//OLD VERSION
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:playlist_converter_app/authentication/spotify_login_screen.dart';
//
// class WelcomeScreen extends StatelessWidget {
//   const WelcomeScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         color: Color(0xFF537CFF),
//         child: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 24.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 const Spacer(flex: 2),
//                 Icon(
//                   Icons.music_note,
//                   size: 100,
//                   color: Colors.white.withAlpha(204),
//                 ),
//                 const SizedBox(height: 25),
//                 Text(
//                   "Welcome to Musify!",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 40,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 Text(
//                   "Seamlessly transfer your playlists between Spotify and Apple Music",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     color: Colors.white70,
//                     fontSize: 18,
//                     fontWeight: FontWeight.w400,
//                   ),
//                 ),
//                 const Spacer(flex: 2),
//                 Material(
//                   color: Colors.white,
//                   shadowColor: Colors.blue,
//                   borderRadius: BorderRadius.circular(30),
//                   elevation: 0.2,
//                   child: InkWell(
//                     borderRadius: BorderRadius.circular(30),
//                     splashColor: Colors.white,
//                     onTap: () {
//                       Get.to(() => const LoginScreen());
//                     },
//                     child: Container(
//                       width: 270,
//                       height: 55,
//                       alignment: Alignment.center,
//                       child: Text(
//                         "Start",
//                         style: TextStyle(
//                           color: Color(0xFF537CFF),
//                           fontSize: 25,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const Spacer(flex: 2),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
