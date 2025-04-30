import 'package:flutter/material.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({Key? key}) : super(key: key);

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _search = '';

  final List<Map<String, String>> faqs = [
    {'q': 'Who is eligible for flight compensation?', 'a': 'You may be eligible if your flight was delayed more than 3 hours, cancelled, or you were denied boarding (e.g., overbooking). Eligibility depends on airline, route, and reason.'},
    {'q': 'What information do I need to submit a claim?', 'a': 'You will need your flight number, date, departure and arrival airports, and the reason for your claim (delay, cancellation, etc.). Accurate contact details help us process your claim.'},
    {'q': 'How is my personal data used?', 'a': 'Your data is only used to process your compensation claim and is never shared with third parties except as required for claim processing.'},
    {'q': 'How do I find my flight number and airport codes?', 'a': 'Check your ticket or boarding pass for the flight number (e.g., LH1234). Airport codes are 3-letter codes (e.g., FRA for Frankfurt, JFK for New York).'},
    {'q': 'Can I edit or withdraw a claim after submitting?', 'a': 'Editing/withdrawing claims is coming soon. For now, contact support if you need to make changes.'},
    {'q': 'How do I know if my claim was successful?', 'a': 'You can track the status of your claim in the "My Claims" section. You will also be notified if your claim is approved or rejected.'},
    {'q': 'What if my flight is not detected automatically?', 'a': 'You can always submit a claim manually. Make sure location permissions are granted for best automatic detection.'},
    {'q': 'Where can I get more help?', 'a': 'Contact our support team via the app or email for further assistance.'},
  ];

  @override
  Widget build(BuildContext context) {
    final filteredFaqs = faqs.where((faq) {
      final q = faq['q']!.toLowerCase();
      final a = faq['a']!.toLowerCase();
      final s = _search.toLowerCase();
      return s.isEmpty || q.contains(s) || a.contains(s);
    }).toList();

    Widget highlight(String text, String query) {
      if (query.isEmpty) return Text(text);
      final lcText = text.toLowerCase();
      final lcQuery = query.toLowerCase();
      final spans = <TextSpan>[];
      int start = 0;
      int idx;
      do {
        idx = lcText.indexOf(lcQuery, start);
        if (idx < 0) {
          spans.add(TextSpan(text: text.substring(start)));
          break;
        }
        if (idx > start) {
          spans.add(TextSpan(text: text.substring(start, idx)));
        }
        spans.add(TextSpan(
          text: text.substring(idx, idx + query.length),
          style: TextStyle(backgroundColor: Color(0xFFFFF59D)), // yellow highlight
        ));
        start = idx + query.length;
      } while (start < text.length);
      return RichText(text: TextSpan(style: TextStyle(color: Colors.black), children: spans));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('FAQ & Help')),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.shade100),
            ),
            child: Row(
              children: [
                const Icon(Icons.search, color: Colors.blueGrey),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search FAQ...',
                      border: InputBorder.none,
                    ),
                    onChanged: (val) => setState(() { _search = val; }),
                  ),
                ),
                if (_search.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.clear, color: Colors.grey),
                    onPressed: () {
                      _searchController.clear();
                      setState(() { _search = ''; });
                    },
                  ),
              ],
            ),
          ),
          Expanded(
            child: filteredFaqs.isEmpty
                ? const Center(child: Text('No results found.', style: TextStyle(color: Colors.grey)))
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredFaqs.length,
                    separatorBuilder: (_, __) => const Divider(height: 32),
                    itemBuilder: (context, i) => Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      child: ExpansionTile(
                        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        childrenPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
                        title: highlight(filteredFaqs[i]['q']!, _search),
                        children: [
                          highlight(filteredFaqs[i]['a']!, _search),
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
