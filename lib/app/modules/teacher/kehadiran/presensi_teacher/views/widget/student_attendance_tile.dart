import 'package:flutter/material.dart';
import 'package:monisa/app/modules/teacher/kehadiran/presensi_teacher/controllers/presensi_teacher_controller.dart';
import 'package:monisa/app/theme/app_colors.dart';
import 'package:monisa/app/theme/app_text.dart';

class StudentAttendanceTile extends StatelessWidget {
  final StudentAttendanceModel student;
  final VoidCallback? onTap;

  const StudentAttendanceTile({
    super.key, 
    required this.student, 
    this.onTap,
  });

  String getStatus(String status) {
    switch (status) {
      case 'hadir':
        return 'Hadir';

      case 'alpha':
        return 'Alpha';

      case 'sakit':
        return 'Sakit';

      case 'izin':
        return 'Izin';
      
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.black),
          ),
        ),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.black),
              ),
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey.shade200,
                backgroundImage:
                    student.photoUrl.isNotEmpty ? NetworkImage(student.photoUrl) : null,
                child: student.photoUrl.isEmpty
                    ? const Icon(Icons.person, color: Colors.grey)
                    : null,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                student.name,
                style: AppText.Body_Bold,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.black),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                getStatus(student.status),
                style: AppText.Body1_SemiBold
              ),
            ),
          ],
        ),
      ),
    );
  }
}