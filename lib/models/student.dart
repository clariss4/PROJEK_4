// lib/models/student.dart
class Student {
  final String id;
  final String nisn;
  final String namaLengkap;
  final String jenisKelamin;
  final String agama;
  final String tempatTanggalLahir;
  final String noTlp;
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
  final String namaWali;
  final String alamat;

  final String? alamatSiswaId;
  final String? alamatOrtuId;

  Student({
    required this.id,
    required this.nisn,
    required this.namaLengkap,
    required this.jenisKelamin,
    required this.agama,
    required this.tempatTanggalLahir,
    required this.noTlp,
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
    required this.namaWali,
    required this.alamat,

    this.alamatOrtuId,
    this.alamatSiswaId,
  });

  /// Ubah object Student menjadi Map<String, dynamic>
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nisn': nisn,
      'namaLengkap': namaLengkap,
      'jenisKelamin': jenisKelamin,
      'agama': agama,
      'tempatTanggalLahir': tempatTanggalLahir,
      'noTlp': noTlp,
      'nik': nik,
      'jalan': jalan,
      'rtRw': rtRw,
      'dusun': dusun,
      'desa': desa,
      'kecamatan': kecamatan,
      'kabupaten': kabupaten,
      'provinsi': provinsi,
      'kodePos': kodePos,
      'namaAyah': namaAyah,
      'namaIbu': namaIbu,
      'namaWali': namaWali,
      'alamat': alamat,
      'alamat_siswa_id': alamatSiswaId,
      'alamat_ortu_id': alamatOrtuId,
    };
  }

  /// Buat object Student dari Map<String, dynamic>
  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] ?? '',
      nisn: json['nisn'] ?? '',
      namaLengkap: json['namaLengkap'] ?? '',
      jenisKelamin: json['jenisKelamin'] ?? '',
      agama: json['agama'] ?? '',
      tempatTanggalLahir: json['tempatTanggalLahir'] ?? '',
      noTlp: json['noTlp'] ?? '',
      nik: json['nik'] ?? '',
      jalan: json['jalan'] ?? '',
      rtRw: json['rtRw'] ?? '',
      dusun: json['dusun'] ?? '',
      desa: json['desa'] ?? '',
      kecamatan: json['kecamatan'] ?? '',
      kabupaten: json['kabupaten'] ?? '',
      provinsi: json['provinsi'] ?? '',
      kodePos: json['kodePos'] ?? '',
      namaAyah: json['namaAyah'] ?? '',
      namaIbu: json['namaIbu'] ?? '',
      namaWali: json['namaWali'] ?? '',
      alamat: json['alamat'] ?? '',
      alamatOrtuId: json['alamat_ortu_id'],
      alamatSiswaId: json['alamat_siswa_id'],
    );
  }
}
