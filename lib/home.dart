import 'package:avatar_glow/avatar_glow.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:noreen/main.dart';
import 'package:noreen/substring_highlight.dart';
import 'package:noreen/utils.dart';

import 'api/speech_api.dart';
import 'app_storage.dart';

class Home extends StatefulWidget {
  const Home({Key? key, required this.controller}) : super(key: key);
  final PageController controller;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String userText = "Say something";
  bool isListening = false;
  bool showHint = true;
  List<String> previousRecogniions = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(
          "Text Recognition",
        ),
        actions: [
          IconButton(
            onPressed: () async {
              setState(() {
                userText = "Say something";
                showHint = true;
              });
            },
            tooltip: "Show Hint",
            color: Colors.black,
            icon: Icon(Icons.info_outline),
          ),
          if (userText != "Say something")
            IconButton(
              onPressed: () async {
                await FlutterClipboard.copy(userText);
                showSnack(context, "Copied to clipboard");
              },
              tooltip: "Copy text",
              color: Colors.black,
              icon: Icon(Icons.copy),
            ),
          IconButton(
            onPressed: () async {
              widget.controller.animateToPage(
                1,
                duration: Duration(milliseconds: 500),
                curve: Curves.easeInCubic,
              );
            },
            tooltip: "Previous Results",
            color: Colors.black,
            icon: Icon(Icons.history_rounded),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: SingleChildScrollView(
        reverse: true,
        padding: EdgeInsets.symmetric(
          vertical: 150,
          horizontal: 30,
        ).copyWith(top: 40),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(16)),
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (userText == "Say something")
                Image.asset(
                  "assets/speak.jpg",
                  height: 50,
                ),
              Center(
                child: !showHint
                    ? SubstringHighlight(
                        terms: Command.commands,
                        text: userText,
                        textStyle: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                        textStyleHighlight: TextStyle(
                          fontSize: 20,
                          color: Colors.blue,
                        ),
                      )
                    : suggestionWidget(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: isListening,
        endRadius: 75,
        glowColor: Theme.of(context).primaryColor,
        child: FloatingActionButton(
          onPressed: () {
            setState(() {
              userText = "Say something";
              showHint = false;
            });
            previousRecogniions = AppStorage().allHistory;
            toggleRecording();
          },
          child: Icon(isListening ? Icons.mic : Icons.mic_none),
        ),
      ),
    );
  }

  Future toggleRecording() => SpeechApi.toggleRecording(
      context: context,
      onResult: (text, status) {
        setState(() {
          this.userText = text;
        });
        if (status == "notListening") {
          previousRecogniions.add(text);
          AppStorage().updateHistory(previousRecogniions);
          Future.delayed(Duration(seconds: 1), () {
            Utils.checkText(userText);
          });
        }
      },
      onListening: (listening, status) {
        setState(() {
          this.isListening = listening;
        });
      });

  Widget suggestionWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Tap microphone and say something",
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Text(
          "To write an email say: ",
          style: TextStyle(
            fontSize: 18,
            color: Colors.black54,
          ),
        ),
        Container(
          decoration: BoxDecoration(
              color: Colors.lightBlueAccent.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8)),
          padding: EdgeInsets.all(8),
          child: Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: Colors.grey,
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '"${Command.email} Hello Good Morning sir"',
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          "To visit a website e.g google say: ",
          style: TextStyle(
            fontSize: 18,
            color: Colors.black54,
          ),
        ),
        Container(
          decoration: BoxDecoration(
              color: Colors.lightBlueAccent.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8)),
          padding: EdgeInsets.all(8),
          child: Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: Colors.grey,
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '"${Command.browse} google.com"',
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
              ),
            ],
          ),
        ),
        Text(
          "or say: ",
          style: TextStyle(
            fontSize: 18,
            color: Colors.black54,
          ),
        ),
        Container(
          decoration: BoxDecoration(
              color: Colors.lightBlueAccent.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8)),
          padding: EdgeInsets.all(8),
          child: Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: Colors.grey,
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '"${Command.open} google.com"',
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          "To search using google: e.g Uganda ",
          style: TextStyle(
            fontSize: 18,
            color: Colors.black54,
          ),
        ),
        Container(
          decoration: BoxDecoration(
              color: Colors.lightBlueAccent.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8)),
          padding: EdgeInsets.all(8),
          child: Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: Colors.grey,
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  '"${Command.search} Uganda"',
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
