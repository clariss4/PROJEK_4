import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/student.dart';
import '../widgets/student_card.dart';
import 'form_page.dart';
import 'detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Student> _students = [];
  final uuid = const Uuid();

  void _addStudent(Student student) {
    setState(() {
      _students.add(student);
    });
  }

  void _editStudent(Student updatedStudent, int index) {
    setState(() {
      _students[index] = updatedStudent;
    });
  }

  void _deleteStudent(int index) {
    setState(() {
      _students.removeAt(index);
    });
  }

  void _navigateToDetail(Student student) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DetailPage(student: student)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CRUD Data Siswa'), centerTitle: true),
      body: _students.isEmpty
          ? const Center(child: Text('Belum ada data siswa.'))
          : ListView.builder(
              itemCount: _students.length,
              itemBuilder: (context, index) {
                final student = _students[index];
                return StudentCard(
                  student: student,
                  onTap: () => _navigateToDetail(student),
                  onEdit: () async {
                    final updatedStudent = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            FormPage(student: student, index: index),
                      ),
                    );
                    if (updatedStudent != null) {
                      _editStudent(updatedStudent, index);
                    }
                  },
                  onDelete: () => _deleteStudent(index),
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
            _addStudent(newStudent);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
