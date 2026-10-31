import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:monisa/app/theme/app_colors.dart';
import 'package:monisa/app/theme/app_text.dart';

import '../controllers/quiz_submission_detail_controller.dart';

class QuizSubmissionDetailView extends GetView<QuizSubmissionDetailController> {
  const QuizSubmissionDetailView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value && controller.questions.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.errorMessage.value != null && controller.questions.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(controller.errorMessage.value!,
                          textAlign: TextAlign.center, style: AppText.Body2),
                    ),
                  );
                }

                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Column(
                    children: [
                      _buildInfoCard(),
                      const SizedBox(height: 20),
                      _buildQuestionCard(context),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: const Icon(Icons.arrow_back, size: 26),
          ),
          const SizedBox(width: 16),
          Text('Detail Tugas', style: AppText.Header1),
        ],
      ),
    );
  }

  BoxDecoration get _cardDecoration => BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.black, width: 1),
      );

  Widget _buildInfoCard() {
    return Container(
      width: double.infinity,
      decoration: _cardDecoration,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: Obx(() => Text(controller.quizTitle.value, style: AppText.Header2)),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: AppColors.black, width: 1),
                  ),
                  child: Obx(() => Text(
                        '${controller.score.value ?? '-'}/${controller.maxScore.value}',
                        style: AppText.Body2,
                      )),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.black),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Obx(() {
                      final name = controller.studentName.value;
                      return CircleAvatar(
                        radius: 16,
                        backgroundColor: AppColors.black.withOpacity(0.05),
                        child: Text(
                          name.isNotEmpty ? name[0].toUpperCase() : '?',
                          style: AppText.Body1_SemiBold,
                        ),
                      );
                    }),
                    const SizedBox(width: 10),
                    Obx(() => Text(controller.studentName.value,
                        style: AppText.Body1_SemiBold)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.file_upload_outlined, size: 18),
                    const SizedBox(width: 8),
                    Obx(() => Text.rich(
                          TextSpan(
                            style: AppText.Body2,
                            children: [
                              const TextSpan(text: 'Dikirim pada: '),
                              TextSpan(
                                text: controller.submittedDateLabel,
                                style: AppText.Body2.copyWith(fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(BuildContext context) {
    return Obx(() {
      final q = controller.currentQuestion;
      if (q == null) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: _cardDecoration,
          child: Text('Belum ada soal.', style: AppText.Body2),
        );
      }

      final index = controller.currentIndex.value;

      return Container(
        width: double.infinity,
        decoration: _cardDecoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildNavRow(context),
            const Divider(height: 1, color: AppColors.black),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text('Pertanyaan no. ${index + 1}', style: AppText.Header2),
                      ),
                      Text(controller.pointLabel(q), style: AppText.Body2),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(q.question, style: AppText.Body1_SemiBold),
                  if (q.image != null && q.image!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        q.image!,
                        errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  if (q.type == 'essay')
                    _buildEssayAnswer(q)
                  else
                    ...q.options.map(_buildOption),
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.black),
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: controller.onReviewScoreTap,
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                      side: const BorderSide(color: AppColors.black, width: 1),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text('Tinjau ulang skor',
                      style: AppText.Body1_SemiBold.copyWith(color: AppColors.black)),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildNavRow(BuildContext context) {
    Widget navButton(IconData icon, bool enabled, VoidCallback onTap) {
      return GestureDetector(
        onTap: enabled ? onTap : null,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: enabled ? AppColors.black : AppColors.black.withOpacity(0.25),
              width: 1,
            ),
          ),
          child: Icon(icon,
              size: 20,
              color: enabled ? AppColors.black : AppColors.black.withOpacity(0.25)),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          navButton(Icons.chevron_left, controller.hasPrev, controller.prev),
          const SizedBox(width: 8),
          navButton(Icons.chevron_right, controller.hasNext, controller.next),
          const Spacer(),
          GestureDetector(
            onTap: () => _showQuestionGrid(context),
            child: const Icon(Icons.apps, size: 28),
          ),
        ],
      ),
    );
  }

  void _showQuestionGrid(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Obx(() => Wrap(
              spacing: 10,
              runSpacing: 10,
              children: List.generate(controller.questions.length, (i) {
                final selected = i == controller.currentIndex.value;
                return GestureDetector(
                  onTap: () {
                    controller.goTo(i);
                    Get.back();
                  },
                  child: Container(
                    width: 44,
                    height: 44,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: selected ? AppColors.Tangerine : AppColors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.black, width: 1),
                    ),
                    child: Text(
                      '${i + 1}',
                      style: AppText.Body1_SemiBold.copyWith(
                        color: selected ? AppColors.white : AppColors.black,
                      ),
                    ),
                  ),
                );
              }),
            )),
      ),
    );
  }

  Widget _buildOption(QuizOptionResult o) {
    final selected = o.selected;
    final fg = selected ? AppColors.white : AppColors.black;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: selected ? AppColors.Tangerine : AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.black, width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(o.text, style: AppText.Body2.copyWith(color: fg)),
                if (o.image != null && o.image!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      o.image!,
                      height: 100,
                      errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (selected) Icon(Icons.check, size: 20, color: fg),
        ],
      ),
    );
  }

  Widget _buildEssayAnswer(QuizQuestionResult q) {
    final answer = (q.essayAnswer == null || q.essayAnswer!.trim().isEmpty)
        ? 'Siswa tidak menjawab.'
        : q.essayAnswer!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.black, width: 1),
      ),
      child: Text(answer, style: AppText.Body2),
    );
  }
}
