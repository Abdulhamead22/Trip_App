import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;

  final ValueChanged<int> onTap;

  const BottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const labels = [
      'Home',
      'Trips',
      'Add',
      'More',
    ];

    const icons = [
      Icons.home_outlined,
      Icons.work_outline,
      Icons.add,
      Icons.more_horiz,
    ];

    return Container(
      height: 60,
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(
          top: BorderSide(
            color: AppColors.border,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
          labels.length,
          (index) {
            final selected = currentIndex == index;

            return InkWell(
              onTap: () => onTap(index),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icons[index],
                    size: 20,
                    color: selected ? AppColors.green : AppColors.mutedText,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    labels[index],
                    style: TextStyle(
                      fontSize: 14,
                      color: selected ? AppColors.green : AppColors.mutedText,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
