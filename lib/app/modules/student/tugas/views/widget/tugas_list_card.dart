import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:monisa/app/theme/app_colors.dart';
import 'package:monisa/app/theme/app_text.dart';

class TugasListCard extends StatelessWidget {
  final String title;
  final String subject;
  final String deadline;
  final String status;
  final Color bgColor;
  final VoidCallback? onTap;

  const TugasListCard({
    super.key,
    required this.title,
    required this.subject,
    required this.deadline,
    required this.status,
    required this.bgColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.black, width: 1),
        ),
        child: Column(
          children: [
            // ===== HEADER (warna) =====
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: AppText.Heading2),
                        const SizedBox(height: 4),
                        Text(subject, style: AppText.Body2),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: AppColors.black, width: 1),
                    ),
                    child: Text(status, style: AppText.Body1_SemiBold),
                  ),
                ],
              ),
            ),

            // ===== FOOTER (tenggat) =====
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/hourglass_icon.svg',
                        width: 17.5,
                        height: 17.5,
                        color: AppColors.black
                      ),
                      const SizedBox(width: 6),
                      Text('Tenggat', style: AppText.Body2),
                    ],
                  ),
                  Text(deadline, style: AppText.Body1_SemiBold),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}