import 'package:get/get.dart';

class DetailTugasController extends GetxController {
  //TODO: Implement DetailTugasController
  late final String title;
  late final String icon;
  late final String tanggal;
  late final String status;
  late final String teacherName;
  late final String teacherAvatarUrl;
  late final String description;
  late final String tenggat;

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    title = Get.arguments['title'];
    icon = Get.arguments['icon'];
    tanggal = Get.arguments['tanggal'];
    status = Get.arguments['status'];
    teacherName = Get.arguments['teacherName'];
    teacherAvatarUrl = Get.arguments['teacherAvatarUrl'];
    description = Get.arguments['description'];
    tenggat = Get.arguments['tenggat'];
  }

  void onTambahTugas() {
    // Implement the logic for adding a new task
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
