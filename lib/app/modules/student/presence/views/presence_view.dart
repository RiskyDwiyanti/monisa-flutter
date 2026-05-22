import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/presence_controller.dart';

class PresenceView extends GetView<PresenceController> {
  const PresenceView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PresenceView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'PresenceView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
