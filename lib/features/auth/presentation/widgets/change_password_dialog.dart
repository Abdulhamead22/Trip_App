import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/auth/presentation/controllers/auth_controller.dart';
import 'package:flutter_application_1/widgets/custom_dialog.dart';
import 'package:flutter_application_1/widgets/custom_text_field.dart';
import 'package:get/get.dart';

void showChangePasswordDialog({
  required BuildContext context,
  required AuthController controller,
}) {
  final formKey = GlobalKey<_ChangePasswordFormState>();

  customDialog(
    context: context,
    title: 'Change password',
    content: _ChangePasswordForm(
      key: formKey,
      controller: controller,
    ),
    actions: [
      Obx(
        () => TextButton(
          onPressed: controller.isLoading.value
              ? null
              : () async {
                  await formKey.currentState?.changePassword();
                },
          child: controller.isLoading.value
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
              : const Text('Save'),
        ),
      ),
    ],
  );
}

class _ChangePasswordForm extends StatefulWidget {
  final AuthController controller;

  const _ChangePasswordForm({
    super.key,
    required this.controller,
  });

  @override
  State<_ChangePasswordForm> createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<_ChangePasswordForm> {
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  Future<void> changePassword() async {
    final currentPassword = currentPasswordController.text.trim();
    final newPassword = newPasswordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (currentPassword.isEmpty ||
        newPassword.isEmpty ||
        confirmPassword.isEmpty) {
      Get.snackbar('Missing fields', 'Please fill in all fields.');
      return;
    }

    if (newPassword.length < 6) {
      Get.snackbar(
        'Invalid password',
        'Password must be at least 6 characters.',
      );
      return;
    }

    if (newPassword != confirmPassword) {
      Get.snackbar(
        'Password mismatch',
        'The new passwords do not match.',
      );
      return;
    }

    final success = await widget.controller.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );

    if (!mounted) return;

    if (success) {
      Get.back();
      Get.snackbar('Success', 'Your password has been changed.');
    } else {
      Get.snackbar(
        'Error',
        widget.controller.errorMessage.value,
      );
    }
  }

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomTextField(
          controller: currentPasswordController,
          hintText: 'Current password',
          prefixIcon: Icons.lock_outline,
          obscureText: true,
        ),
        const SizedBox(height: 12),
        CustomTextField(
          controller: newPasswordController,
          hintText: 'New password',
          prefixIcon: Icons.lock_reset,
          obscureText: true,
        ),
        const SizedBox(height: 12),
        CustomTextField(
          controller: confirmPasswordController,
          hintText: 'Confirm new password',
          prefixIcon: Icons.lock_reset,
          obscureText: true,
        ),
      ],
    );
  }
}
