import 'package:flutter/material.dart';
import '../models/student.dart';

class DetailPage extends StatelessWidget {
  final Student student;

  const DetailPage({super.key, required this.student});

  Widget _buildDetail(String label, String value, {IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null)
            Padding(
              padding: const EdgeInsets.only(right: 8.0, top: 2),
              child: Icon(icon, size: 20, color: Colors.blueAccent),
            ),
          Expanded(
            child: RichText(
              text: TextSpan(
                text: "$label: ",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 16,
                ),
                children: [
                  TextSpan(
                    text: value,
                    style: const TextStyle(fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 8),
            ...children,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Siswa'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFB3E5FC), Color(0xFFE1F5FE)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListView(
            children: [
              _buildSection('Data Diri', [
                _buildDetail('NISN', student.nisn, icon: Icons.badge),
                _buildDetail(
                  'Nama Lengkap',
                  student.namaLengkap,
                  icon: Icons.person,
                ),
                _buildDetail(
                  'Jenis Kelamin',
                  student.jenisKelamin,
                  icon: Icons.wc,
                ),
                _buildDetail(
                  'Agama',
                  student.agama,
                  icon: Icons.account_balance,
                ),
                _buildDetail(
                  'TTL',
                  student.tempatTanggalLahir,
                  icon: Icons.calendar_today,
                ),
                _buildDetail('No. Telepon', student.noTlp, icon: Icons.phone),
                _buildDetail('NIK', student.nik, icon: Icons.credit_card),
              ]),
              _buildSection('Alamat', [
                _buildDetail('Jalan', student.jalan, icon: Icons.map),
                _buildDetail('RT/RW', student.rtRw, icon: Icons.home),
                _buildDetail('Dusun', student.dusun, icon: Icons.location_city),
                _buildDetail('Desa', student.desa, icon: Icons.location_on),
                _buildDetail(
                  'Kecamatan',
                  student.kecamatan,
                  icon: Icons.maps_home_work,
                ),
                _buildDetail(
                  'Kabupaten',
                  student.kabupaten,
                  icon: Icons.apartment,
                ),
                _buildDetail('Provinsi', student.provinsi, icon: Icons.flag),
                _buildDetail(
                  'Kode Pos',
                  student.kodePos,
                  icon: Icons.markunread_mailbox,
                ),
              ]),
              _buildSection('Orang Tua / Wali', [
                _buildDetail('Nama Ayah', student.namaAyah, icon: Icons.man),
                _buildDetail('Nama Ibu', student.namaIbu, icon: Icons.woman),
                _buildDetail('Nama Wali', student.namaWali, icon: Icons.group),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
