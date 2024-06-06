import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:streamsavor/pages/profile.dart';
import 'package:streamsavor/providers/dark_mode_provider.dart';

class AboutMe extends StatelessWidget {
  const AboutMe({super.key});

  @override
  Widget build(BuildContext context) {
    bool darkMode = Provider.of<DarkModeProvider>(context).darkMode;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: FadeInRight(
          child: Text(
            'About Me',
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        ),
      ),
      body: Column(
        children: [
          Center(
            child: FadeInLeft(
              child: const CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 96,
                foregroundImage: AssetImage('assets/Prabhat.png'),
              ),
            ),
          ),
          const SizedBox(height: 10),
          FadeInLeft(
            delay: const Duration(milliseconds: 100),
            child: Text(
              'thetwodigiter',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                FadeInLeft(
                  delay: const Duration(milliseconds: 200),
                  child: Text(
                    'Passionate Flutter and Python Developer from India ❤️',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 30),
                FadeInLeft(
                  delay: const Duration(milliseconds: 300),
                  child: Text(
                    'This is an open source project and can be found here',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                FadeInLeft(
                  delay: const Duration(milliseconds: 300),
                  child: TextButton(
                    onPressed: () => launchBrowser(
                        'https://www.github.com/iamthetwodigiter/StreamSavor',
                        context),
                    child: const Text(
                      'Github',
                      style: TextStyle(fontSize: 18, color: Colors.pinkAccent),
                    ),
                  ),
                ),
                FadeInLeft(
                  delay: const Duration(milliseconds: 300),
                  child: Text(
                    'If you like the project, consider ⭐ the repo 😊',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                FadeInLeft(
                  delay: const Duration(milliseconds: 300),
                  child: Text(
                    'If you feel like, sponsor this project 😉',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                FadeInLeft(
                  delay: const Duration(milliseconds: 300),
                  child: TextButton(
                    onPressed: () {
                      Clipboard.setData(
                          const ClipboardData(text: 'itsmeprabhatjana@oksbi'));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'UPI ID has been copied to clipboard',
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                        color: Colors.white,
                      ),
                      child: Image.asset(
                        'assets/social/google-pay.png',
                        height: 50,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Flexible(child: Container()),
          FadeIn(
            delay: const Duration(milliseconds: 300),
            child: Text(
              'Connect With Me',
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeInDown(
                delay: const Duration(milliseconds: 400),
                child: InkWell(
                  onTap: () {
                    Clipboard.setData(const ClipboardData(
                        text: 'itsmeprabhatjana@gmail.com'));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Email ID has been copied to clipboard',
                        ),
                      ),
                    );
                  },
                  child: Image.asset('assets/social/gmail.png', height: 35),
                ),
              ),
              const SizedBox(width: 10),
              FadeInDown(
                delay: const Duration(milliseconds: 450),
                child: InkWell(
                  onTap: () {
                    launchBrowser(
                        'https://www.instagram.com/thetwodigiter', context);
                  },
                  child: Image.asset('assets/social/instagram.png', height: 40),
                ),
              ),
              const SizedBox(width: 10),
              FadeInDown(
                delay: const Duration(milliseconds: 500),
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.black, shape: BoxShape.circle),
                  child: InkWell(
                    onTap: () {
                      launchBrowser(
                          'https://www.github.com/iamthetwodigiter', context);
                    },
                    child: Image.asset(
                      'assets/social/github.png',
                      height: 40,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              FadeInDown(
                delay: const Duration(milliseconds: 550),
                child: InkWell(
                  onTap: () {
                    launchBrowser(
                        'https://in.linkedin.com/in/prabhatjanaofficial',
                        context);
                  },
                  child: Image.asset('assets/social/linkedin.png', height: 35),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          FadeInLeft(
            delay: const Duration(milliseconds: 600),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Created with ",
                    style: TextStyle(
                        fontSize: 12,
                        color: darkMode
                            ? Theme.of(context).primaryColor
                            : Colors.black)),
                Icon(Icons.favorite, color: Theme.of(context).primaryColor),
                Text(
                  " by thetwodigiter",
                  style: TextStyle(
                    fontSize: 12,
                    color: darkMode
                        ? Theme.of(context).primaryColor
                        : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
