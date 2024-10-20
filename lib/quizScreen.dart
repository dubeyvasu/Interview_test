import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late Future<List<Question>> _questions = Future.value([]);
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  int index = 0;
  int score = 0;
  bool isPressed = false;

  @override
  void initState() {
    super.initState();
    _fetchQuestions();
  }

  Future<void> _fetchQuestions() async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('questions')
          .get();

      if (querySnapshot.docs.isEmpty) {
        setState(() {
          _questions = Future.value([Question(id: '', title: 'No questions available', options: {})]);
        });
      } else {
        List<Question> questions = querySnapshot.docs.map((doc) {
          return Question(
            id: doc.id,
            title: doc['title'],
            options: Map<String, bool>.from(doc['options']),
          );
        }).toList();

        setState(() {
          _questions = Future.value(questions);
        });
      }
    } catch (error) {
      print('Failed to fetch questions: $error');
    }
  }

  Future<void> addUserScore(String userId, int score, int questionLength) async {
    double percentage = (score / questionLength) * 100;
    String passStatus = percentage >= 60 ? 'Pass' : 'Fail';

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('Scores')
          .doc()
          .set({
        'score': score,
        'passStatus': passStatus,
        'date': FieldValue.serverTimestamp(),
        'questionLength': questionLength,
      });
    } catch (error) {
      print('Failed to update scores: $error');
    }
  }
void nextQuestion(int questionLength) {
  if (!isPressed) {
    // If no answer has been selected, show a message to prompt the user to answer
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Please select an answer before proceeding.'),
        duration: Duration(seconds: 2),
      ),
    );
    return;
  }

  if (index == questionLength - 1) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text('Quiz Completed'),
        content: Text('Your score is $score/$questionLength'),
        actions: [
          TextButton(
            onPressed: () {
              addUserScore(userId, score, questionLength);
              Navigator.of(context).pop();
              startOver();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  } else {
    setState(() {
      index++;
      isPressed = false; // Reset for the next question
    });
  }
}

  void checkAnswer(bool value) {
    if (!isPressed) {
      if (value == true) score++;
      setState(() {
        isPressed = true;
      });
    }
  }

  void startOver() {
    setState(() {
      index = 0;
      score = 0;
      isPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Question>>(
      future: _questions,
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No questions available'));
        }

        var question = snapshot.data![index];
        var options = question.options.keys.toList();

        return Scaffold(
          appBar: AppBar(title: Text('Quiz')),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Question ${index + 1}: ${question.title}'),
                ...options.asMap().entries.map((entry) {
                  int optionIndex = entry.key;
                  String option = entry.value;
                  return ListTile(
                    title: Text(option),
                    tileColor: isPressed
                        ? (question.options[option]! ? Colors.green : Colors.red)
                        : null,
                    onTap: () => checkAnswer(question.options[option]!),
                  );
                }).toList(),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => nextQuestion(snapshot.data!.length),
            child: Text('Next'),
          ),
        );
      },
    );
  }
}

class Question {
  final String id;
  final String title;
  final Map<String, bool> options;

  Question({required this.id, required this.title, required this.options});
}
