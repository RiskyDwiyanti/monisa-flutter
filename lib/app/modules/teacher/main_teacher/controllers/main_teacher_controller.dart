import 'package:get/get.dart';

class MainTeacherController extends GetxController {
  //TODO: Implement MainTeacherController
  var selectedIndex = 0.obs;

  void changeIndex(int index) => selectedIndex.value = index;

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
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
