class Wilayah {
  final String id;
  final String dusun;
  final String desa;
  final String kecamatan;
  final String kabupaten;
  final String? provinsi;
  final String kodepos;

  Wilayah({
    required this.id,
    required this.dusun,
    required this.desa,
    required this.kecamatan,
    required this.kabupaten,
    this.provinsi,
    required this.kodepos,
  });

  factory Wilayah.fromJson(Map<String, dynamic> json) => Wilayah(
    id: json['id'].toString(),
    dusun: json['dusun'] ?? '',
    desa: json['desa'] ?? '',
    kecamatan: json['kecamatan'] ?? '',
    kabupaten: json['kabupaten'] ?? '',
    provinsi: json['provinsi'],
    kodepos: json['kodepos']?.toString() ?? '',
  );
}
