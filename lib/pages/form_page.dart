import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/student.dart';

class FormPage extends StatefulWidget {
  final Student? student;
  const FormPage({super.key, this.student});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();
  final uuid = const Uuid();
  final Map<String, TextEditingController> controllers = {
    'nisn': TextEditingController(),
    'namaLengkap': TextEditingController(),
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
    'alamat': TextEditingController(),
  };

  String? _selectedGender;
  String? _selectedAlamatSiswaId;
  String? _selectedAlamatOrtuId;
  List<Map<String, dynamic>> _alamatList = [];

  @override
  void initState() {
    super.initState();
    if (widget.student != null) {
      controllers.forEach((key, controller) {
        controller.text = widget.student!.toJson()[key] ?? '';
      });
      _selectedGender = widget.student!.jenisKelamin;
      _selectedAlamatSiswaId = widget.student!.alamatSiswaId;
      _selectedAlamatOrtuId = widget.student!.alamatOrtuId;
    }
    _loadAlamat();
  }

  @override
  void dispose() {
    controllers.forEach((key, controller) => controller.dispose());
    super.dispose();
  }

  Future<void> _loadAlamat() async {
    try {
      final data = await Supabase.instance.client
          .from('alamat')
          .select()
          .order('dusun');
      setState(() {
        _alamatList = List<Map<String, dynamic>>.from(data);
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal load alamat: $e')));
    }
  }

  Future<void> _saveData() async {
    if (!_formKey.currentState!.validate()) return;

    final Map<String, dynamic> newData = {
      'id': widget.student?.id ?? uuid.v4(),
      'nisn': controllers['nisn']!.text,
      'namaLengkap': controllers['namaLengkap']!.text,
      'jenisKelamin': _selectedGender,
      'agama': controllers['agama']!.text,
      'tempatTanggalLahir': controllers['tempatTanggalLahir']!.text,
      'noTlp': controllers['noTlp']!.text,
      'nik': controllers['nik']!.text,
      'jalan': controllers['jalan']!.text,
      'rtRw': controllers['rtRw']!.text,
      'dusun': controllers['dusun']!.text,
      'desa': controllers['desa']!.text,
      'kecamatan': controllers['kecamatan']!.text,
      'kabupaten': controllers['kabupaten']!.text,
      'provinsi': controllers['provinsi']!.text,
      'kodePos': controllers['kodePos']!.text,
      'alamat_siswa_id': _selectedAlamatSiswaId,
      'alamat_ortu_id': _selectedAlamatOrtuId,
      'namaAyah': controllers['namaAyah']!.text,
      'namaIbu': controllers['namaIbu']!.text,
      'namaWali': controllers['namaWali']!.text,
      'alamat': controllers['alamat']!.text,
      'created_at': DateTime.now().toIso8601String(),
    };

    try {
      await Supabase.instance.client.from('student').upsert([newData]);
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

  Widget _buildTextField(
    String key,
    String label,
    IconData icon, {
    bool isNumber = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        controller: controllers[key],
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        inputFormatters: isNumber
            ? [FilteringTextInputFormatter.digitsOnly]
            : [],
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.blueAccent),
          filled: true,
          fillColor: Colors.blue.shade50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        validator: (value) =>
            value == null || value.isEmpty ? 'Wajib diisi' : null,
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blueAccent,
        ),
      ),
    );
  }

  Widget _buildAutocompleteField({
    required String label,
    required TextEditingController controller,
    required List<Map<String, dynamic>> items,
    required ValueChanged<Map<String, dynamic>> onSelected,
    IconData? icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Autocomplete<Map<String, dynamic>>(
        displayStringForOption: (option) => option['dusun'] ?? '',
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text.isEmpty) {
            return const Iterable<Map<String, dynamic>>.empty();
          }
          return items.where(
            (item) => (item['dusun'] ?? '').toLowerCase().contains(
              textEditingValue.text.toLowerCase(),
            ),
          );
        },
        fieldViewBuilder:
            (context, textEditingController, focusNode, onFieldSubmitted) {
              textEditingController.text = controller.text;
              return TextFormField(
                controller: textEditingController,
                focusNode: focusNode,
                decoration: InputDecoration(
                  labelText: label,
                  prefixIcon: icon != null
                      ? Icon(icon, color: Colors.blueAccent)
                      : null,
                  filled: true,
                  fillColor: Colors.blue.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Wajib diisi' : null,
              );
            },
        onSelected: (selected) => onSelected(selected),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFB3E5FC), Color(0xFFE1F5FE)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // AppBar
              Container(
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.lightBlueAccent,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Center(
                        child: Text(
                          widget.student == null
                              ? 'Tambah Data Siswa'
                              : 'Edit Data Siswa',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Data Diri
                        Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSectionTitle('Data Diri'),
                                _buildTextField(
                                  'nisn',
                                  'NISN',
                                  Icons.badge,
                                  isNumber: true,
                                ),
                                _buildTextField(
                                  'namaLengkap',
                                  'Nama Lengkap',
                                  Icons.person,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 12.0),
                                  child: DropdownButtonFormField<String>(
                                    value: _selectedGender,
                                    decoration: InputDecoration(
                                      labelText: 'Jenis Kelamin',
                                      prefixIcon: const Icon(
                                        Icons.wc,
                                        color: Colors.blueAccent,
                                      ),
                                      filled: true,
                                      fillColor: Colors.blue.shade50,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
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
                                    onChanged: (value) =>
                                        setState(() => _selectedGender = value),
                                    validator: (value) => value == null
                                        ? 'Pilih jenis kelamin'
                                        : null,
                                  ),
                                ),
                                _buildTextField(
                                  'agama',
                                  'Agama',
                                  Icons.account_balance,
                                ),
                                _buildTextField(
                                  'tempatTanggalLahir',
                                  'Tempat, Tanggal Lahir',
                                  Icons.calendar_today,
                                ),
                                _buildTextField(
                                  'noTlp',
                                  'No. Telepon / HP',
                                  Icons.phone,
                                  isNumber: true,
                                ),
                                _buildTextField(
                                  'nik',
                                  'NIK',
                                  Icons.credit_card,
                                  isNumber: true,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Alamat
                        Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSectionTitle('Alamat'),
                                _buildTextField('jalan', 'Jalan', Icons.map),
                                _buildTextField('rtRw', 'RT/RW', Icons.home),
                                _buildAutocompleteField(
                                  label: 'Dusun Siswa',
                                  controller: controllers['dusun']!,
                                  items: _alamatList,
                                  icon: Icons.location_city,
                                  onSelected: (selected) {
                                    controllers['dusun']!.text =
                                        selected['dusun'] ?? '';
                                    controllers['desa']!.text =
                                        selected['desa'] ?? '';
                                    controllers['kecamatan']!.text =
                                        selected['kecamatan'] ?? '';
                                    controllers['kabupaten']!.text =
                                        selected['kabupaten'] ?? '';
                                    controllers['provinsi']!.text =
                                        selected['provinsi'] ?? '';
                                    controllers['kodePos']!.text =
                                        selected['kode_pos'] ?? '';
                                    _selectedAlamatSiswaId = selected['id'];
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Orang Tua / Wali
                        Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSectionTitle('Orang Tua / Wali'),
                                _buildTextField(
                                  'namaAyah',
                                  'Nama Ayah',
                                  Icons.man,
                                ),
                                _buildTextField(
                                  'namaIbu',
                                  'Nama Ibu',
                                  Icons.woman,
                                ),
                                _buildTextField(
                                  'namaWali',
                                  'Nama Wali',
                                  Icons.group,
                                ),
                                _buildAutocompleteField(
                                  label: 'Dusun Wali',
                                  controller: controllers['alamat']!,
                                  items: _alamatList,
                                  icon: Icons.home,
                                  onSelected: (selected) {
                                    controllers['alamat']!.text =
                                        '${selected['dusun']}, ${selected['desa']}, ${selected['kecamatan']}, ${selected['kabupaten']}, ${selected['provinsi']}';
                                    _selectedAlamatOrtuId = selected['id'];
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: _saveData,
                            child: const Text(
                              'Simpan',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
