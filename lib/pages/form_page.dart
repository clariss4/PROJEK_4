import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import '../models/student.dart';
import '../models/wilayah_model.dart';
import '../services/student_service.dart';
import '../services/wilayah_service.dart';

class FormPage extends StatefulWidget {
  final Student? student; // null = tambah baru
  const FormPage({super.key, this.student});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();
  final StudentService _service = StudentService();

  /* ---------- controller ---------- */
  final nisnCtrl = TextEditingController();
  final namaCtrl = TextEditingController();
  final jkCtrl = TextEditingController();
  final agamaCtrl = TextEditingController();
  final tempatCtrl = TextEditingController();
  final tglCtrl = TextEditingController();
  final hpCtrl = TextEditingController();
  final nikCtrl = TextEditingController();
  final jalanCtrl = TextEditingController();
  final rtRwCtrl = TextEditingController();
  final dusunCtrl = TextEditingController();
  final alamatCtrl = TextEditingController();
  final ayahCtrl = TextEditingController();
  final ibuCtrl = TextEditingController();
  final waliCtrl = TextEditingController();
  final alamatOrtuCtrl = TextEditingController();

  Wilayah? _selectedWilayah;
  bool _alamatOrtuSama = false;

  @override
  void initState() {
    super.initState();
    final s = widget.student;
    nisnCtrl.text = s?.nisn ?? '';
    namaCtrl.text = s?.namaLengkap ?? '';
    jkCtrl.text = s?.jenisKelamin ?? '';
    agamaCtrl.text = s?.agama ?? '';
    tempatCtrl.text = s?.tempatLahir ?? '';
    tglCtrl.text = s == null
        ? ''
        : s.tanggalLahir.toIso8601String().split('T')[0];
    hpCtrl.text = s?.noTelp ?? '';
    nikCtrl.text = s?.nik ?? '';
    jalanCtrl.text = s?.jalan ?? '';
    rtRwCtrl.text = s?.rtRw ?? '';
    dusunCtrl.text = s?.dusun ?? '';
    alamatCtrl.text = s?.alamatLengkap ?? '';
    ayahCtrl.text = s?.namaAyah ?? '';
    ibuCtrl.text = s?.namaIbu ?? '';
    waliCtrl.text = s?.namaWali ?? '';
    alamatOrtuCtrl.text = s?.alamatOrangTua ?? '';
    _alamatOrtuSama = false;
  }

  @override
  void dispose() {
    nisnCtrl.dispose();
    namaCtrl.dispose();
    jkCtrl.dispose();
    agamaCtrl.dispose();
    tempatCtrl.dispose();
    tglCtrl.dispose();
    hpCtrl.dispose();
    nikCtrl.dispose();
    jalanCtrl.dispose();
    rtRwCtrl.dispose();
    dusunCtrl.dispose();
    alamatCtrl.dispose();
    ayahCtrl.dispose();
    ibuCtrl.dispose();
    waliCtrl.dispose();
    alamatOrtuCtrl.dispose();
    super.dispose();
  }

  void _simpan() async {
    /* ---------- debug ---------- */
    debugPrint('1. validasi: ${_formKey.currentState!.validate()}');
    debugPrint('2. selectedWilayah: $_selectedWilayah');
    debugPrint('3. alamatCtrl: ${alamatCtrl.text}');

    if (!_formKey.currentState!.validate()) return;
    if (_selectedWilayah == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih dusun terlebih dahulu')),
      );
      return;
    }

