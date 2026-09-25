import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:monisa/app/modules/parent/home_parent/controllers/home_parent_controller.dart';
import 'package:monisa/app/theme/app_colors.dart';
import 'package:monisa/app/theme/app_text.dart';

class GreetingHeader extends StatelessWidget {
  final HomeParentController controller;
  const GreetingHeader({super.key, required this.controller});

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 11) return 'Selamat Pagi';
    if (hour < 15) return 'Selamat Siang';
    if (hour < 18) return 'Selamat Sore';
    return 'Selamat Malam';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Obx(() => Text(
              '$_greeting, ${controller.greetingName}!',
              style: AppText.Header1,
            ),) ,
          ),
          GestureDetector(
            onTap: () {
              
            },
            child: Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.black, width: 1.5),
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/icons/bell_icon.svg',
                  width: 22,
                  height: 22,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}