import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/time_entry_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp( MultiProvider(
      providers: [
        ChangeNotifierProvider<TimeEntryProvider>(
          create: (_) => TimeEntryProvider(),
        ),
        
      ],
      child: MyApp(),
    ),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Time Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, secondary: Colors.blue[900]),
        useMaterial3: true,
      ),
      home: HomeScreen(),
    );
  }
}
