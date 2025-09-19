import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/student.dart';
import '../models/wilayah_model.dart';
import 'exception.dart';

final _client = Supabase.instance.client;

class StudentService {
  /// Ambil semua siswa + alamat + orang tua
  Future<List<Student>> getAllStudents() async {
    try {
      final res = await _client
          .from('vw_siswa_complete') // ← view baru
          .select();
      return (res as List).map((e) => Student.fromJson(e)).toList();
    } catch (e) {
      throw DatabaseException('Gagal memuat data: $e');
    }
  }

  /* ---------- sisanya tetap ---------- */
  Future<bool> insertStudent(Student s) async {
    try {
      await _client.from('siswa').insert([s.toMap()]);
      return true;
    } catch (e) {
      throw DatabaseException('Gagal menyimpan: $e');
    }
  }

  Future<bool> updateStudent(Student s) async {
    if (s.id == null) throw DatabaseException('ID kosong');
    try {
      await _client.from('siswa').update(s.toMap()).eq('id', s.id!);
      return true;
    } catch (e) {
      throw DatabaseException('Gagal update: $e');
    }
  }

  Future<bool> deleteStudent(String id) async {
    try {
      await _client.from('siswa').delete().eq('id', id);
      return true;
    } catch (e) {
      throw DatabaseException('Gagal hapus: $e');
    }
  }

  static Future<List<Wilayah>> searchDusun(String pattern) async {
    try {
      if (pattern.isEmpty) return [];
      final res = await _client
          .from('vw_wilayah')
          .select()
          .ilike('dusun', '%$pattern%')
          .limit(10);
      return (res as List).map((e) => Wilayah.fromJson(e)).toList();
    } catch (e) {
      throw NetworkException('Gagal cari dusun: $e');
    }
  }
}
