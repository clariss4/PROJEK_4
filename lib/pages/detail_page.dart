import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/student.dart';
import 'form_page.dart';

class DetailPage extends StatelessWidget {
  final Student student;
  const DetailPage({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        toolbarHeight: 80,
        elevation: 0,
        title: const Text(
          'Detail Siswa',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        foregroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 82, 156, 230),
                Color.fromARGB(255, 74, 167, 243),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 70,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 64,
                  backgroundColor: Colors.blue.shade100,
                  child: const Icon(Icons.person, size: 70, color: Colors.blue),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                student.namaLengkap,
                style: const TextStyle(
                  fontSize: 26,
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
            const Divider(height: 40, thickness: 2, color: Color(0xFF1976D2)),

            /* ---------- Data Pribadi ---------- */
            _section('Data Pribadi'),
            _row('NISN', student.nisn),
            _row('Jenis Kelamin', student.jenisKelamin),
            _row('Agama', student.agama),
            _row(
              'Tempat / Tgl Lahir',
              '${student.tempatLahir ?? '-'}, ${student.tanggalLahir != null ? DateFormat('dd-MM-yyyy').format(student.tanggalLahir!) : '-'}',
            ),
            _row('NIK', student.nik),
            _row('No HP', student.noTelp),

            /* ---------- Alamat Lengkap ---------- */
            _section('Alamat'),
            _row('Jalan', student.jalan),
            _row('RT/RW', student.rtRw),
            _row('Dusun', student.dusun),
            _row('Desa', student.desa),
            _row('Kecamatan', student.kecamatan),
            _row('Kabupaten', student.kabupaten),
            _row('Provinsi', student.provinsi),
            _row('Kode Pos', student.kodePos),

            /* ---------- Orang Tua ---------- */
            _section('Data Orang Tua'),
            _row('Nama Ayah', student.namaAyah),
            _row('Nama Ibu', student.namaIbu),
            _row('Alamat Ortu', student.alamatOrangTua),

            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.edit),
                label: const Text('Edit Data'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: const Color(0xFF1976D2),
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  final updated = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FormPage(student: student),
                    ),
                  );
                  if (updated != null) Navigator.pop(context, updated);
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
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF0D47A1),
        ),
      ),
    );
  }

  Widget _row(String label, String? value) {
    final displayValue = value ?? '-';
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 120,
              child: Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(displayValue.isEmpty ? '-' : displayValue)),
          ],
        ),
      ),
    );
  }
}
