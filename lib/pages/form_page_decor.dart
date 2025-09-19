// import 'package:flutter/material.dart';
// import '../models/student.dart';
// // import 'form_page.dart'; // ← logic asli tetap di sini

// /// Wrapper yang hanya menambah :
// /// - Gradient background
// /// - Glass card
// /// - Rounded input
// /// - Floating button modern
// /// - Ikon khusus
// /// Logic, validator, state TIDAK DIUBAH
// class FormPageDecor extends StatelessWidget {
//   final Student? student;

//   const FormPageDecor({Key? key, this.student}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       appBar: AppBar(
//         title: Text(student == null ? 'Tambah Siswa' : 'Edit Siswa'),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         foregroundColor: Colors.indigo,
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: () =>
//             Navigator.maybePop(context, true), // tetap pakai pop hasil
//         icon: const Icon(Icons.save_rounded),
//         label: const Text('Simpan'),
//         backgroundColor: Colors.indigo,
//         foregroundColor: Colors.white,
//         extendedPadding: const EdgeInsets.symmetric(horizontal: 32),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
//       ),
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Color(0xFFF1F5FB), Colors.white],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: SafeArea(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.all(24),
//             child: GlassCard(
//               child: FormPage(student: student), // ← logic asli
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// /* ---------- Glass Card Wrapper ---------- */
// class GlassCard extends StatelessWidget {
//   final Widget child;
//   const GlassCard({Key? key, required this.child}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(24),
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white.withOpacity(.85),
//           borderRadius: BorderRadius.circular(24),
//           border: Border.all(color: Colors.white.withOpacity(.4), width: 1.5),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.indigo.withOpacity(.15),
//               blurRadius: 20,
//               offset: const Offset(0, 10),
//             ),
//           ],
//         ),
//         child: Padding(padding: const EdgeInsets.all(24), child: child),
//       ),
//     );
//   }
// }
