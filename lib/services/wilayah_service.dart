import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/wilayah_model.dart';

final _client = Supabase.instance.client;

class WilayahService {
  static Future<List<Wilayah>> searchDusun(String pattern) async {
    try {
      print('🔍 search pattern: $pattern');
      if (pattern.length < 2) return [];

      final res = await _client
          .from('vw_wilayah')
          .select()
          .ilike('dusun', '%$pattern%')
          .limit(10);

      print('✅ result count: ${res.length}');
      return (res as List).map((e) => Wilayah.fromJson(e)).toList();
    } catch (e) {
      print('❌ error searchDusun: $e');
      throw 'Gagal memuat data';
    }
  }
}
