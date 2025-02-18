import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';

import 'providers/time_entry_provider.dart';
import 'providers/project_task_provider.dart';
import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initLocalStorage();
  runApp( MultiProvider(
      providers: [
        ChangeNotifierProvider<TimeEntryProvider>(
          create: (_) => TimeEntryProvider(localStorage),
        ),
        ChangeNotifierProvider<ProjectTaskProvider>(
          create: (_) => ProjectTaskProvider(localStorage),
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
