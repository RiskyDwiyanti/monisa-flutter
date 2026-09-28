import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/kelas_selected_controller.dart';

class KelasSelectedView extends GetView<KelasSelectedController> {
  const KelasSelectedView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KelasSelectedView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'KelasSelectedView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
