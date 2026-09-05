import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:monisa/app/modules/parent/class_parent/views/class_parent_view.dart';
import 'package:monisa/app/modules/parent/home_parent/views/home_parent_view.dart';
import 'package:monisa/app/modules/parent/main_parent/views/widget/custom_buttom_navbar_parent.dart';
import 'package:monisa/app/modules/parent/presensi_parent/views/presensi_parent_view.dart';
import 'package:monisa/app/modules/parent/profile_parent/views/profile_parent_view.dart';

import '../controllers/main_parent_controller.dart';

class MainParentView extends GetView<MainParentController> {
  const MainParentView({super.key});
  @override
  Widget build(BuildContext context) {
    final page = [
      const HomeParentView(),
      const ClassParentView(),
      const PresensiParentView(),
      const ProfileParentView(),
    ];
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      body: Obx(() => page[controller.selectedIndex.value]),
      bottomNavigationBar: const CustomButtomNavBarParent(),
    );
  }
}
