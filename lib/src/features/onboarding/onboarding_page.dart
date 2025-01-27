import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orbi_ai/src/core/utils/app_vectors.dart';
import 'package:orbi_ai/src/features/talk/talk_screen.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final pageController = PageController();
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
      ),
    );
    return Scaffold(
      backgroundColor: Color(0xff0C0011),
      body: Center(
        child: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(),
            ),
            Positioned(
              top: 160,
              left: 90,
              child: Transform.rotate(
                angle: -40 * (3.14159 / 180),
                child: Column(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Color(0xFFFBF28B).withOpacity(0.05),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFFFBF28B),
                            blurRadius: 30,
                            spreadRadius: 25,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        color: Color(0xFFB99CF1).withOpacity(0.05),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFFB99CF1),
                            blurRadius: 30,
                            spreadRadius: 25,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 50),
                child: Column(
                  children: [
                    const SizedBox(height: 18),
                    Image.asset(AppVectors.onboarding),
                    const SizedBox(height: 56),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: 'Meet ',
                        style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
                        children: <InlineSpan>[
                          TextSpan(
                            text: 'ORBI',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xffFAE44B),
                            ),
                          ),
                          TextSpan(text: '!\n'),
                          TextSpan(
                            text: 'Your own AI assistant',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Ask your questions and receive articles using artificial intelligence assistant',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TalkScreen())),
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Colors.deepPurpleAccent,
                        shadowColor: Colors.transparent,
                        fixedSize: Size(345, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(48),
                        ),
                      ),
                      child: Text(
                        'Get started',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
