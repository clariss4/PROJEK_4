import 'package:flutter/material.dart';
import 'package:projek_4/pages/form_page_decor.dart';
import '../models/student.dart';
import '../widgets/student_card.dart';
import 'detail_page.dart';
import 'form_page.dart';
import '../services/student_service.dart';
import '../services/exception.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final StudentService _service = StudentService();
  List<Student> students = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  Future<void> _loadStudents() async {
    setState(() => _isLoading = true);
    try {
      final list = await _service.getAllStudents();
      setState(() => students = list);
    } on NetworkException {
      _showSnack('Tidak ada koneksi internet');
    } on DatabaseException catch (e) {
      _showSnack(e.message);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating),
    );
  }

  /* ---------- Floating Button Animasi ---------- */
  void _onAddTap() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const FormPage()),
    );
    if (result != null) _loadStudents();
  }

  /* ---------- Build Modern ---------- */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color.fromARGB(255, 231, 238, 241),
      appBar: AppBar(
        toolbarHeight: 80,
        title: const Text(
          'Data Siswa SMK',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        elevation: 0,
        foregroundColor: const Color.fromARGB(255, 255, 255, 255),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromARGB(255, 86, 164, 241), Color(0xFF42A5F5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: _isLoading
          ? _shimmerLoader()
          : students.isEmpty
          ? _emptyState()
          : _studentList(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _onAddTap,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Tambah Siswa'),
        backgroundColor: const Color.fromARGB(255, 81, 130, 204),
        foregroundColor: Colors.white,
        extendedPadding: const EdgeInsets.symmetric(horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
    );
  }

  /* ---------- Shimmer Loader ---------- */
  Widget _shimmerLoader() {
    return ListView.builder(
      itemCount: 6,
      padding: const EdgeInsets.only(top: 100),
      itemBuilder: (_, __) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Container(
          height: 88,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(24),
          ),
        ),
      ),
    );
  }

  /* ---------- Empty State ---------- */
  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.school, size: 120, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Belum ada data siswa',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tekan + untuk menambahkan',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  /* ---------- Student List ---------- */
  Widget _studentList() {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 100, bottom: 32),
      itemCount: students.length,
      itemBuilder: (context, index) {
        final s = students[index];
        return StudentCard(
          student: s,
          onEdit: () async {
            final updated = await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => FormPage(student: s)),
            );
            if (updated != null) _loadStudents();
          },
          onDelete: () async {
            final confirm = await showDialog<bool>(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Konfirmasi'),
                content: Text('Hapus ${s.namaLengkap}?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Batal'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Hapus'),
                  ),
                ],
              ),
            );
            if (confirm == true) {
              try {
                await _service.deleteStudent(s.id!);
                _showSnack('Berhasil dihapus');
                _loadStudents();
              } catch (e) {
                _showSnack(e.toString());
              }
            }
          },
          onTap: () async {
            final updated = await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => DetailPage(student: s)),
            );
            if (updated != null) _loadStudents();
          },
        );
      },
    );
  }
}
