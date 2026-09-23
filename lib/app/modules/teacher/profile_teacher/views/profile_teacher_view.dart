import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:monisa/app/modules/teacher/profile_teacher/views/widget/dashed_divider_teacher.dart';
import 'package:monisa/app/modules/teacher/profile_teacher/views/widget/menu_title.dart';
import 'package:monisa/app/theme/app_colors.dart';
import 'package:monisa/app/theme/app_text.dart';

import '../controllers/profile_teacher_controller.dart';

class ProfileTeacherView extends GetView<ProfileTeacherController> {
  const ProfileTeacherView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 16),
                    _buildProfileInfo(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ======================= HEADER =========================
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 40, bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text('Profil', style: AppText.Header1)],
      ),
    );
  }

  // ======================= PROFILE INFO =========================
  Widget _buildProfileInfo() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(21),
          decoration: BoxDecoration(
            color: AppColors.Tangerine,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            border: Border(
              top: BorderSide(color: AppColors.black, width: 1),
              left: BorderSide(color: AppColors.black, width: 1),
              right: BorderSide(color: AppColors.black, width: 1),
              bottom: BorderSide(color: AppColors.black, width: 1),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
            border: Border(
              left: BorderSide(color: AppColors.black, width: 1),
              right: BorderSide(color: AppColors.black, width: 1),
              bottom: BorderSide(color: AppColors.black, width: 1),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ============ PROFILE INFO =============
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.black, width: 1),
                ),
                child: Row(
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.black, width: 1),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          'assets/images/profil1.png',
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(
                          () => Text(
                            controller.name.value,
                            style: AppText.Header2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Obx(
                          () => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: controller.mapel.map((nama) {
                              return Padding(
                                padding: EdgeInsets.only(bottom: 4),
                                child: Text(
                                  nama,
                                  style: AppText.Body1_SemiBold,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Obx(
                          () => Text(
                            controller.nuptk.value,
                            style: AppText.Body1_SemiBold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ============ UBAH PASSWORD =============
              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.black, width: 1),
                ),
                child: MenuTitleTeacher(
                  icon: SvgPicture.asset('assets/icons/key_icon.svg'),
                  label: 'Ubah Password',
                  onTap: controller.ubahPassword,
                ),
              ),

              const SizedBox(height: 16),
              // ============ PUSAT BANTUAN =============
              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.black, width: 1),
                ),
                child: Column(
                  children: [
                    MenuTitleTeacher(
                      icon: SvgPicture.asset('assets/icons/question_icon.svg'),
                      label: 'Pusat Bantuan',
                      onTap: controller.pusatBantuan,
                    ),
                    DashedDividerTeacher(),
                    MenuTitleTeacher(
                      icon: SvgPicture.asset('assets/icons/heart_icon.svg'),
                      label: 'Umpan Balik',
                      onTap: controller.umpanBalik,
                    ),
                  ],
                ),
              ),

              // ============ LOGOUT =============
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.black, width: 1),
                ),
                child: MenuTitleTeacher(
                  icon: SvgPicture.asset('assets/icons/logout_icon.svg'),
                  label: 'Log out',
                  onTap: controller.logout,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
