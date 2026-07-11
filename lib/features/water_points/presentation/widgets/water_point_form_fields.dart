import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/location.dart';
import '../../../../core/shared/masters/master_validators.dart';
import '../../../../core/shared/widgets/app_dropdown.dart';
import '../../../../core/shared/widgets/app_text_field.dart';
import '../../../../core/shared/widgets/error_state_widget.dart';
import '../../../../core/shared/widgets/form_section.dart';
import '../../../../core/shared/widgets/skeleton_loader.dart';
import '../../../locations/application/location_providers.dart';

class WaterPointFormFields extends ConsumerWidget {
  const WaterPointFormFields({
    required this.nameController,
    required this.locationController,
    required this.notesController,
    super.key,
  });

  final TextEditingController nameController;
  final TextEditingController locationController;
  final TextEditingController notesController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locations = ref.watch(locationListProvider);

    return FormSection(
      title: 'Basic Details',
      children: [
        AppTextField(
          label: 'Water Point Name',
          hintText: 'Required',
          controller: nameController,
          textInputAction: TextInputAction.next,
          validator: (String? value) {
            return MasterValidators.requiredText(
              value,
              fieldName: 'Water point name',
            );
          },
        ),
        switch (locations) {
          AsyncData<List<Location>>(:final value) => AppDropdown<Location>(
            label: 'Location',
            value: _selectedLocation(value),
            items: value,
            itemLabel: (Location location) => location.locationName,
            onChanged: (Location? location) {
              locationController.text = location?.id ?? '';
            },
          ),
          AsyncError<List<Location>>(:final error) => ErrorStateWidget(
            title: 'Unable to load locations',
            message: error.toString(),
            onRetry: () => ref.invalidate(locationListProvider),
          ),
          _ => const SkeletonLoader(height: 56),
        },
        AppTextField(
          label: 'Notes',
          hintText: 'Optional',
          controller: notesController,
          maxLines: 3,
        ),
      ],
    );
  }

  Location? _selectedLocation(List<Location> locations) {
    final selectedId = locationController.text.trim();
    if (selectedId.isEmpty) {
      return null;
    }
    for (final location in locations) {
      if (location.id == selectedId) {
        return location;
      }
    }
    return null;
  }
}
