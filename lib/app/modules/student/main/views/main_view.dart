import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:monisa/app/modules/student/class/views/class_view.dart';
import 'package:monisa/app/modules/student/home/views/home_view.dart';
import 'package:monisa/app/modules/student/main/views/widgets/custom_buttom_nav_bar.dart';
import 'package:monisa/app/modules/student/presence/views/presence_view.dart';
import 'package:monisa/app/modules/student/profile/views/profile_view.dart';

import '../controllers/main_controller.dart';

class MainView extends GetView<MainController> {
  const MainView({super.key});
  @override
  Widget build(BuildContext context) {
    final page = [
      const HomeView(),
      const ClassView(),
      const PresenceView(),
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
