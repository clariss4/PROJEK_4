import 'package:flutter/material.dart';
import '../models/student.dart';
import '../pages/form_page.dart';

class DetailPage extends StatelessWidget {
  final Student student;
  const DetailPage({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Siswa'), elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Foto dummy (boleh dihapus jika tidak pakai)
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.blue.shade100,
                child: const Icon(Icons.person, size: 60, color: Colors.blue),
              ),
            ),
            const SizedBox(height: 20),

            // Judul
            Center(
              child: Text(
                student.namaLengkap,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Center(
              child: Text(
                student.nisn,
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            const Divider(height: 40, thickness: 1),

            // Data Pribadi
            _section('Data Pribadi'),
            _row('NISN', student.nisn),
            _row('Jenis Kelamin', student.jenisKelamin),
            _row('Agama', student.agama),
            _row(
              'Tempat / Tgl Lahir',
              '${student.tempatLahir}, ${student.tanggalLahir.toLocal().toString().split(' ')[0]}',
            ),
            _row('NIK', student.nik),
            _row('No HP', student.noTelp),

            const SizedBox(height: 16),

            // Alamat
            _section('Alamat'),
            _row('Jalan', student.jalan),
            _row('RT/RW', student.rtRw),
            _row('Dusun', student.dusun),
            _row('Desa', student.desa),
            _row('Kecamatan', student.kecamatan),
            _row('Kabupaten', student.kabupaten),
            _row('Provinsi', student.provinsi),
            _row('Kode Pos', student.kodePos),

            const SizedBox(height: 16),

            // Orang Tua
            _section('Data Orang Tua'),
            _row('Nama Ayah', student.namaAyah),
            _row('Nama Ibu', student.namaIbu),
            _row('Alamat Ortu', student.alamatOrangTua),

            const SizedBox(height: 24),

            // Tombol Edit (opsional)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.edit),
                label: const Text('Edit Data'),
                onPressed: () async {
                  // Buka form edit & terima hasil
                  final updated = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FormPage(student: student),
                    ),
                  );
                  if (updated != null) {
                    // Kembali ke halaman sebelumnya & kirim data baru
                    Navigator.pop(context, updated);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _section(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 120,
              child: Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(value.isEmpty ? '-' : value)),
          ],
        ),
      ),
    );
  }
}
