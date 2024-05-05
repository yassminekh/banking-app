import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:projetflutter/screens/auth/login_screen.dart';
import 'package:projetflutter/screens/auth/register_screen.dart';
import 'package:projetflutter/splashScreen.dart';
import 'package:projetflutter/utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Vérifiez que les valeurs FirebaseConfig ne sont pas nulles
  if (Constants.firebaseConfig['apiKey'] != null &&
      Constants.firebaseConfig['authDomain'] != null &&
      Constants.firebaseConfig['projectId'] != null &&
      Constants.firebaseConfig['storageBucket'] != null &&
      Constants.firebaseConfig['messagingSenderId'] != null &&
      Constants.firebaseConfig['appId'] != null &&
      Constants.firebaseConfig['measurementId'] != null) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: Constants.firebaseConfig['apiKey']!,
        authDomain: Constants.firebaseConfig['authDomain']!,
        projectId: Constants.firebaseConfig['projectId']!,
        storageBucket: Constants.firebaseConfig['storageBucket']!,
        messagingSenderId: Constants.firebaseConfig['messagingSenderId']!,
        appId: Constants.firebaseConfig['appId']!,
        measurementId: Constants.firebaseConfig['measurementId']!,
      ),
    );
  } else {
    // Gérez le cas où certaines valeurs FirebaseConfig sont nulles
    print('Certaines valeurs FirebaseConfig sont nulles');
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Banking App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(),
      routes: {
        '/login': (context) => LoginScreen(email: '', password: ''),
        '/register': (context) => RegisterScreen(),
      },
    );
  }
}