    DateTime? tglLahir;
    try {
      tglLahir = DateTime.parse(tglCtrl.text);
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Format tanggal harus yyyy-MM-dd')),
      );
      return;
    }

    final student = Student(
      id: widget.student?.id,
      nisn: nisnCtrl.text,
      namaLengkap: namaCtrl.text,
      jenisKelamin: jkCtrl.text,
      agama: agamaCtrl.text,
      tempatLahir: tempatCtrl.text,
      tanggalLahir: tglLahir,
      noTelp: hpCtrl.text,
      nik: nikCtrl.text,
      jalan: jalanCtrl.text,
      rtRw: rtRwCtrl.text,
      dusun: _selectedWilayah!.dusun,
      desa: _selectedWilayah!.desa,
      kecamatan: _selectedWilayah!.kecamatan,
      kabupaten: _selectedWilayah!.kabupaten,
      provinsi: 'Jawa Timur',
      kodePos: _selectedWilayah!.kodePos,
      namaAyah: ayahCtrl.text,
      namaIbu: ibuCtrl.text,
      alamatOrangTua: alamatOrtuCtrl.text,
      namaWali: waliCtrl.text,
      alamatLengkap: alamatCtrl.text,
    );

    try {
      final berhasil = widget.student == null
          ? await _service.insertStudent(student)
          : await _service.updateStudent(student);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(berhasil ? 'Tersimpan' : 'Gagal menyimpan')),
      );
      if (berhasil) Navigator.pop(context, student);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error saat simpan: $e')));
    }
  }

  Widget _textField(
    String label,
    TextEditingController c, {
    bool required = true,
  }) {
    return TextFormField(
      controller: c,
      decoration: InputDecoration(labelText: label),
      validator: required
          ? (v) => v!.isEmpty ? '$label wajib diisi' : null
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.student == null ? 'Tambah Siswa' : 'Edit Siswa'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _textField('NISN', nisnCtrl),
              _textField('Nama Lengkap', namaCtrl),
              _textField('Jenis Kelamin', jkCtrl),
              _textField('Agama', agamaCtrl),
              _textField('Tempat Lahir', tempatCtrl),
              _textField('Tanggal Lahir (yyyy-MM-dd)', tglCtrl),
              _textField('No HP', hpCtrl, required: false),
              _textField('NIK', nikCtrl, required: false),
              _textField('Jalan', jalanCtrl),
              _textField('RT/RW', rtRwCtrl),

              /* ---------- AUTOCOMPLETE ALAMAT (v5.x) ---------- */
              TypeAheadField<Wilayah>(
                controller: alamatCtrl,
                builder: (context, controller, focusNode) {
                  return TextFormField(
                    controller: controller,
                    focusNode: focusNode,
                    decoration: const InputDecoration(
                      labelText: 'Alamat Lengkap *',
                      hintText: 'Ketik nama dusun...',
                    ),
                    validator: (_) =>
                        _selectedWilayah == null ? 'Pilih dusun' : null,
                  );
                },
                suggestionsCallback: (pattern) async {
                  if (pattern.length < 2) return [];
                  return await WilayahService.searchDusun(pattern);
                },
                itemBuilder: (_, Wilayah w) => ListTile(
                  title: Text(w.dusun),
                  subtitle: Text(
                    '${w.desa}, Kec. ${w.kecamatan}, Kab. ${w.kabupaten}, ${w.kodePos}',
                  ),
                ),
                onSelected: (w) {
                  setState(() => _selectedWilayah = w);
                  alamatCtrl.text =
                      '${w.dusun}, Desa ${w.desa}, Kec. ${w.kecamatan}, Kab. ${w.kabupaten}, Jawa Timur ${w.kodePos}';
                },
                debounceDuration: const Duration(milliseconds: 400),
                emptyBuilder: (_) =>
                    const ListTile(title: Text('Dusun tidak ditemukan')),
                loadingBuilder: (_) =>
                    const ListTile(title: CircularProgressIndicator()),
                errorBuilder: (_, e) => ListTile(
                  title: Text(
                    e.toString().contains('internet')
                        ? 'Tidak ada koneksi internet'
                        : 'Gagal terhubung ke database',
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ),

              /* ---------- ORANG TUA ---------- */
              const SizedBox(height: 16),
              const Text(
                'Data Orang Tua',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              _textField('Nama Ayah', ayahCtrl),
              _textField('Nama Ibu', ibuCtrl),
              _textField('Nama Wali (opsional)', waliCtrl, required: false),

              Row(
                children: [
                  const Text('Alamat ortu sama dengan siswa'),
                  const Spacer(),
                  Switch(
                    value: _alamatOrtuSama,
                    onChanged: (val) {
                      setState(() => _alamatOrtuSama = val);
                      if (val) alamatOrtuCtrl.text = alamatCtrl.text;
                    },
                  ),
                ],
              ),
              TextFormField(
                controller: alamatOrtuCtrl,
                readOnly: _alamatOrtuSama,
                decoration: const InputDecoration(
                  labelText: 'Alamat Orang Tua',
                  hintText: 'Isi manual atau samakan',
                ),
                validator: (v) => v!.isEmpty ? 'Alamat ortu wajib diisi' : null,
              ),

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _simpan,
                  child: const Text('SIMPAN'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
