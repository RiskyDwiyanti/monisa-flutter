import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_teacher_controller.dart';

class HomeTeacherView extends GetView<HomeTeacherController> {
  const HomeTeacherView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeTeacherView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'HomeTeacherView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
