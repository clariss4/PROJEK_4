import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/student.dart';

class StudentRepository {
  final SupabaseClient client = Supabase.instance.client;

  /// Ambil semua siswa
  Future<List<Student>> getStudents() async {
    final data = await client.from('student').select();
    return List<Map<String, dynamic>>.from(
      data,
    ).map((json) => Student.fromJson(json)).toList();
  }

  /// Ambil data alamat
  Future<List<Map<String, dynamic>>> getAlamat() async {
    final data = await client.from('alamat').select();
    return List<Map<String, dynamic>>.from(data);
  }

  /// Tambah data siswa
  Future<void> insertStudent(Student student) async {
    await client.from('student').insert([student.toJson()]);
  }

  /// Update data siswa
  Future<void> updateStudent(Student student) async {
    await client.from('student').update(student.toJson()).eq('id', student.id);
  }

  /// Hapus data siswa
  Future<void> deleteStudent(String id) async {
    await client.from('student').delete().eq('id', id);
  }
}
