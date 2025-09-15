import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:google_fonts/google_fonts.dart';
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
      backgroundColor: Colors.grey.shade200, //backgraound home page
      //appbar
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 110,
        elevation: 8,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.lightBlueAccent, Colors.blueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.school, color: Colors.white, size: 50),
            const SizedBox(width: 10),
            Text(
              'DATA SISWA SMK',
              style: GoogleFonts.ubuntu(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
            ),
          ],
        ),
      ),
      body: _students.isEmpty
          ? _buildEmptyState()
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.separated(
                itemCount: _students.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
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
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final newStudent = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const FormPage()),
          );
          if (newStudent != null) {
            _addStudent(newStudent);
          }
        },
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Tambah Data',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        backgroundColor: Colors.lightBlue,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.group, size: 100, color: Colors.grey),
          const SizedBox(height: 20),
          Text(
            'Belum ada data siswa',
            style: GoogleFonts.poppins(
              fontSize: 18,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Tekan tombol + untuk menambahkan data',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}
