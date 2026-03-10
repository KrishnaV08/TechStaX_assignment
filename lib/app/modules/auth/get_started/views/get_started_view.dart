import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_task_it/app/routes/app_pages.dart';

import '../controllers/get_started_controller.dart';

class GetStartedView extends GetView<GetStartedController> {
  const GetStartedView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 251, 207, 207),
              Color.fromARGB(255, 252, 186, 88),
              Color.fromARGB(255, 255, 140, 0),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Center(child: _CenterContent()),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: size.height * 0.38,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color.fromARGB(255, 255, 140, 0).withOpacity(0.0),
                        const Color.fromARGB(255, 255, 140, 0).withOpacity(0.7),
                        const Color.fromARGB(255, 255, 140, 0),
                      ],
                      stops: const [0.0, 0.6, 1.0],
                    ),
                  ),
                ),
              ),
              const Positioned(
                bottom: 36,
                left: 24,
                right: 24,
                child: _BottomActions(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CenterContent extends StatelessWidget {
  const _CenterContent();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 255, 171, 171).withOpacity(0.15),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                color: const Color.fromARGB(255, 121, 121, 121),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),

            child: const Icon(
              Icons.checklist_rounded,
              size: 60,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Just Task It!',
            style: GoogleFonts.lobster(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 242, 243, 244),
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Stay organized. Get things done.',
            style: TextStyle(
              fontSize: 15,
              color: Colors.white.withOpacity(0.8),
              letterSpacing: 0.4,
            ),
          ),
          SizedBox(height: 150),
        ],
      ),
    );
  }
}

class _BottomActions extends StatelessWidget {
  const _BottomActions();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: () {
              Get.toNamed(Routes.SIGN_UP);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color.fromARGB(255, 255, 140, 0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 0,
            ),
            child: Text(
              'Get Started',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Already have an account?  ',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 15,
              ),
            ),
            GestureDetector(
              onTap: () => Get.toNamed(Routes.SIGN_IN),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Text(
                    'Sign In',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(height: 2, width: 48, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 12,
              height: 1.5,
            ),
            children: [
              const TextSpan(text: 'By continuing, you agree to our '),
              TextSpan(
                text: 'Terms of Service',
                style: const TextStyle(
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                recognizer: TapGestureRecognizer()..onTap = () {},
              ),
              const TextSpan(text: ' and '),
              TextSpan(
                text: 'Privacy Policy',
                style: const TextStyle(
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                recognizer: TapGestureRecognizer()..onTap = () {},
              ),
              const TextSpan(text: '.'),
            ],
          ),
        ),
      ],
    );
  }
}
