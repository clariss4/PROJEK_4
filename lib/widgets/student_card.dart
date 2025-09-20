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
    // palet netral & pastel
    final colors = [
      Colors.teal.shade200,
      Colors.amber.shade300,
      Colors.pink.shade200,
      Colors.green.shade200,
      Colors.orange.shade200,
      Colors.purple.shade200,
    ];
    return colors[name.hashCode % colors.length];
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
          borderRadius: BorderRadius.circular(20),
          splashColor: Colors.grey.shade200,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey.shade50, // netral
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300.withOpacity(.25),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  /* ---------- Avatar ---------- */
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _avatarColor(student.namaLengkap),
                    ),
                    child: Center(
                      child: Text(
                        _initials(student.namaLengkap),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),

                  /* ---------- Nama & NISN ---------- */
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          student.namaLengkap,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          student.nisn,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  /* ---------- Tombol Aksi (rounded) ---------- */
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _circleIcon(
                        icon: Icons.edit_rounded,
                        color: Colors.teal,
                        onTap: onEdit,
                      ),
                      const SizedBox(width: 8),
                      _circleIcon(
                        icon: Icons.delete_rounded,
                        color: Colors.redAccent,
                        onTap: onDelete,
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

  Widget _circleIcon({
    required IconData icon,
    required Color color,
    VoidCallback? onTap,
  }) {
    return Material(
      color: color.withOpacity(.12),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        splashColor: color.withOpacity(.25),
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(icon, size: 20, color: color),
        ),
      ),
    );
  }
}
