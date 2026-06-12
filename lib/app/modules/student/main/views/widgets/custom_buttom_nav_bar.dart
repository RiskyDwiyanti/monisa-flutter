import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:monisa/app/modules/student/main/controllers/main_controller.dart';
import 'package:monisa/app/theme/app_colors.dart';
import 'package:monisa/app/theme/app_text.dart';

class CustomButtomNavBar extends GetView<MainController> {
  const CustomButtomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      _NavItem(iconPath: 'assets/icons/home_icon.svg', label:'Beranda',),
      _NavItem(iconPath: 'assets/icons/book_icon.svg', label:'Kelas',),
      _NavItem(iconPath: 'assets/icons/clipboard-check_icon.svg', label:'Presensi',),
      _NavItem(iconPath: 'assets/icons/person_icon.svg', label:'Profil',),
    ];
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: AppColors.black)
      ),
      child: Obx(() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          final isSelected = controller.selectedIndex.value == index;
          final item = items[index];

          if (isSelected) {
            return GestureDetector(
              onTap: () => controller.changeIndex(index),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.Tangerine,
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: AppColors.black, width: 1),
                ),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      item.iconPath,
                      color: AppColors.white,
                      width: 30,
                      height: 30,
                    ),
                    const SizedBox(width: 8,),
                    Text(
                      item.label,
                      style: AppText.Body1_SemiBold.copyWith(
                        color: AppColors.white,
                      ),
                    )
                  ],
                ),
              ),
            );
          }

          return GestureDetector(
            onTap: () => controller.changeIndex(index),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: SvgPicture.asset(
                item.iconPath,
                height: 30,
                width: 30,
                color: isSelected ? AppColors.white : AppColors.black,
              ),
            ),
          );
        }),
      )),
    );
  }
}

class _NavItem {
  final String iconPath;
  final String label;

  _NavItem({required this.iconPath, required this.label});
}