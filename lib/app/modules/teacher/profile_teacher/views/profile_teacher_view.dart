import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/profile_teacher_controller.dart';

class ProfileTeacherView extends GetView<ProfileTeacherController> {
  const ProfileTeacherView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ProfileTeacherView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ProfileTeacherView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
