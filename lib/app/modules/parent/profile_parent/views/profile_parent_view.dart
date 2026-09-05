import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/profile_parent_controller.dart';

class ProfileParentView extends GetView<ProfileParentController> {
  const ProfileParentView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ProfileParentView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ProfileParentView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
