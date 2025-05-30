import 'package:flutter/material.dart';

class PrivacyAndTermsPage extends StatelessWidget {
  const PrivacyAndTermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> privacyAndTerms = [
      {
        'title': 'Privacy Policy',
        'content': 'At RoadSaver, we are committed to protecting your privacy. We collect personal information such as your name, email, and location to provide our services. This information is used solely for processing your service requests and improving our platform. We do not share your data with third parties without your consent, except as required by law.',
      },
      {
        'title': 'Data Collection',
        'content': 'We collect data such as your location to connect you with nearby trucks and gas stations. Payment information is securely processed through trusted payment gateways. You can opt out of data collection by contacting our support team, but this may limit some app functionalities.',
      },
      {
        'title': 'Terms of Service',
        'content': 'By using RoadSaver, you agree to our terms of service. You must provide accurate information when requesting services. RoadSaver is not liable for delays caused by external factors such as traffic or weather conditions. All payments are non-refundable once the service is completed.',
      },
      {
        'title': 'User Responsibilities',
        'content': 'Users are responsible for ensuring their vehicle is accessible to our service trucks. Any misuse of the app, including false requests, may result in account suspension. Please review our full terms on our website for more details.',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Privacy and Terms',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: privacyAndTerms.length,
          itemBuilder: (context, index) {
            final item = privacyAndTerms[index];
            return ExpansionTile(
              leading: Image.asset(
                'assets/images/lock_icon.png',
                width: 40,
                height: 40,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.lock,
                  color: Colors.greenAccent,
                  size: 40,
                ),
              ),
              title: Text(
                item['title']!,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    item['content']!,
                    style: const TextStyle(color: Colors.white54),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}