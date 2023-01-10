import 'package:flutter/material.dart';
import 'package:outlead_solutions/screens/onboding/components/sign_in_provider.dart';

import 'SplashScreen.dart';
import 'screens/LeavesManagement/leave_req_provider.dart';
import 'screens/onboding/onboding_screen.dart';
import 'package:provider/provider.dart';
final navigatorKey = GlobalKey<NavigatorState>();
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SignInProvider>(create: (_) => SignInProvider(),),
        ChangeNotifierProvider<LeaveReqProvider>(create: (_) => LeaveReqProvider(),),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'The Flutter Way',
        theme: ThemeData(
          scaffoldBackgroundColor: Color(0xFFEEF1F8),
          primarySwatch: Colors.blue,
          fontFamily: "Intel",
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            errorStyle: TextStyle(height: 0),
            border: defaultInputBorder,
            enabledBorder: defaultInputBorder,
            focusedBorder: defaultInputBorder,
            errorBorder: defaultInputBorder,
          ),
        ),
        home: SplashScreen(),
      ),
    );
  }
}

const defaultInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(16)),
  borderSide: BorderSide(
    color: Color(0xFFDEE3F2),
    width: 1,
  ),
);
