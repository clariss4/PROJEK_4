import 'package:flutter/material.dart';
import '../models/student.dart';

class StudentCard extends StatelessWidget {
  final Student student;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;

  const StudentCard({
    super.key,
    required this.student,
    this.onEdit,
    this.onDelete,
    this.onTap,
  });

  /* ---------- Helper ---------- */
  Color _avatarColor(String name) {
    return Colors.primaries[name.hashCode % Colors.primaries.length];
  }

  String _initials(String name) {
    final parts = name.split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.substring(0, 2).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          splashColor: Colors.white.withOpacity(.2),
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                colors: [Colors.blue.shade50, Colors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(.15),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  /* ---------- Avatar Gradient ---------- */
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          _avatarColor(student.namaLengkap),
                          _avatarColor(student.namaLengkap).withOpacity(.7),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Text(
                        _initials(student.namaLengkap),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  /* ---------- Nama & NISN ---------- */
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          student.namaLengkap,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          student.nisn,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  /* ---------- Tombol Aksi ---------- */
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /* Edit */
                      IconButton(
                        icon: const Icon(
                          Icons.edit_rounded,
                          color: Colors.indigo,
                        ),
                        onPressed: onEdit,
                        splashRadius: 24,
                      ),
                      const SizedBox(width: 4),
                      /* Delete */
                      IconButton(
                        icon: const Icon(
                          Icons.delete_rounded,
                          color: Colors.redAccent,
                        ),
                        onPressed: onDelete,
                        splashRadius: 24,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
