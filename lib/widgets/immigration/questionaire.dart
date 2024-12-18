import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '/env.dart';

const base = 'https://api.openai.com/v1';

class RecommendedData {
  final String title;
  final String subtitle;
  final String link;

  RecommendedData({
    required this.title,
    required this.subtitle,
    required this.link,
  });

  /// Factory constructor to create a `RecommendedData` object from JSON
  factory RecommendedData.fromJson(Map<String, dynamic> json) =>
      RecommendedData(
        title: json['title'] ?? 'No Title',
        subtitle: json['subtitle'] ?? 'No Details',
        link: json['link'] ?? '',
      );

  /// Method to convert a `RecommendedData` object back to JSON
  Map<String, dynamic> toJson() => {
        'title': title,
        'subtitle': subtitle,
        'link': link,
      };
}

final headers = {
  'Content-Type': 'application/json',
  'Authorization': 'Bearer ${Env.openaiApiKey}',
};
const model = 'gpt-3.5-turbo';

class QuestionnaireApp extends StatelessWidget {
  const QuestionnaireApp({super.key});

  @override
  Widget build(BuildContext context) => const MaterialApp(
        title: 'Questionnaire',
        home: QuestionnaireScreen(),
      );
}

class QuestionnaireScreen extends StatefulWidget {
  const QuestionnaireScreen({super.key});

  @override
  _QuestionnaireScreenState createState() => _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends State<QuestionnaireScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _responses = {};
  String _recommendations = ''; // Holds GPT recommendations

  final List<String> employmentStatusOptions = [
    'Employed',
    'Unemployed',
    'Self-employed',
    'Student',
    'Retired',
  ];
  final List<String> raceOptions = [
    'Asian',
    'Black or African American',
    'Hispanic or Latino',
    'White',
    'Other',
  ];
  final List<String> maritalStatusOptions = [
    'Single',
    'Married',
    'Divorced',
    'Widowed',
  ];
  final List<String> housingSituationOptions = [
    'Rent',
    'Own',
    'Homeless',
    'Other',
  ];

  void _submitForm() async {
  if (_formKey.currentState?.validate() ?? false) {
    _formKey.currentState?.save();

      setState(() {
        _recommendations = 'Loading...'; // Show loading state
      });

      try {
        // Prepare the prompt for GPT
        final prompt = '''
        Based on the following user data: 
        ${_responses.entries.map((entry) => '${entry.key}: ${entry.value}').join(', ')}. 

        Provide the recommendations for US government benefit programs the user is eligible for in the following JSON format:
        [
          {
            "title": "Program Title",
            "subtitle": "Eligibility details",
            "link": "Program link"
          },
          ...
        ]
      Do not recommend any programs if the user's income is too high or if they already have government assistance from the programs.
      ''';

      // Make the API call to OpenAI
      final response = await http.post(
        Uri.parse('$base/chat/completions'),
        headers: headers,
        body: jsonEncode({
          'model': model,
          'messages': [
            {'role': 'user', 'content': prompt},
          ],
        ),
      );

      // Check the response status and process the response
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final recommendations =
            responseData['choices'][0]['message']['content'];

          // Update the UI with the recommendations
          setState(() {
            _recommendations = recommendations;
          });
        } else {
          throw Exception(
            'Failed to fetch recommendations: ${response.statusCode}',
          );
        }
      } catch (error) {
        // Show an error message in the UI
        setState(() {
          _recommendations = 'Failed to fetch recommendations: $error';
        });
      }
    }
  }

