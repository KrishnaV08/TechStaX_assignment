import 'package:get/get.dart';
import 'package:just_task_it/app/routes/app_pages.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashController extends GetxController {
  //TODO: Implement SplashController

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    navigateTo();
  }

void navigateTo() async {
    await Future.delayed(const Duration(seconds: 2));

    final session = Supabase.instance.client.auth.currentSession;

    if (session != null) {
      Get.offAllNamed(Routes.DASHBOARD);   // already logged in
    } else {
      Get.offAllNamed(Routes.GET_STARTED); // not logged in
    }
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
