import 'package:flutter/material.dart';

class HelpActivity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Help')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Frequently Asked Questions',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 16),
            _buildFAQ(
              context,
              question: 'How do I search for a movie?',
              answer:
                  'Tap the search icon on the home screen and enter the movie title or IMDb ID. You’ll see suggestions and detailed information instantly.',
            ),
            _buildFAQ(
              context,
              question: 'Where does Erickfy get its movie data?',
              answer:
                  'We use the Free IMDb API to fetch accurate and up-to-date information about movies and TV shows.',
            ),
            _buildFAQ(
              context,
              question: 'Why do some posters show a placeholder image?',
              answer:
                  'If a movie poster is missing or marked as "N/A" in the API, Erickfy uses a fallback placeholder to maintain visual consistency.',
            ),
            _buildFAQ(
              context,
              question: 'Can I save movies or mark favorites?',
              answer:
                  'This feature is coming soon! We’re working on a favorites list that syncs with your profile across devices.',
            ),
            _buildFAQ(
              context,
              question: 'How can I contact support?',
              answer:
                  'Reach out to us anytime at support@erickfy.com. We typically respond within 24 hours.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQ(
    BuildContext context, {
    required String question,
    required String answer,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: ExpansionTile(
        title: Text(question, style: Theme.of(context).textTheme.titleMedium),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(answer, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
