import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:training_project/firebase_options.dart';
import 'package:training_project/homepage.dart';
import 'package:training_project/login.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized(
    
  );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  SharedPreferences preferences=await SharedPreferences.getInstance();
  
  bool isLoggedin=preferences.getBool('isLoggedin')??false;
print(isLoggedin);
  runApp( MyApp(isLoggedin: isLoggedin,));
  
}

class MyApp extends StatelessWidget {
  final bool isLoggedin;
  const MyApp({super.key,required this.isLoggedin});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Training demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:isLoggedin? QuizHomePage():LoginPage(),
    );
  }
}

