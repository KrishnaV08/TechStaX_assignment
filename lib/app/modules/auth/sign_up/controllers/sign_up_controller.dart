import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:just_task_it/app/routes/app_pages.dart';

class SignupController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isLoading = false.obs;
  final isFormValid = false.obs;
  final obscurePassword = true.obs;
  final obscureConfirm = true.obs;

  void validateForm() {
    final email = emailController.text.trim();
    final name = nameController.text.trim();
    final password = passwordController.text;
    final confirm = confirmPasswordController.text;

    isFormValid.value =
        GetUtils.isEmail(email) &&
        password.length >= 6 &&
        password == confirm &&
        name.isNotEmpty;
  }

  // ✅ Getter — only accessed when called
  SupabaseClient get _supabase => Supabase.instance.client;

  void signUp() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    try {
      final response = await _supabase.auth.signUp(
        email: emailController.text.trim(),
        password: passwordController.text,
        data: {'name': nameController.text.trim()},
        // ← pass name
      );

      if (response.user != null) {
        Get.snackbar(
          'Email confirmation required',
          'Please check your email to confirm your account.',
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          backgroundColor: Color(0xFFFF8C00),
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        Get.offAllNamed(Routes.SIGN_IN);
      }
    } on AuthException catch (e) {
      Get.snackbar(
        'Sign Up Failed',
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
    confirmPasswordController.dispose();
    super.onClose();
  }
}
