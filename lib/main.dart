import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:necta_test3/schools_provider.dart';
import 'package:necta_test3/firestore_repository.dart';
import 'package:necta_test3/ui.dart';
import 'package:necta_test3/ui/data_viewer.dart';
import 'package:necta_test3/firebase_options.dart';
import 'package:necta_test3/file_processor.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  WakelockPlus.enable();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final fileProcessor = FileProcessor();

  await fileProcessor.initHive();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 32, 114, 7)),
          useMaterial3: true,
        ),
        home: SchoolListScreen()

        //  DataViewer(
        //   zipUrl: 'gs://necta-test1-81f48.appspot.com/csee/2023/2023.zip',
        // ),
        );
  }
}
