import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '/env.dart';

const base = 'https://api.openai.com/v1';
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

      // Show a loading dialog while processing the GPT request
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      try {
        // Prepare the prompt for GPT
        final prompt =
            'With this information: ${_responses.entries.map((entry) => '${entry.key}: ${entry.value}').join(', ')}, recommend all US government benefit programs the user is eligible to apply for with links to them.';

        // Make the API call to OpenAI
        final response = await http.post(
          Uri.parse('$base/chat/completions'),
          headers: headers,
          body: jsonEncode({
            'model': model,
            'messages': [
              {'role': 'user', 'content': prompt},
            ],
          }),
        );

        // Check the response status and process the response
        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          final recommendations =
              responseData['choices'][0]['message']['content'];

          // Close the loading dialog
          Navigator.of(context).pop();

          // Show the recommendations in a dialog
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Recommendations'),
              content: Text(recommendations),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        } else {
          throw Exception(
            'Failed to fetch recommendations: ${response.statusCode}',
          );
        }
      } catch (error) {
        // Close the loading dialog
        Navigator.of(context).pop();

        // Show an error dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: Text('Failed to fetch recommendations: $error'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
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
              ],
            ),
          ),
        ),
      );
}
