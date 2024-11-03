import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'About',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Text(
            'This cross-plattform application is build inside the Course DES424-Cloud Application Development from Group 4 at SIIT Thammasat University. ',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 30),
          const Text(
            'Find this application on Github:',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
         
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () async {
              final url = Uri(
                scheme: 'https',
                host: 'github.com',
                path: '/orbitpeppermint/travelcompanionfinder',
              );
              if (await canLaunchUrl(url)) launchUrl(url);
            },
            child: const Text(
              'Travel Companion Finder.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.blue,
                fontSize: 16,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
