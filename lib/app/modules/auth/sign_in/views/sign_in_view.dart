import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_task_it/app/routes/app_pages.dart';

import '../controllers/sign_in_controller.dart';

class SignInView extends GetView<SignInController> {
  const SignInView({super.key});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0,
            leading: IconButton(
              onPressed: () => Get.back(),
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          bottomNavigationBar: Obx(() {
            final isValid = controller.isFormValid.value;
            return Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              padding: const EdgeInsets.all(18),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: isValid ? () => controller.signIn() : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isValid
                            ? const Color.fromARGB(255, 255, 140, 0)
                            : Colors.grey.shade300,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Continue',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            );
          }),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 32),

                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(
                        255,
                        255,
                        140,
                        0,
                      ).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 48,
                      color: Color.fromARGB(255, 255, 140, 0),
                    ),
                  ),

                  const SizedBox(height: 24),

                  Text(
                    'Welcome Back!',
                    style: GoogleFonts.poppins(
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Sign in to resume your hustle.',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 36),

                  TextFormField(
                    controller: controller.emailController,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (_) => controller.validateForm(),
                    style: TextStyle(
                      color: const Color.fromARGB(255, 77, 77, 77),
                    ),
                    decoration: _inputDecoration(
                      hint: 'Email address',
                      icon: Icons.email_outlined,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Please enter your email';
                      if (!GetUtils.isEmail(value))
                        return 'Please enter a valid email';
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  Obx(
                    () => TextFormField(
                      controller: controller.passwordController,
                      obscureText: controller.obscurePassword.value,
                      onChanged: (_) => controller.validateForm(),
                      style: TextStyle(
                        color: const Color.fromARGB(255, 77, 77, 77),
                      ),
                      decoration: _inputDecoration(
                        hint: 'Password',
                        icon: Icons.lock_outline_rounded,
                        suffix: IconButton(
                          icon: Icon(
                            controller.obscurePassword.value
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: Colors.grey,
                          ),
                          onPressed: () => controller.obscurePassword.toggle(),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Please enter a password';
                        if (value.length < 6)
                          return 'Password must be at least 6 characters';
                        return null;
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'New User?  ',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Get.toNamed(Routes.SIGN_UP),
                        child: Text(
                          'Sign Up',
                          style: GoogleFonts.poppins(
                            color: const Color.fromARGB(255, 255, 140, 0),
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Obx(
          () =>
              controller.isLoading.value
                  ? Container(
                    color: Colors.black.withOpacity(0.3),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Color.fromARGB(255, 255, 140, 0),
                      ),
                    ),
                  )
                  : const SizedBox.shrink(),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
      prefixIcon: Icon(icon, color: Colors.grey.shade400, size: 20),
      suffixIcon: suffix,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color.fromARGB(255, 255, 140, 0),
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
    );
  }
}
