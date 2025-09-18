import 'package:flutter/material.dart';
import '../models/student.dart';
import '../widgets/student_card.dart';
import 'form_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Student> students = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Siswa'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.lightBlueAccent],
            ),
          ),
        ),
      ),
      body: students.isEmpty
          ? const Center(
              child: Text(
                'Belum ada data siswa',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                final student = students[index];
                return StudentCard(
                  student: student,
                  onEdit: () async {
                    final updatedStudent = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FormPage(student: student),
                      ),
                    );
                    if (updatedStudent != null) {
                      setState(() {
                        students[index] = updatedStudent;
                      });
                    }
                  },
                  onDelete: () {
                    setState(() {
                      students.removeAt(index);
                    });
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newStudent = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const FormPage()),
          );
          if (newStudent != null) {
            setState(() {
              students.add(newStudent);
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
