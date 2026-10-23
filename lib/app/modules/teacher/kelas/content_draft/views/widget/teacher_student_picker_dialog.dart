import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monisa/app/theme/app_colors.dart';
import 'package:monisa/app/theme/app_text.dart';

import '../../controllers/teacher_student_picker_controller.dart';

/// Buka dialog "Pilih siswa". Mengembalikan List<StudentOption> hasil pilihan, atau null kalau dibatalkan.
Future<List<StudentOption>?> openTeacherStudentPickerDialog(
  BuildContext context, {
  required int classId,
  List<int> initialSelectedIds = const [],
}) {
  final tag = 'student_picker_$classId';

  Get.put(
    TeacherStudentPickerController(
      classId: classId,
      initialSelectedIds: initialSelectedIds,
    ),
    tag: tag,
  );

  return Get.dialog<List<StudentOption>>(
    _StudentPickerDialog(tag: tag),
  ).whenComplete(() {
    Get.delete<TeacherStudentPickerController>(tag: tag);
  });
}

class _StudentPickerDialog extends StatelessWidget {
  final String tag;

  const _StudentPickerDialog({required this.tag});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TeacherStudentPickerController>(tag: tag);

    return Dialog(
      backgroundColor: AppColors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppColors.black, width: 1),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== HEADER (garis bawah penuh) =====
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppColors.black, width: 1),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Daftar siswa', style: AppText.Header2),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: const Icon(Icons.close, size: 22),
                  ),
                ],
              ),
            ),

            // ===== ISI =====
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ===== SEARCH =====
                    TextField(
                      onChanged: controller.onSearchChanged,
                      decoration: InputDecoration(
                        hintText: 'Cari',
                        hintStyle: AppText.Body2.copyWith(
                            color: AppColors.black.withOpacity(0.8)),
                        prefixIcon: const Icon(Icons.search, size: 24),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide:
                              const BorderSide(color: AppColors.black, width: 1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide:
                              const BorderSide(color: AppColors.black, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                              color: AppColors.black, width: 1.4),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ===== TUGASKAN UNTUK / SEMUA =====
                    Obx(() {
                      final allSelected = controller.students.isNotEmpty &&
                          controller.selectedIds.length ==
                              controller.students.length;

                      return Row(
                        children: [
                          Text('Tugaskan untuk:', style: AppText.Body1_SemiBold),
                          const Spacer(),
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              if (allSelected) {
                                controller.selectedIds.clear();
                              } else {
                                controller.selectAll();
                              }
                            },
                            child: Row(
                              children: [
                                Text('Semua', style: AppText.SubHeader_SemiBold),
                                const SizedBox(width: 8),
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: Checkbox(
                                    value: allSelected,
                                    onChanged: (_) {
                                      if (allSelected) {
                                        controller.selectedIds.clear();
                                      } else {
                                        controller.selectAll();
                                      }
                                    },
                                    activeColor: AppColors.Tangerine,
                                    checkColor: AppColors.white,
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    visualDensity: VisualDensity.compact,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    side: const BorderSide(
                                        color: AppColors.Tangerine, width: 1.5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }),
                    const SizedBox(height: 16),

                    // ===== LIST SISWA =====
                    Flexible(
                      child: Obx(() {
                        if (controller.isLoading.value) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 24),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        if (controller.errorMessage.value != null) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Text(
                              controller.errorMessage.value!,
                              style: AppText.Body2,
                              textAlign: TextAlign.center,
                            ),
                          );
                        }

                        final students = controller.filteredStudents;

                        if (students.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Text(
                              'Belum ada siswa di kelas ini.',
                              style: AppText.Body2,
                              textAlign: TextAlign.center,
                            ),
                          );
                        }

                        return ListView.separated(
                          shrinkWrap: true,
                          itemCount: students.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final student = students[index];
                            return Obx(() {
                              final isSelected =
                                  controller.selectedIds.contains(student.id);

                              return GestureDetector(
                                onTap: () => controller.toggleStudent(student.id),
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18, vertical: 18),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                        color: AppColors.black, width: 1),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(student.name,
                                            style: AppText.SubHeader_SemiBold),
                                      ),
                                      Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(4),
                                          border: Border.all(
                                              color: AppColors.black, width: 1),
                                        ),
                                        child: isSelected
                                            ? const Icon(Icons.check, size: 16)
                                            : null,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            });
                          },
                        );
                      }),
                    ),
                    const SizedBox(height: 16),

                    // ===== TOMBOL SIMPAN =====
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          final result = controller.students
                              .where((e) => controller.selectedIds.contains(e.id))
                              .toList();
                          Get.back(result: result);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.Tangerine,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                            side:
                                const BorderSide(color: AppColors.black, width: 1),
                          ),
                        ),
                        child: Text('Simpan',
                            style: AppText.Body1_SemiBold
                                .copyWith(color: AppColors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}