import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../models/student.dart';
import '../models/wilayah_model.dart';
import '../services/wilayah_service.dart';

class FormPage extends StatefulWidget {
  final Student? student;
  const FormPage({super.key, this.student});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();
  final _uuid = const Uuid();

  /* ---------- Siswa ---------- */
  final nisnCtrl = TextEditingController();
  final namaCtrl = TextEditingController();
  final tempatCtrl = TextEditingController();
  DateTime? selectedTglLahir;
  final telpCtrl = TextEditingController();
  final nikCtrl = TextEditingController();
  final jalanCtrl = TextEditingController();
  final rtrwCtrl = TextEditingController();
  final agamaCtrl = TextEditingController();
  final alamatSiswaCtrl = TextEditingController();

  /* ---------- Orang Tua ---------- */
  final namaAyahCtrl = TextEditingController();
  final namaIbuCtrl = TextEditingController();
  final alamatOrtuCtrl = TextEditingController();
  Wilayah? _selectedWilayahOrtu;

  /* ---------- Wali ---------- */
  final namaWaliCtrl = TextEditingController();
  final alamatWaliCtrl = TextEditingController();
  Wilayah? _selectedWilayahWali;

  String? _selectedJenisKelamin;
  Wilayah? _selectedWilayahSiswa;

  String _formatAlamat(Wilayah w) {
    final parts = [
      if (w.dusun.isNotEmpty) w.dusun,
      if (w.desa.isNotEmpty) 'Desa ${w.desa}',
      if (w.kecamatan.isNotEmpty) 'Kec. ${w.kecamatan}',
      if (w.kabupaten.isNotEmpty) 'Kab. ${w.kabupaten}',
      if (w.provinsi != null && w.provinsi!.isNotEmpty) 'Prov. ${w.provinsi}',
      if (w.kodepos.isNotEmpty) w.kodepos,
    ];
    return parts.join(', ');
  }

  Future<void> _save() async {
    if (_selectedWilayahSiswa == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Pilih alamat siswa')));
      return;
    }
    if (selectedTglLahir == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Pilih tanggal lahir')));
      return;
    }
    if (!_formKey.currentState!.validate()) return;

    final siswaId = widget.student?.id ?? _uuid.v4();
    final orangTuaId = _uuid.v4();
    final waliId = _uuid.v4();

    final ttl =
        '${tempatCtrl.text.trim()}, ${DateFormat('dd-MM-yyyy').format(selectedTglLahir!)}';

    await Supabase.instance.client.from('orang_tua').upsert([
      {
        'id': orangTuaId,
        'nama_ayah': namaAyahCtrl.text.trim(),
        'nama_ibu': namaIbuCtrl.text.trim(),
        'alamat_ortu': alamatOrtuCtrl.text.trim(),
        'alamat_id': _selectedWilayahOrtu?.id,
      },
    ]);

    if (namaWaliCtrl.text.trim().isNotEmpty) {
      await Supabase.instance.client.from('wali').upsert([
        {
          'id': waliId,
          'nama_wali': namaWaliCtrl.text.trim(),
          'alamat_wali': alamatWaliCtrl.text.trim(),
          'alamat_id': _selectedWilayahWali?.id,
        },
      ]);
    }

    final siswaData = {
      'id': siswaId,
      'nisn': nisnCtrl.text.trim(),
      'nama_lengkap': namaCtrl.text.trim(),
      'jenis_kelamin': _selectedJenisKelamin,
      'agama': agamaCtrl.text.trim(),
      'ttl': ttl,
      'telp': telpCtrl.text.trim(),
      'nik': nikCtrl.text.trim(),
      'jalan': jalanCtrl.text.trim(),
      'rtrw': rtrwCtrl.text.trim(),
      'alamat_id': _selectedWilayahSiswa!.id,
      'orang_tua_id': orangTuaId,
      'wali_id': namaWaliCtrl.text.trim().isEmpty ? null : waliId,
      'provinsi': _selectedWilayahSiswa?.provinsi ?? 'Jawa Timur',
      'created_at': DateTime.now().toIso8601String(),
    };

    try {
      await Supabase.instance.client.from('siswa').insert([siswaData]);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Data berhasil disimpan')));
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal simpan: $e')));
    }
  }

