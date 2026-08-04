import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:monisa/app/theme/app_text.dart';

/// Satu baris menu dengan icon di kiri, label di tengah, dan optional
/// trailing icon (chevron) di kanan. Dipakai berulang di halaman Profil.
class MenuTitle extends StatelessWidget {
  final SvgPicture icon;
  final String label;
  final VoidCallback? onTap;
  final Color? labelColor;
  final Color? iconColor;

  const MenuTitle({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
    this.labelColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        child: Row(
          children: [
            icon,
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: AppText.SubHeading
              ),
            ),
          ],
        ),
      ),
    );
  }
}