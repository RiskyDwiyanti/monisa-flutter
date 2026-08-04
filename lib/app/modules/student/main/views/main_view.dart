import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:monisa/app/modules/student/beranda/home/views/home_view.dart';
import 'package:monisa/app/modules/student/kelas/class/views/class_view.dart';
import 'package:monisa/app/modules/student/main/views/widgets/custom_buttom_nav_bar.dart';
import 'package:monisa/app/modules/student/kehadiran/presensi/views/presensi_view.dart';
import 'package:monisa/app/modules/student/profile/views/profile_view.dart';

import '../controllers/main_controller.dart';

class MainView extends GetView<MainController> {
  const MainView({super.key});
  @override
  Widget build(BuildContext context) {
    final page = [
      const HomeView(),
      const ClassView(),
      const PresensiView(),
      const ProfileView(),
    ];
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      body: Obx(() => page[controller.selectedIndex.value]),
      bottomNavigationBar: const CustomButtomNavBar(),
    );
  }
}
