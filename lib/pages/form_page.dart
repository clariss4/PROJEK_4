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
  final alamatSiswaCtrl = TextEditingController(); // 1 kolom saja

  /* ---------- Orang Tua ---------- */
  final namaAyahCtrl = TextEditingController();
  final namaIbuCtrl = TextEditingController();
  final alamatOrtuCtrl = TextEditingController(); // 1 kolom saja
  Wilayah? _selectedWilayahOrtu;

  /* ---------- Wali ---------- */
  final namaWaliCtrl = TextEditingController();
  final alamatWaliCtrl = TextEditingController(); // 1 kolom saja
  Wilayah? _selectedWilayahWali;

  String? _selectedJenisKelamin;
  Wilayah? _selectedWilayahSiswa;

  /* ---------- Helper ---------- */
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

    /* 1. Insert Orang Tua */
    await Supabase.instance.client.from('orang_tua').upsert([
      {
        'id': orangTuaId,
        'nama_ayah': namaAyahCtrl.text.trim(),
        'nama_ibu': namaIbuCtrl.text.trim(),
        'alamat_ortu': alamatOrtuCtrl.text.trim(),
        'alamat_id': _selectedWilayahOrtu?.id,
      },
    ]);

    /* 2. Insert Wali (opsional) */
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

    /* 3. Siapkan data siswa */
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
      'alamat_id': _selectedWilayahSiswa!.id, // <- pastikan int
      'orang_tua_id': orangTuaId,
      'wali_id': namaWaliCtrl.text.trim().isEmpty ? null : waliId,
      'provinsi':
          _selectedWilayahSiswa?.provinsi ?? 'Jawa Timur', // <-- jangan null
      'created_at': DateTime.now().toIso8601String(),
    };

    print('🔥 SISWA DATA: $siswaData'); // <-- SALIN INI KE DEBUG CONSOLE

    /* 4. Insert Siswa */
    try {
      await Supabase.instance.client.from('siswa').insert([siswaData]);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Data berhasil disimpan')));
      Navigator.pop(context, true);
    } catch (e) {
      print('❌ SIMPAN ERROR: $e'); // <-- SALIN INI KE DEBUG CONSOLE
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal simpan: $e')));
    }
  }

  /* ---------- Widget 1 Kolom Alamat + Auto-complete ---------- */
  Widget _alamatField({
    required String label,
    required TextEditingController controller,
    required void Function(Wilayah) onSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        TypeAheadField<Wilayah>(
          textFieldConfiguration: TextFieldConfiguration(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Ketik dusun...',
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
        const SizedBox(height: 16),
      ],
    );
  }

  /* ---------- Build Form ---------- */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.student == null ? 'Tambah Siswa' : 'Edit Siswa'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /* ---------- Siswa ---------- */
                const Text(
                  'Data Siswa',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: nisnCtrl,
                  decoration: const InputDecoration(
                    labelText: 'NISN *',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (v) {
                    if (v == null || v.trim().isEmpty)
                      return 'NISN wajib diisi';
                    if (v.length != 10) return 'NISN harus 10 digit';
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: namaCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Nama Lengkap *',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Nama wajib diisi' : null,
                ),
                const SizedBox(height: 8),
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
                  decoration: const InputDecoration(
                    labelText: 'Jenis Kelamin *',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v == null ? 'Pilih jenis kelamin' : null,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: agamaCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Agama *',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'Agama wajib diisi'
                      : null,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        controller: tempatCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Tempat Lahir *',
                          border: OutlineInputBorder(),
                        ),
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
                        decoration: const InputDecoration(
                          labelText: 'Tanggal Lahir *',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.calendar_today),
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
                const SizedBox(height: 8),
                TextFormField(
                  controller: telpCtrl,
                  decoration: const InputDecoration(
                    labelText: 'No. Telepon *',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'No. telepon wajib'
                      : null,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: nikCtrl,
                  decoration: const InputDecoration(
                    labelText: 'NIK *',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'NIK wajib diisi';
                    if (v.length != 16) return 'NIK harus 16 digit';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _alamatField(
                  label: 'Alamat Siswa',
                  controller: alamatSiswaCtrl,
                  onSelected: (w) => _selectedWilayahSiswa = w,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: jalanCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Jalan *',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'Jalan wajib diisi'
                      : null,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: rtrwCtrl,
                  decoration: const InputDecoration(
                    labelText: 'RT/RW *',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'RT/RW wajib diisi'
                      : null,
                ),

                /* ---------- Orang Tua ---------- */
                const SizedBox(height: 16),
                const Text(
                  'Data Orang Tua',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: namaAyahCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Nama Ayah *',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'Nama ayah wajib diisi'
                      : null,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: namaIbuCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Nama Ibu *',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'Nama ibu wajib diisi'
                      : null,
                ),
                _alamatField(
                  label: 'Alamat Orang Tua',
                  controller: alamatOrtuCtrl,
                  onSelected: (w) => _selectedWilayahOrtu = w,
                ),

                /* ---------- Wali ---------- */
                const SizedBox(height: 16),
                const Text(
                  'Data Wali (Opsional)',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: namaWaliCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Nama Wali',
                    border: OutlineInputBorder(),
                  ),
                ),
                _alamatField(
                  label: 'Alamat Wali',
                  controller: alamatWaliCtrl,
                  onSelected: (w) => _selectedWilayahWali = w,
                ),

                const SizedBox(height: 20),

                /* ---------- Tombol ---------- */
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.save),
                        label: const Text('Simpan'),
                        onPressed: _save,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.cancel),
                        label: const Text('Batal'),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
