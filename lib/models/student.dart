// models/student.dart
import 'package:intl/intl.dart';

class Student {
  final String id;
  final String nisn;
  final String namaLengkap;
  final String jenisKelamin;
  final String agama;
  final String ttl;
  final String telp;
  final String nik;
  final String jalan;
  final String rtRw;
  final String? dusun;
  final String? desa;
  final String? kecamatan;
  final String? kabupaten;
  final String? provinsi;
  final String? kodePos;

  // Data orang tua
  final String? namaAyah;
  final String? namaIbu;
  final String? alamatOrangTua;

  // Foreign-key (dipakai service saat insert/update)
  final String? alamatId;
  final String? orangTuaId;
  final String? waliId;

  Student({
    required this.id,
    required this.nisn,
    required this.namaLengkap,
    required this.jenisKelamin,
    required this.agama,
    required this.ttl,
    required this.telp,
    required this.nik,
    required this.jalan,
    required this.rtRw,
    this.dusun,
    this.desa,
    this.kecamatan,
    this.kabupaten,
    this.provinsi,
    this.kodePos,
    this.namaAyah,
    this.namaIbu,
    this.alamatOrangTua,
    this.alamatId,
    this.orangTuaId,
    this.waliId,
  });

  /* ---------- getter helper (tetap ada) ---------- */
  String? get tempatLahir {
    final potong = ttl.split(', ');
    return potong.length == 2 ? potong[0] : null;
  }

  DateTime? get tanggalLahir {
    final potong = ttl.split(', ');
    if (potong.length != 2) return null;
    try {
      return DateFormat('dd-MM-yyyy').parse(potong[1]); //tanggal lahir
    } catch (_) {
      return null;
    }
  }

  String? get noTelp => telp;

  /* ---------- fromJson (untuk read) ---------- */
  factory Student.fromJson(Map<String, dynamic> json) => Student(
    id: json['id'],
    nisn: json['nisn'],
    namaLengkap: json['nama_lengkap'],
    jenisKelamin: json['jenis_kelamin'],
    agama: json['agama'],
    ttl: json['ttl'],
    telp: json['telp'],
    nik: json['nik'],
    jalan: json['jalan'],
    rtRw: json['rtrw'],
    dusun: json['dusun'],
    desa: json['desa'],
    kecamatan: json['kecamatan'],
    kabupaten: json['kabupaten'],
    provinsi: json['provinsi'],
    kodePos: json['kodepos'],
    namaAyah: json['nama_ayah'],
    namaIbu: json['nama_ibu'],
    alamatOrangTua: json['alamat_ortu'],
    alamatId: json['alamat_id']?.toString(),
    orangTuaId: json['orang_tua_id']?.toString(),
    waliId: json['wali_id']?.toString(),
  );

  /* ---------- fromMap (alias) ---------- */
  factory Student.fromMap(Map<String, dynamic> map) => Student.fromJson(map);

  /* ---------- toMap (untuk insert/update) ---------- */
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nisn': nisn,
      'nama_lengkap': namaLengkap,
      'jenis_kelamin': jenisKelamin,
      'agama': agama,
      'ttl': ttl,
      'telp': telp,
      'nik': nik,
      'jalan': jalan,
      'rtrw': rtRw,
      'alamat_id': alamatId == null ? null : int.tryParse(alamatId!),
      'orang_tua_id': orangTuaId,
      'wali_id': waliId,
    };
  }
}
