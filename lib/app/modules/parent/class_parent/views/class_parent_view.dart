import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/class_parent_controller.dart';

class ClassParentView extends GetView<ClassParentController> {
  const ClassParentView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ClassParentView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ClassParentView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
