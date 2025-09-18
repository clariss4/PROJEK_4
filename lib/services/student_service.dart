import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/student.dart';

class StudentService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<Student>> getAllStudents() async {
    try {
      final res = await _client.from('students').select().order('created_at');
      return (res as List).map((e) => Student.fromMap(e)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> insertStudent(Student s) async {
    try {
      await _client.from('students').insert(s.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateStudent(Student s) async {
    try {
      await _client.from('students').update(s.toMap()).eq('id', s.id!);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteStudent(String id) async {
    try {
      await _client.from('students').delete().eq('id', id);
      return true;
    } catch (e) {
      return false;
    }
  }
}
