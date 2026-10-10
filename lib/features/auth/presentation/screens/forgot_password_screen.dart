import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/features/auth/presentation/controllers/auth_controller.dart';
import 'package:flutter_application_1/widgets/custom_text_field.dart';
import 'package:flutter_application_1/widgets/primary_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _authController = Get.find<AuthController>();

  String? _emailError;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    final email = _emailController.text.trim();

    setState(() {
      _emailError = null;

      if (email.isEmpty) {
        _emailError = 'Please enter your email.';
      } else if (!GetUtils.isEmail(email)) {
        _emailError = 'Please enter a valid email address.';
      }
    });

    if (_emailError != null) return;

    final success = await _authController.sendPasswordResetEmail(
      email: email,
    );

    if (!mounted) return;
    if (success) {
      Get.back();

      Get.snackbar(
        'Email sent',
        'If an account exists for this email, you will receive a reset link.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.lightGreen,
        colorText: AppColors.darkText,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 4),
      );
    } else {
      Get.snackbar(
        'Request failed',
        _authController.errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          onPressed: Get.back,
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: AppColors.darkText,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    color: AppColors.lightGreen,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: const Icon(
                    Icons.lock_reset_rounded,
                    size: 46,
                    color: AppColors.green,
                  ),
                ),
                const SizedBox(height: 28),
                const Text(
                  'Forgot password?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: AppColors.darkText,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Enter your email address and we will send '
                  'you a link to reset your password.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: AppColors.secondaryText,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 36),
                const Text(
                  'Email address',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkText,
                  ),
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: _emailController,
                  hintText: 'Enter your email',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  errorText: _emailError,
                  onChange: (_) {
                    if (_emailError != null) {
                      setState(() => _emailError = null);
                    }
                  },
                ),
                const SizedBox(height: 28),
                Obx(
                  () => PrimaryButton(
                    text: _authController.isLoading.value
                        ? 'Sending...'
                        : 'Send reset link',
                    onPressed:
                        _authController.isLoading.value ? null : _resetPassword,
                    height: 56,
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
