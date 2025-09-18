import 'package:intl/intl.dart';

class Student {
  String? id;
  final String nisn;
  final String namaLengkap;
  final String jenisKelamin;
  final String agama;
  final String tempatLahir;
  final DateTime tanggalLahir;
  final String noTelp;
  final String nik;
  final String jalan;
  final String rtRw;
  final String dusun;
  final String desa;
  final String kecamatan;
  final String kabupaten;
  final String provinsi;
  final String kodePos;
  final String namaAyah;
  final String namaIbu;
  final String alamatOrangTua;
  final String namaWali;
  final String alamatLengkap;

  Student({
    this.id,
    required this.nisn,
    required this.namaLengkap,
    required this.jenisKelamin,
    required this.agama,
    required this.tempatLahir,
    required this.tanggalLahir,
    required this.noTelp,
    required this.nik,
    required this.jalan,
    required this.rtRw,
    required this.dusun,
    required this.desa,
    required this.kecamatan,
    required this.kabupaten,
    required this.provinsi,
    required this.kodePos,
    required this.namaAyah,
    required this.namaIbu,
    required this.alamatOrangTua,
    required this.namaWali,
    required this.alamatLengkap,
  });

  Map<String, dynamic> toMap() {
    return {
      'nisn': nisn,
      'nama_lengkap': namaLengkap,
      'jenis_kelamin': jenisKelamin,
      'agama': agama,
      'tempat': tempatLahir,
      'tanggal_lahir': DateFormat('yyyy-MM-dd').format(tanggalLahir),
      'no_hp': noTelp,
      'nik': nik,
      'alamat_jalan': jalan,
      'rt_rw': rtRw,
      'dusun': dusun,
      'desa': '',
      'kecamatan': '',
      'kabupaten': '',
      'provinsi': '',
      'kode_pos': '',
      'nama_ayah': namaAyah,
      'nama_ibu': namaIbu,
      'alamat_orang_tua': alamatOrangTua,
      'nama_wali': '',
      'alamat_lengkap': '',
    };
  }

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id']?.toString(),
      nisn: map['nisn'],
      namaLengkap: map['nama_lengkap'],
      jenisKelamin: map['jenis_kelamin'],
      agama: map['agama'],
      tempatLahir: map['tempat'],
      tanggalLahir: DateTime.parse(map['tanggal_lahir']),
      noTelp: map['no_hp'] ?? '',
      nik: map['nik'] ?? '',
      jalan: map['alamat_jalan'] ?? '',
      rtRw: map['rt_rw'] ?? '',
      dusun: map['dusun'] ?? '',
      desa: map['desa'] ?? '',
      kecamatan: map['kecamatan'] ?? '',
      kabupaten: map['kabupaten'] ?? '',
      provinsi: map['provinsi'] ?? '',
      kodePos: map['kode_pos'] ?? '',
      namaAyah: map['nama_ayah'] ?? '',
      namaIbu: map['nama_ibu'] ?? '',
      alamatOrangTua: map['alamat_orang_tua'] ?? '',
      namaWali: map['nama_wali'] ?? '',
      alamatLengkap: map['alamat_lengkap'] ?? '',
    );
  }
}
