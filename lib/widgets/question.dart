import 'package:flutter/material.dart';


class QuestionWidget extends StatelessWidget {
  const QuestionWidget(
      {Key? key,
      required this.question,
      required this.indexAction,
      required this.totalQuestions})
      : super(key: key);
  // here we need the question title and the total number of questions, and also the index

  final String question;
  final int indexAction;
  final int totalQuestions;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'Question ${indexAction + 1}/$totalQuestions: $question',
          style: const TextStyle(
            fontSize: 24.0,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
