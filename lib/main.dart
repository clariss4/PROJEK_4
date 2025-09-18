import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pages/home_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // inisialisasi Supabase
  await Supabase.initialize(
    url: 'https://ofwzwdmslqrpmopodhbq.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9md3p3ZG1zbHFycG1vcG9kaGJxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTc5OTE3MjcsImV4cCI6MjA3MzU2NzcyN30.GMGKaU38oKxRfOSFo7hf83HHK8XHElLS2huMelQqNaI',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aplikasi Siswa',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.ubuntuTextTheme(Theme.of(context).textTheme),
      ),
      home: const HomePage(),
    );
  }
}
