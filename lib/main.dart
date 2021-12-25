import 'package:flutter/material.dart';
import 'package:lrcokl/ui/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'get_bindings.dart';

void main() async {
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBj8ZUjuoTvqxltfPx1svADCtMZ05FKVLY",
      appId: "1:1081503252980:web:a071e98e67212b9dc3b9a1",
      messagingSenderId: "1081503252980",
      projectId: "lrcokl-6dee6",
      storageBucket: "lrcokl-6dee6.appspot.com",
      measurementId: "G-QCV9M16H1C",
    ),
  );
  GetInitializer().dependencies();
  await Future.delayed(const Duration(milliseconds: 500));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Attendance LRCO',
      theme: ThemeData(
        primarySwatch: white,
      ),
      home: Home(),
      // debugShowCheckedModeBanner: false,
    );
  }
}

const MaterialColor white = MaterialColor(
  0xFFFFFFFF,
  <int, Color>{
    50: Color(0xFFFFFFFF),
    100: Color(0xFFFFFFFF),
    200: Color(0xFFFFFFFF),
    300: Color(0xFFFFFFFF),
    400: Color(0xFFFFFFFF),
    500: Color(0xFFFFFFFF),
    600: Color(0xFFFFFFFF),
    700: Color(0xFFFFFFFF),
    800: Color(0xFFFFFFFF),
    900: Color(0xFFFFFFFF),
  },
);
