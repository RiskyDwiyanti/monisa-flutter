import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/class_teacher_controller.dart';

class ClassTeacherView extends GetView<ClassTeacherController> {
  const ClassTeacherView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ClassTeacherView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ClassTeacherView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
