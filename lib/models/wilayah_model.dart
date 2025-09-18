class Wilayah {
  final String dusunId; // String (sudah ::text di view)
  final String dusun, desa, kecamatan, kabupaten, kodePos;

  Wilayah.fromJson(Map<String, dynamic> json)
    : dusunId = json['dusun_id'].toString(),
      dusun = json['dusun'],
      desa = json['desa'],
      kecamatan = json['kecamatan'],
      kabupaten = json['kabupaten'],
      kodePos = json['kode_pos'];
}
