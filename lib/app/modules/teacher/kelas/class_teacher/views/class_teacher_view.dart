import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:monisa/app/modules/teacher/kelas/class_teacher/views/widget/teacher_kelas_card.dart';
import 'package:monisa/app/routes/app_pages.dart';
import 'package:monisa/app/theme/app_colors.dart';
import 'package:monisa/app/theme/app_text.dart';

import '../controllers/class_teacher_controller.dart';

class ClassTeacherView extends GetView<ClassTeacherController> {
  const ClassTeacherView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 52, 20, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Kelas', style: AppText.Header1),
          GestureDetector(
            onTap: () async {
              // TODO: buat route CREATE kelas, refresh setelah kembali
              // await Get.toNamed(Routes.TEACHER_CLASS_CREATE);
              // controller.fetchClasses();
            },
            child: Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.black, width: 1),
              ),
              child: Icon(Icons.add, size: 28, color: AppColors.black),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Obx(() {
      if (controller.isLoading.value && controller.classes.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.errorMessage.value != null &&
          controller.classes.isEmpty) {
        return _StateMessage(
          message: controller.errorMessage.value!,
          actionLabel: 'Coba lagi',
          onAction: controller.fetchClasses,
        );
      }

      if (controller.classes.isEmpty) {
        return const _StateMessage(
          message: 'Belum ada kelas. Tekan + untuk membuat kelas baru.',
        );
      }

      return RefreshIndicator(
        onRefresh: controller.fetchClasses,
        child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          itemCount: controller.classes.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final item = controller.classes[index];
            final color = controller.colorFor(index);

            return TeacherKelasCard(
              mataPelajaran: item.mapel,
              kelas: item.rombelName,
              tahunAjaran: item.tahunAjaran,
              students: item.studentPreviews,
              studentsCount: item.studentsCount,
              bgColor: color,
              onTap: () {
                Get.toNamed(Routes.KELAS_SELECTED, arguments: {
                  'id': item.id,
                  'mapel': item.mapel,
                  'kelas': item.rombelName,
                  'tahunAjaran': item.tahunAjaran,
                  'bgColor': color,
                });
              },
              onQrTap: () {
                Get.toNamed(Routes.QR_SHARING, arguments: {
                  'mapel': item.mapel,
                  'kelas': item.rombelName,
                  'tahunAjaran': item.tahunAjaran,
                  'joinCode': item.joinCode, // dipakai untuk isi QR
                  'bgColor': color,
                });
              },
            );
          },
        ),
      );
    });
  }
}

class _StateMessage extends StatelessWidget {
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _StateMessage({required this.message, this.actionLabel, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message,
                textAlign: TextAlign.center, style: AppText.Body2),
            if (actionLabel != null) ...[
              const SizedBox(height: 12),
              TextButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}