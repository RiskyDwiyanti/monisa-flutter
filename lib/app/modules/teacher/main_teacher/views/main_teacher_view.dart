import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:monisa/app/modules/teacher/class_teacher/views/class_teacher_view.dart';
import 'package:monisa/app/modules/teacher/home_teacher/views/home_teacher_view.dart';
import 'package:monisa/app/modules/teacher/main_teacher/views/widget/custom_button_nav_bar_teacher.dart';
import 'package:monisa/app/modules/teacher/presensi_teacher/views/presensi_teacher_view.dart';
import 'package:monisa/app/modules/teacher/profile_teacher/views/profile_teacher_view.dart';

import '../controllers/main_teacher_controller.dart';

class MainTeacherView extends GetView<MainTeacherController> {
  const MainTeacherView({super.key});
  @override
  Widget build(BuildContext context) {
    final page = [
      const HomeTeacherView(),
      const ClassTeacherView(),
      const PresensiTeacherView(),
      const ProfileTeacherView(),
    ];
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      body: Obx(() => page[controller.selectedIndex.value]),
      bottomNavigationBar: const CustomButtomNavBarTeacher(),
    );
  }
}
