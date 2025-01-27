import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:orbi_ai/src/core/utils/app_vectors.dart';
import 'package:orbi_ai/src/core/utils/openai_service.dart';
import 'package:orbi_ai/src/features/talk/widgets/animating_dots_widget.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class TalkScreen extends StatefulWidget {
  const TalkScreen({super.key});

  @override
  State<TalkScreen> createState() => _TalkScreenState();
}

class _TalkScreenState extends State<TalkScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _orbSizeAnimation;

  bool _isListening = false;
  bool _isResponding = false;

  final flutterTts = FlutterTts();
  final speechToText = SpeechToText();
  final OpenAIService openAIService = OpenAIService();
  ValueNotifier<String> lastWordsNotifier = ValueNotifier<String>('');

  @override
  void initState() {
    super.initState();
    initSpeechToText();
    initTextToSpeech();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..addListener(() {
        setState(() {});
      });

    _orbSizeAnimation = Tween<double>(begin: 270, end: 320).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  Future<void> initTextToSpeech() async {
    await flutterTts.setSharedInstance(true);
  }

  Future<void> initSpeechToText() async {
    await speechToText.initialize();
  }

  Future<void> startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
  }

  Future<void> stopListening() async {
    await speechToText.stop();
  }

  void onSpeechResult(SpeechRecognitionResult result) {
    lastWordsNotifier.value = result.recognizedWords.trim();
  }

  void startBreathing() {
    if (!_isListening) return;

    // Start the animation loop
    _controller.repeat(reverse: true);
  }

  void stopBreathing() {
    // Stop the animation when not listening
    _controller.stop();
  }

  @override
  void dispose() {
    speechToText.stop();
    flutterTts.stop();
    lastWordsNotifier.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0C0011),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Talk to Orbi',
          style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xff0C0011),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 24),
              _isResponding
                  ? RespondingAnimation()
                  : Text(
                      _isListening ? "Go ahead, I'm listening..." : '',
                      style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: SizedBox(
                  width: _orbSizeAnimation.value,
                  height: _orbSizeAnimation.value,
                  child: Image.asset(AppVectors.orb),
                ),
              ),
              const SizedBox(height: 20),
              ValueListenableBuilder<String>(
                valueListenable: lastWordsNotifier,
                builder: (context, value, child) {
                  return AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 300),
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    child: Text(value.trim()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            onPressed: () async {
              if (await speechToText.hasPermission && speechToText.isNotListening) {
                await startListening();
              } else if (speechToText.isListening) {
                setState(() {
                  startBreathing();
                  _isListening = true;
                });
                await startListening();
                await Future.delayed(const Duration(seconds: 5));
                final speech = lastWordsNotifier.value;
                if (speech.isNotEmpty) {
                  setState(() {
                    _isResponding = true;
                  });
                  final response = await openAIService.chatGPTAPI(speech);
                  setState(() {
                    _isResponding = false;
                    _isListening = false;
                  });
                  await flutterTts.speak(response);
                }
                await stopListening();
                stopBreathing();
              }
            },
            icon: Image.asset(
              AppVectors.microphone,
              height: 162,
              width: 162,
            ),
          ),
          IconButton(
            onPressed: () async {
              setState(() {
                _isListening = false;
                _isResponding = false;
              });
              await flutterTts.stop();
              await stopListening();
              stopBreathing();
            },
            icon: SvgPicture.asset(AppVectors.cancel),
          ),
          const SizedBox(width: 30),
        ],
      ),
    );
  }
}
