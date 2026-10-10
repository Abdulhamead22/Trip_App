import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/controllers/main_controller.dart';
import 'package:get/get.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/features/participants/domain/entities/participant.dart';
import 'package:flutter_application_1/features/trips/domain/entities/trip.dart';
import 'package:flutter_application_1/features/trips/presentation/controllers/trip_controller.dart';
import 'package:flutter_application_1/widgets/custom_dialog.dart';
import 'package:flutter_application_1/widgets/custom_dropdown.dart';
import 'package:flutter_application_1/widgets/custom_text_field.dart';
import 'package:flutter_application_1/widgets/primary_button.dart';

class AddTripScreen extends StatefulWidget {
  const AddTripScreen({super.key});

  @override
  State<AddTripScreen> createState() => _AddTripScreenState();
}

class _AddTripScreenState extends State<AddTripScreen> {
  final TripController tripController = Get.find<TripController>();

  final nameController = TextEditingController();
  final memberController = TextEditingController();

  final List<String> members = [];

  String currency = '₪';
  String? nameError;
  String? participantError;

  @override
  void dispose() {
    nameController.dispose();
    memberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final avatarColors = [
      AppColors.avatarGreen,
      AppColors.avatarPurple,
      AppColors.avatarOrange,
      AppColors.avatarRed,
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Create Trip',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.mutedText,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Create Trip',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: AppColors.darkText,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            height: 160,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.cardGreen,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(
              child: Icon(
                Icons.auto_awesome,
                size: 54,
                color: AppColors.iconGreen,
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Text(
              'Trip name',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.secondaryText,
              ),
            ),
          ),
          CustomTextField(
            controller: nameController,
            hintText: 'Name',
            errorText: nameError,
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Text(
              'Currency',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.secondaryText,
              ),
            ),
          ),
          CustomDropdown(
            value: currency,
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  currency = value;
                });
              }
            },
            items: const [
              DropdownMenuItem(
                value: '₪',
                child: Text('₪ Israeli Shekel'),
              ),
              DropdownMenuItem(
                value: '\$',
                child: Text('\$ US Dollar'),
              ),
              DropdownMenuItem(
                value: '€',
                child: Text('€ Euro'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Participants',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.secondaryText,
                ),
              ),
              TextButton(
                onPressed: _showAddParticipantDialog,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                ),
                child: const Text(
                  '+ Add',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.green,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: members.length,
            itemBuilder: (context, index) {
              return _buildMemberCard(
                members[index],
                avatarColors,
                index,
              );
            },
          ),
          const SizedBox(height: 24),
          Obx(
            () => PrimaryButton(
              text: tripController.isLoading.value
                  ? 'Creating...'
                  : 'Create Trip',
              onPressed: tripController.isLoading.value ? null : _createTrip,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddParticipantDialog() {
    customDialog(
      context: context,
      title: 'Add participant',
      content: CustomTextField(
        controller: memberController,
        hintText: 'Name',
        errorText: participantError,
      ),
      actions: [
        FilledButton(
          onPressed: () {
            final name = memberController.text.trim();

            if (name.isEmpty) {
              setState(() {
                participantError = 'Please enter a name.';
              });
              return;
            }

            if (members.contains(name)) {
              setState(() {
                participantError = 'This participant already exists.';
              });
              return;
            }

            setState(() {
              members.add(name);
              memberController.clear();
              participantError = null;
            });

            Navigator.pop(context);
          },
          child: const Text('Add'),
        ),
      ],
    );
  }

  Future<void> _createTrip() async {
    final name = nameController.text.trim();

    setState(() {
      nameError = name.isEmpty ? 'Please enter a trip name.' : null;
    });

    if (name.isEmpty) {
      return;
    }

    if (members.isEmpty) {
      Get.snackbar(
        'Participants required',
        'Please add at least one participant.',
      );
      return;
    }

    final participants = members.map((name) {
      return Participant(
        id: '',
        name: name,
      );
    }).toList();

    final trip = Trip(
      id: '',
      ownerId: '',
      name: name,
      currency: currency,
      createdAt: DateTime.now(),
      participants: participants,
      expenses: const [],
    );

    final success = await tripController.createTrip(trip);

    if (!success) {
      return;
    }

    final mainController = Get.find<MainController>();

    mainController.changeTab(
      MainController.tripsIndex,
    );
  }

  Widget _buildMemberCard(
    String name,
    List<Color> avatarColors,
    int index,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.background.withOpacity(0.5),
        ),
      ),
      child: ListTile(
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        leading: Text(
          name.isNotEmpty ? name[0] : '',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: avatarColors[index % avatarColors.length],
          ),
        ),
        title: Text(
          name,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.darkText,
          ),
        ),
        trailing: GestureDetector(
          onTap: () {
            setState(() {
              members.removeAt(index);
            });
          },
          child: const Icon(
            Icons.close_rounded,
            size: 18,
            color: AppColors.mutedText,
          ),
        ),
      ),
    );
  }
}
