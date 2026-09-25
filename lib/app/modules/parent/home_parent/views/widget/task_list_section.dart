import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:intl/intl.dart';
import 'package:monisa/app/modules/parent/home_parent/controllers/home_parent_controller.dart';
import 'package:monisa/app/modules/student/beranda/home/views/widgets/tugas_card.dart';
import 'package:monisa/app/theme/app_text.dart';

class TaskListSection extends StatelessWidget {
  final HomeParentController controller;
  const TaskListSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Daftar Tugas', style: AppText.Header2),
            GestureDetector(
              onTap: () {
                // TODO: navigate to full tugas list page
              },
              child: Text(
                'Lihat semua',
                style: AppText.Body1.copyWith(decoration: TextDecoration.underline),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text('Monitor pekerjaan anak anda.', style: AppText.SubHeading),
        const SizedBox(height: 12),
        SizedBox(
          height: 190,
          child: Obx(() {
            final tugas = controller.tugasList;
            if (tugas.isEmpty) {
              return Center(child: Text('Belum ada tugas.', style: AppText.Body));
            }
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: tugas.length,
              itemBuilder: (context, index) {
                final item = tugas[index];
                return TugasCard(
                  title: item.title,
                  subject: item.subject,
                  status: item.status,
                  bgColor: item.bgColor,
                  deadline: DateFormat('d MMMM yyyy, HH:mm', 'id_ID').format(item.deadline),
                );
              },
            );
          }),
        ),
      ],
    );
  }
}