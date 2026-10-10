import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/auth/presentation/controllers/auth_controller.dart';
import 'package:flutter_application_1/widgets/custom_dialog.dart';
import 'package:flutter_application_1/widgets/custom_text_field.dart';
import 'package:get/get.dart';

void showEditNameDialog({
  required BuildContext context,
  required AuthController controller,
  required String currentName,
}) {
  final nameController = TextEditingController(text: currentName);

  customDialog(
    context: context,
    title: 'Edit name',
    content: CustomTextField(
      controller: nameController,
      hintText: 'Full name',
      prefixIcon: Icons.person_outline,
    ),
    actions: [
      Obx(
        () => TextButton(
          onPressed: controller.isLoading.value
              ? null
              : () async {
                  final name = nameController.text.trim();

                  if (name.isEmpty) {
                    Get.snackbar(
                      'Invalid name',
                      'Please enter your name.',
                    );
                    return;
                  }

                  final success = await controller.updateProfile(
                    name: name,
                  );

                  if (success) {
                    Get.back();
                    Get.snackbar(
                      'Success',
                      'Your name has been updated.',
                    );
                  } else {
                    Get.snackbar(
                      'Error',
                      controller.errorMessage.value,
                    );
                  }
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
