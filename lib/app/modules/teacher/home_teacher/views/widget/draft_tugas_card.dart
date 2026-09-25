import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:monisa/app/modules/teacher/beranda/home_teacher/controllers/home_teacher_controller.dart';
import 'package:monisa/app/theme/app_colors.dart';
import 'package:monisa/app/theme/app_text.dart';

class DraftTugasCard extends StatelessWidget {
  const DraftTugasCard({super.key, required this.draft, this.onTap});
  final DraftTugasModel draft;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 280,
        height: 150,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.black),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    
                    children: [
                      Text(
                        draft.judul,
                        style: AppText.SubHeading,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '.',
                        style: AppText.SubHeading,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        draft.infoSoal,
                        style: AppText.Body1,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: draft.tipeSoal
                        .map((tipe) => Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.black),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(tipe, style: AppText.Body),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Container(
              width: double.infinity,
              color: draft.accentColor,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/door_icon.svg',
                    width: 24,
                    height: 24,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      draft.kelas,
                      style: AppText.Body1.copyWith(
                        color: AppColors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}