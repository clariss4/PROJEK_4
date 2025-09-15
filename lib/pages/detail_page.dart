import 'package:flutter/material.dart';
import '../models/student.dart';

class DetailPage extends StatelessWidget {
  final Student student;

  const DetailPage({super.key, required this.student});

  Widget _buildDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Siswa')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            _buildDetail('NISN', student.nisn),
            _buildDetail('Nama Lengkap', student.namaLengkap),
            _buildDetail('Jenis Kelamin', student.jenisKelamin),
            _buildDetail('Agama', student.agama),
            _buildDetail('TTL', student.tempatTanggalLahir),
            _buildDetail('No. Telepon', student.noTlp),
            _buildDetail('NIK', student.nik),

            const Divider(),
            const Text('Alamat', style: TextStyle(fontWeight: FontWeight.bold)),
            _buildDetail('Jalan', student.jalan),
            _buildDetail('RT/RW', student.rtRw),
            _buildDetail('Dusun', student.dusun),
            _buildDetail('Desa', student.desa),
            _buildDetail('Kecamatan', student.kecamatan),
            _buildDetail('Kabupaten', student.kabupaten),
            _buildDetail('Provinsi', student.provinsi),
            _buildDetail('Kode Pos', student.kodePos),

            const Divider(),
            const Text(
              'Orang Tua/Wali',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            _buildDetail('Nama Ayah', student.namaAyah),
            _buildDetail('Nama Ibu', student.namaIbu),
            _buildDetail('Nama Wali', student.namaWali),
          ],
        ),
      ),
    );
  }
}
