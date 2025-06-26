import 'package:flutter/material.dart';
import 'base_activity.dart';

class PrivacyPolicyActivity extends StatelessWidget {
  const PrivacyPolicyActivity({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseActivity(
      title: 'Privacy Policy',
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Privacy Policy\n\n'
              'At Erickfy, we value your privacy and are committed to protecting your personal information. This Privacy Policy outlines how we collect, use, and safeguard your data when you use our mobile application.\n\n'
              '1. Information We Collect:\n'
              '- We may collect basic information such as your name, email address, and preferences when you interact with the app.\n'
              '- We may also collect anonymous usage data to improve app performance and user experience.\n\n'
              '2. How We Use Your Information:\n'
              '- To personalize your experience within the app.\n'
              '- To improve our services and provide relevant content.\n'
              '- To communicate with you about updates or support.\n\n'
              '3. Data Sharing:\n'
              '- We do not sell or rent your personal information to third parties.\n'
              '- We may share data with trusted service providers who help us operate the app, under strict confidentiality agreements.\n\n'
              '4. Security:\n'
              '- We implement industry-standard security measures to protect your data from unauthorized access or disclosure.\n\n'
              '5. Your Choices:\n'
              '- You can manage your data preferences in the app settings.\n'
              '- You may request to access, update, or delete your personal information by contacting us.\n\n'
              '6. Changes to This Policy:\n'
              '- We may update this Privacy Policy from time to time. We will notify you of any significant changes within the app.\n\n'
              '7. Contact Us:\n'
              'If you have any questions or concerns about this policy, please reach out to us at support@erickfy.com.\n\n'
              'By using Erickfy, you agree to the terms outlined in this Privacy Policy.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(height: 16),
            Text(
              'Your privacy is important to us...',
              // Add your full privacy policy text here
            ),
          ],
        ),
      ),
    );
  }
}