  Widget _section(String title, List<Widget> children) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.badge_outlined,
                size: 20,
                color: Color(0xFF0D47A1),
              ),
              const SizedBox(width: 6),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0D47A1),
                ),
              ),
            ],
          ),
          const Divider(height: 24, thickness: 2, color: Color(0xFF0D47A1)),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }

  InputDecoration _inputDec(String label) => InputDecoration(
    labelText: label,
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color.fromARGB(255, 99, 176, 253)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color.fromARGB(255, 106, 172, 238)),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
  );

  Widget _alamatField({
    required String label,
    required TextEditingController controller,
    required void Function(Wilayah) onSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0D47A1),
          ),
        ),
        const SizedBox(height: 6),
        TypeAheadField<Wilayah>(
          textFieldConfiguration: TextFieldConfiguration(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Ketik dusun…',
              border: OutlineInputBorder(),
            ),
          ),
          suggestionsCallback: (pattern) async {
            if (pattern.trim().length < 2) return <Wilayah>[];
            return await WilayahService.searchDusun(pattern);
          },
          itemBuilder: (_, w) =>
              ListTile(title: Text(w.dusun), subtitle: Text(_formatAlamat(w))),
          onSuggestionSelected: (w) {
            controller.text = _formatAlamat(w);
            onSelected(w);
          },
          noItemsFoundBuilder: (_) =>
              const ListTile(title: Text('Dusun tidak ditemukan')),
          loadingBuilder: (_) =>
              const ListTile(title: Center(child: CircularProgressIndicator())),
          errorBuilder: (_, err) => ListTile(
            title: Text(
              'Error: $err',
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 251, 251),
      appBar: AppBar(
        toolbarHeight: 80,
        elevation: 0,
        title: Text(
          widget.student == null ? 'Tambah Siswa' : 'Edit Siswa',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
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
            ),
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            children: [
              _section('Data Siswa', [
                TextFormField(
                  controller: nisnCtrl,
                  decoration: _inputDec('NISN'),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (v) {
                    if (v == null || v.trim().isEmpty)
                      return 'NISN wajib diisi';
                    if (v.length != 10) return 'NISN harus 10 digit';
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: namaCtrl,
                  decoration: _inputDec('Nama Lengkap'),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Nama wajib diisi' : null,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _selectedJenisKelamin,
                  items: const [
                    DropdownMenuItem(
                      value: 'Laki-laki',
                      child: Text('Laki-laki'),
                    ),
                    DropdownMenuItem(
                      value: 'Perempuan',
                      child: Text('Perempuan'),
                    ),
                  ],
                  onChanged: (v) => setState(() => _selectedJenisKelamin = v),
                  decoration: _inputDec('Jenis Kelamin'),
                  validator: (v) => v == null ? 'Pilih jenis kelamin' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: agamaCtrl,
                  decoration: _inputDec('Agama'),
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'Agama wajib diisi'
                      : null,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        controller: tempatCtrl,
                        decoration: _inputDec('Tempat Lahir'),
                        validator: (v) => v == null || v.trim().isEmpty
                            ? 'Tempat lahir wajib'
                            : null,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 4,
                      child: TextFormField(
                        readOnly: true,
                        decoration: _inputDec('Tanggal Lahir').copyWith(
                          suffixIcon: const Icon(Icons.calendar_today),
                        ),
                        controller: TextEditingController(
                          text: selectedTglLahir == null
                              ? ''
                              : DateFormat(
                                  'dd-MM-yyyy',
                                ).format(selectedTglLahir!),
                        ),
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: selectedTglLahir ?? DateTime.now(),
                            firstDate: DateTime(1990),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null)
                            setState(() => selectedTglLahir = picked);
                        },
                        validator: (_) =>
                            selectedTglLahir == null ? 'Pilih tanggal' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: telpCtrl,
                  decoration: _inputDec('No. Telepon'),
                  keyboardType: TextInputType.phone,
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'No. telepon wajib'
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: nikCtrl,
                  decoration: _inputDec('NIK'),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'NIK wajib diisi';
                    if (v.length != 16) return 'NIK harus 16 digit';
                    return null;
                  },
                ),
                _alamatField(
                  label: 'Alamat Siswa',
                  controller: alamatSiswaCtrl,
                  onSelected: (w) => _selectedWilayahSiswa = w,
                ),
                TextFormField(
                  controller: jalanCtrl,
                  decoration: _inputDec('Jalan'),
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'Jalan wajib diisi'
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: rtrwCtrl,
                  decoration: _inputDec('RT/RW'),
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'RT/RW wajib diisi'
                      : null,
                ),
              ]),

              _section('Data Orang Tua', [
                TextFormField(
                  controller: namaAyahCtrl,
                  decoration: _inputDec('Nama Ayah'),
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'Nama ayah wajib diisi'
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: namaIbuCtrl,
                  decoration: _inputDec('Nama Ibu'),
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'Nama ibu wajib diisi'
                      : null,
                ),
                _alamatField(
                  label: 'Alamat Orang Tua',
                  controller: alamatOrtuCtrl,
                  onSelected: (w) => _selectedWilayahOrtu = w,
                ),
              ]),

              _section('Data Wali (Opsional)', [
                TextFormField(
                  controller: namaWaliCtrl,
                  decoration: _inputDec('Nama Wali'),
                ),
                _alamatField(
                  label: 'Alamat Wali',
                  controller: alamatWaliCtrl,
                  onSelected: (w) => _selectedWilayahWali = w,
                ),
              ]),

              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.save, color: Colors.white),
                      label: const Text(
                        'Simpan',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: const Color.fromARGB(
                          255,
                          61,
                          148,
                          234,
                        ),
                      ),
                      onPressed: _save,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.cancel, color: Color(0xFF1976D2)),
                      label: const Text(
                        'Batal',
                        style: TextStyle(color: Color(0xFF1976D2)),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
