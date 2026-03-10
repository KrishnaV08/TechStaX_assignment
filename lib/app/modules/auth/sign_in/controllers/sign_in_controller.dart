import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_task_it/app/routes/app_pages.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignInController extends GetxController {
  //TODO: Implement SignInController
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isLoading = false.obs;
  final isFormValid = false.obs;
  final obscurePassword = true.obs;

  void validateForm() {
    final email = emailController.text.trim();
    final password = passwordController.text;

    isFormValid.value = GetUtils.isEmail(email) && password.length >= 6;
  }

  // ✅ Getter — only accessed when called
  SupabaseClient get _supabase => Supabase.instance.client;

  void signIn() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      if (response.user != null) {
        Get.offAllNamed(Routes.DASHBOARD);
      }
    } on AuthException catch (e) {
      Get.snackbar(
        'Sign In Failed',
        e.message,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      Get.snackbar(
        'Something went wrong',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();

    super.onClose();
  }
}
