import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/controllers/main_controller.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/features/auth/presentation/screens/account_screen.dart';
import 'package:flutter_application_1/features/trips/presentation/screens/add_trip_screen.dart';
import 'package:flutter_application_1/features/trips/presentation/screens/home_screen.dart';
import 'package:flutter_application_1/features/trips/presentation/screens/trips_screen.dart';
import 'package:flutter_application_1/widgets/bottom_nav.dart';
import 'package:get/get.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MainController>();

    final pages = [
      const HomeScreen(),
      const TripsScreen(),
      const AddTripScreen(),
      const AccountScreen(),
    ];

    return Obx(() {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: pages[controller.currentIndex.value],
        ),
        bottomNavigationBar: BottomNav(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changeTab,
        ),
      );
    });
  }
}
