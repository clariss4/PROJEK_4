import 'package:flutter/material.dart';
import '../models/student.dart';

class StudentCard extends StatelessWidget {
  final Student student;
  final VoidCallback? onEdit; // callback untuk edit
  final VoidCallback? onDelete; // callback untuk delete
  final VoidCallback? onTap; //pindah ke detail page

  const StudentCard({
    super.key,
    required this.student,
    this.onEdit,
    this.onDelete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: ListTile(
        leading: const Icon(Icons.person, color: Colors.blue),
        title: Text(
          student.namaLengkap,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(student.nisn),
        onTap: onTap,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              //edit
              icon: const Icon(Icons.edit, color: Colors.grey),
              onPressed: onEdit,
            ),
            IconButton(
              //delete
              icon: const Icon(Icons.delete, color: Colors.blueAccent),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
