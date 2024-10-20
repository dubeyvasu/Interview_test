import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:training_project/quizScreen.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class QuizHomePage extends StatefulWidget {
  const QuizHomePage({super.key});

  @override
  State<QuizHomePage> createState() => _QuizHomePageState();
}

class _QuizHomePageState extends State<QuizHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('Quiz App',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Display the Quiz Screen
          Expanded(
            child: QuizScreen(),
          ),
          // Button to View Marks
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // Navigate to the Marks Screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MarksScreen(
                  userId: FirebaseAuth.instance.currentUser!.uid,
                  )),
                );
              },
              child: const Text('View Marks'),
            ),
          ),
        ],
      ),
    );
  }
}


class MarksScreen extends StatelessWidget {
  final String userId;

  const MarksScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Marks List'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)  // Replace with actual user ID
            .collection('Scores') // Accessing Scores collection for the user
            .orderBy('date', descending: true) // Sorting by timestamp
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No scores available.'));
          }

          final scoresDocs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: scoresDocs.length,
            itemBuilder: (context, index) {
              var doc = scoresDocs[index];
              var score = doc['score'];
              var timestamp = (doc['date'] as Timestamp).toDate();

              return ListTile(
                title: Text('Score: $score'),
                subtitle: Text('Date: ${timestamp.toString()}'),
              );
            },
          );
        },
      ),
    );
  }
}
