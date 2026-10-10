import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/features/auth/presentation/controllers/auth_controller.dart';
import 'package:flutter_application_1/features/auth/presentation/screens/login_screen.dart';
import 'package:flutter_application_1/features/auth/presentation/widgets/account_tile.dart';
import 'package:flutter_application_1/features/auth/presentation/widgets/change_password_dialog.dart';
import 'package:flutter_application_1/features/auth/presentation/widgets/edit_name_dialog.dart';
import 'package:flutter_application_1/widgets/custom_dialog.dart';
import 'package:flutter_application_1/widgets/primary_button.dart';
import 'package:get/get.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Obx(() {
          final user = controller.user;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'More',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: AppColors.darkText,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Manage your account',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.secondaryText,
                  ),
                ),
                const SizedBox(height: 28),

                // Profile
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 88,
                        height: 88,
                        decoration: const BoxDecoration(
                          color: AppColors.lightGreen,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.person_outline,
                          size: 48,
                          color: AppColors.green,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        user?.name ?? 'User',
                        style: const TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w700,
                          color: AppColors.darkText,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user?.email ?? '',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                _sectionTitle('ACCOUNT'),
                const SizedBox(height: 12),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      AccountTile(
                        icon: Icons.person_outline,
                        title: 'Full Name',
                        subtitle: 'Edit your name',
                        onTap: () => showEditNameDialog(
                          context: context,
                          controller: controller,
                          currentName: user?.name ?? '',
                        ),
                      ),
                      const Divider(height: 24),
                      AccountTile(
                        icon: Icons.email_outlined,
                        title: 'Email Address',
                        subtitle: user?.email ?? 'Not available',
                        trailing: const Icon(
                          Icons.lock_outline,
                          color: AppColors.secondaryText,
                          size: 20,
                        ),
                      ),
                      const Divider(height: 24),
                      AccountTile(
                        icon: Icons.lock_outline,
                        title: 'Password',
                        subtitle: 'Change your password',
                        onTap: () => showChangePasswordDialog(
                          context: context,
                          controller: controller,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                Obx(
                  () => PrimaryButton(
                    text: controller.isLoading.value
                        ? 'Please wait...'
                        : 'Log Out',
                    height: 54,
                    backgroundColor: Colors.red.shade50,
                    foregroundColor: Colors.red,
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                    onPressed: controller.isLoading.value
                        ? null
                        : () => _confirmLogout(controller),
                  ),
                ),

                const SizedBox(height: 24),

                const Center(
                  child: Text(
                    'TripSplit • Better trips, fairer bills.',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: AppColors.secondaryText,
        letterSpacing: 1,
      ),
    );
  }

  void _confirmLogout(AuthController controller) {
    customDialog(
      context: Get.context!,
      title: 'Log out?',
      content: const Text(
        'Are you sure you want to log out of your account?',
      ),
      actions: [
        TextButton(
          onPressed: () async {
            final success = await controller.logout();

            if (success) {
              Get.offAll(() => const LoginScreen());
            } else {
              Get.back();
              Get.snackbar(
                'Logout failed',
                controller.errorMessage.value,
              );
            }
          },
          child: const Text(
            'Log Out',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }
}
