// services/wilayah_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/wilayah_model.dart';

class WilayahService {
  static final SupabaseClient _client = Supabase.instance.client;

  static Future<List<Wilayah>> searchDusun(String pattern) async {
    if (pattern.trim().length < 2) return [];
    final res = await _client
        .from('vw_wilayah')
        .select()
        .ilike('dusun', '%$pattern%')
        .limit(10);
    return (res as List).map((e) => Wilayah.fromJson(e)).toList();
  }
}
