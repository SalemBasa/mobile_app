import 'package:flutter/material.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trash_track_mobile/features/quiz/models/quiz.dart';
import 'package:trash_track_mobile/features/quiz/services/quiz_service.dart';

class QuizDetailsScreen extends StatefulWidget {
  final Quiz quiz;

  QuizDetailsScreen({required this.quiz});

  @override
  _QuizDetailsScreenState createState() => _QuizDetailsScreenState();
}

class _QuizDetailsScreenState extends State<QuizDetailsScreen> {
  late QuizService _quizService;
  List<int> selectedAnswerIds = [];
  int? userId;
  bool submitting = false;

  @override
    void initState() {
    super.initState();
    _quizService = context.read<QuizService>();
    _fetchUserIdFromToken();
  }

  void toggleAnswer(int answerId) {
    setState(() {
      if (selectedAnswerIds.contains(answerId)) {
        selectedAnswerIds.remove(answerId);
      } else {
        selectedAnswerIds.add(answerId);
      }
    });
  }

  Future<void> _fetchUserIdFromToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');


    if (token != null) {
      Map<String, dynamic> decodedToken = Jwt.parseJwt(token);
      final userIdString = decodedToken['Id']; // Extract the ID as a string

      if (userIdString != null) {
        // Convert the string to an integer
        setState(() {
          userId = int.tryParse(
              userIdString); // Use tryParse to handle invalid inputs
        });
      }
    }
  }

  Future<void> submitQuiz() async {
    setState(() {
      submitting = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Quiz Title: ${widget.quiz.title ?? ''}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1D1C1E),
              ),
            ),
            Text(
              'Quiz Description: ${widget.quiz.description ?? ''}',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF1D1C1E),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Questions:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1D1C1E),
              ),
            ),
            if (widget.quiz.questions != null)
              for (var question in widget.quiz.questions!)
                Column(
                  children: [
                    Text(
                      'Question: ${question.content ?? ''}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    for (var answer in question.answers ?? [])
                      Row(
                        children: [
                          Checkbox(
                            value: selectedAnswerIds.contains(answer.id),
                            onChanged: submitting
                                ? null
                                : (value) => toggleAnswer(answer.id!),
                          ),
                          Text(answer.content ?? ''),
                        ],
                      ),
                  ],
                ),
            ElevatedButton(
              onPressed: () async {
                // Validate the "Note" field
                if (selectedAnswerIds.isEmpty) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text('You must select answer.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                  return; 
                }

                final finishedQuiz = {
                  'userId' : userId,
                  'quizId' : widget.quiz.id,
                  'userAnswerIds' : selectedAnswerIds
                };

                try {
                  await _quizService.quizSubmission(finishedQuiz);
                  // Optionally, you can navigate to another screen or show a success message here.
                } catch (error) {
                  print('Error submiting quiz: $error');
                  // Handle the error, e.g., show an error message.
                }
              },
              child: submitting ? CircularProgressIndicator() : Text('Finish'),
            ),
          ],
        ),
      ),
    );
  }
}
