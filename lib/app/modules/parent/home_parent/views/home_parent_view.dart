import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_parent_controller.dart';

class HomeParentView extends GetView<HomeParentController> {
  const HomeParentView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeParentView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'HomeParentView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
