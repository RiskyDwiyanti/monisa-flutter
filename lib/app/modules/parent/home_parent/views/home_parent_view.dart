import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:monisa/app/modules/parent/home_parent/views/widget/greeting_header.dart';
import 'package:monisa/app/modules/parent/home_parent/views/widget/task_list_section.dart';
import 'package:monisa/app/theme/app_colors.dart';

import '../controllers/home_parent_controller.dart';

class HomeParentView extends GetView<HomeParentController> {
  const HomeParentView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.Butter,
      body: SafeArea(
        child: Column(
          children: [
            GreetingHeader(controller: controller),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                  ),
                ),
                child: RefreshIndicator(
                  onRefresh: controller.fetchHomeData, 
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TaskListSection(controller: controller),
                        const SizedBox(height: 24),
                        AttendanceCalendarSection(controller: controller),
                        const SizedBox(height: 24),
                        NilaiSection(controller: controller),
                      ],
                    ),
                  )
                ),
              ) 
            ),
          ],
        ),
      ),
    );
  }
}
