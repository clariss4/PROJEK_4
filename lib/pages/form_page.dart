import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/student.dart';

class FormPage extends StatefulWidget {
  final Student? student;
  final int? index;

  const FormPage({super.key, this.student, this.index});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();
  final uuid = const Uuid();

  final Map<String, TextEditingController> controllers = {
    'nisn': TextEditingController(),
    'namaLengkap': TextEditingController(),
    'jenisKelamin': TextEditingController(),
    'agama': TextEditingController(),
    'tempatTanggalLahir': TextEditingController(),
    'noTlp': TextEditingController(),
    'nik': TextEditingController(),
    'jalan': TextEditingController(),
    'rtRw': TextEditingController(),
    'dusun': TextEditingController(),
    'desa': TextEditingController(),
    'kecamatan': TextEditingController(),
    'kabupaten': TextEditingController(),
    'provinsi': TextEditingController(),
    'kodePos': TextEditingController(),
    'namaAyah': TextEditingController(),
    'namaIbu': TextEditingController(),
    'namaWali': TextEditingController(),
  };

  @override
  void initState() {
    super.initState();
    if (widget.student != null) {
      controllers.forEach((key, controller) {
        controller.text = widget.student!.toJson()[key] ?? '';
      });
    }
  }

  @override
  void dispose() {
    controllers.forEach((key, controller) => controller.dispose());
    super.dispose();
  }

  void _saveData() {
    if (_formKey.currentState!.validate()) {
      final newStudent = Student(
        id: widget.student?.id ?? uuid.v4(),
        nisn: controllers['nisn']!.text,
        namaLengkap: controllers['namaLengkap']!.text,
        jenisKelamin: controllers['jenisKelamin']!.text,
        agama: controllers['agama']!.text,
        tempatTanggalLahir: controllers['tempatTanggalLahir']!.text,
        noTlp: controllers['noTlp']!.text,
        nik: controllers['nik']!.text,
        jalan: controllers['jalan']!.text,
        rtRw: controllers['rtRw']!.text,
        dusun: controllers['dusun']!.text,
        desa: controllers['desa']!.text,
        kecamatan: controllers['kecamatan']!.text,
        kabupaten: controllers['kabupaten']!.text,
        provinsi: controllers['provinsi']!.text,
        kodePos: controllers['kodePos']!.text,
        namaAyah: controllers['namaAyah']!.text,
        namaIbu: controllers['namaIbu']!.text,
        namaWali: controllers['namaWali']!.text,
      );

      Navigator.pop(context, newStudent);
    }
  }

  Widget _buildTextField(String key, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextFormField(
        controller: controllers[key],
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) =>
            value == null || value.isEmpty ? 'Wajib diisi' : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.student == null ? 'Tambah Data' : 'Edit Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField('nisn', 'NISN'),
              _buildTextField('namaLengkap', 'Nama Lengkap'),
              _buildTextField('jenisKelamin', 'Jenis Kelamin'),
              _buildTextField('agama', 'Agama'),
              _buildTextField('tempatTanggalLahir', 'Tempat, Tanggal Lahir'),
              _buildTextField('noTlp', 'No. Telepon / HP'),
              _buildTextField('nik', 'NIK'),

              const Divider(),
              const Text(
                'Alamat',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              _buildTextField('jalan', 'Jalan'),
              _buildTextField('rtRw', 'RT/RW'),
              _buildTextField('dusun', 'Dusun'),
              _buildTextField('desa', 'Desa'),
              _buildTextField('kecamatan', 'Kecamatan'),
              _buildTextField('kabupaten', 'Kabupaten'),
              _buildTextField('provinsi', 'Provinsi'),
              _buildTextField('kodePos', 'Kode Pos'),

              const Divider(),
              const Text(
                'Orang Tua / Wali',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              _buildTextField('namaAyah', 'Nama Ayah'),
              _buildTextField('namaIbu', 'Nama Ibu'),
              _buildTextField('namaWali', 'Nama Wali'),

              const SizedBox(height: 20),
              ElevatedButton(onPressed: _saveData, child: const Text('Simpan')),
            ],
          ),
        ),
      ),
    );
  }
}
