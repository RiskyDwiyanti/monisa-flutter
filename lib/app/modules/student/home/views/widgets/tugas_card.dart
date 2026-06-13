import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:monisa/app/theme/app_colors.dart';
import 'package:monisa/app/theme/app_text.dart';

class TugasCard extends StatelessWidget {
  final String title;
  final String subject;
  final String deadline;
  final String status;
  final Color bgColor;

  const TugasCard({
    super.key,
    required this.title,
    required this.subject,
    required this.deadline,
    required this.status,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 370,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white, // ✅ base putih
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.black,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [

          // ===== BAGIAN ATAS (berwarna) =====
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              decoration: BoxDecoration(
                color: bgColor, 
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14),
                  topRight: Radius.circular(14),
                ),
                border: Border.symmetric(
                  horizontal: BorderSide(
                    color: AppColors.black,
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: AppText.Heading2,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(color: AppColors.black, width: 1),
                        ),
                        child: Text(status, style: AppText.Body1_SemiBold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subject,
                    style: AppText.Body2
                  ),
                ],
              ),
            ),
          ),

          // ===== DIVIDER =====
          Divider(
            color: const Color(0xFF1A1A1A).withOpacity(0.15),
            height: 1,
            thickness: 1,
          ),

          // ===== BAGIAN BAWAH (putih) =====
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/hourglass_icon.svg',
                  width: 17.5,
                  height: 17.5,
                  color: AppColors.black
                ),
                const SizedBox(width: 6),
                Text('Tenggat', style: AppText.Body2),
                const Spacer(),
                Text(deadline, style: AppText.Body1_SemiBold),
              ],
            ),
          ),
        ],
      ),
    );
  }
}