  Widget _buildRecommendationsContent(String recommendations) {
    try {
      // Check if the recommendations string is valid JSON
      if (recommendations == 'Loading...' || recommendations.isEmpty) {
        return const Text('Fetching recommendations...');
      }

      // Parse the JSON response
      final List<dynamic> jsonResponse = jsonDecode(recommendations);
      final List<RecommendedData> recommendedDataList =
          jsonResponse.map((item) => RecommendedData.fromJson(item)).toList();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: recommendedDataList
            .map<Widget>(
              (program) => Card(
                margin: const EdgeInsets.only(bottom: 16.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        program.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(program.subtitle),
                      if (program.link.isNotEmpty)
                        TextButton(
                          onPressed: () async {
                            final uri = Uri.parse(program.link);
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(
                                uri,
                                mode: LaunchMode.externalApplication,
                              );
                            }
                          },
                          child: Text(
                            program.link,
                            style: const TextStyle(color: Colors.blue),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            )
            .toList(),
      );
    } catch (e) {
      return Text('Error parsing recommendations: $e');
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Questionnaire'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'What is your age?'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your age';
                    } else if (int.tryParse(value) == null ||
                        int.parse(value) <= 0) {
                      return 'Please enter a valid age';
                    }
                    return null;
                  },
                  onSaved: (value) => _responses['age'] = value ?? '',
                ),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'What is your race/ethnicity?',
                  ),
                  items: raceOptions
                      .map(
                        (race) => DropdownMenuItem(
                          value: race,
                          child: Text(race),
                        ),
                      )
                      .toList(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select your race/ethnicity';
                    }
                    return null;
                  },
                  onSaved: (value) => _responses['race'] = value ?? '',
                  onChanged: (value) {},
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'What is your annual income?',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your annual income';
                    } else if (double.tryParse(value) == null ||
                        double.parse(value) < 0) {
                      return 'Please enter a valid income';
                    }
                    return null;
                  },
                  onSaved: (value) => _responses['income'] = value ?? '',
                ),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'What is your current employment status?',
                  ),
                  items: employmentStatusOptions
                      .map(
                        (status) => DropdownMenuItem(
                          value: status,
                          child: Text(status),
                        ),
                      )
                      .toList(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select your employment status';
                    }
                    return null;
                  },
                  onSaved: (value) =>
                      _responses['employmentStatus'] = value ?? '',
                  onChanged: (value) {},
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Do you have any dependents? If yes, how many?',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the number of dependents or 0 if none';
                    } else if (int.tryParse(value) == null ||
                        int.parse(value) < 0) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                  onSaved: (value) => _responses['dependents'] = value ?? '',
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText:
                        'Do you currently receive any government benefits? If yes, specify.',
                  ),
                  onSaved: (value) =>
                      _responses['currentBenefits'] = value ?? '',
                ),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'What is your marital status?',
                  ),
                  items: maritalStatusOptions
                      .map(
                        (status) => DropdownMenuItem(
                          value: status,
                          child: Text(status),
                        ),
                      )
                      .toList(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select your marital status';
                    }
                    return null;
                  },
                  onSaved: (value) => _responses['maritalStatus'] = value ?? '',
                  onChanged: (value) {},
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'What is your highest level of education?',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your highest level of education';
                    }
                    return null;
                  },
                  onSaved: (value) =>
                      _responses['educationLevel'] = value ?? '',
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Do you have any disabilities? If yes, specify.',
                  ),
                  onSaved: (value) => _responses['disabilities'] = value ?? '',
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText:
                        'Are you a veteran or currently serving in the military?',
                  ),
                  onSaved: (value) => _responses['veteranStatus'] = value ?? '',
                ),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'What is your housing situation?',
                  ),
                  items: housingSituationOptions
                      .map(
                        (situation) => DropdownMenuItem(
                          value: situation,
                          child: Text(situation),
                        ),
                      )
                      .toList(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select your housing situation';
                    }
                    return null;
                  },
                  onSaved: (value) =>
                      _responses['housingSituation'] = value ?? '',
                  onChanged: (value) {},
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Submit'),
                ),
                const SizedBox(height: 20),
                // Display recommendations below the submit button
                if (_recommendations.isNotEmpty)
                  _buildRecommendationsContent(_recommendations),
              ],
            ),
          ),
        ),
      );
}
