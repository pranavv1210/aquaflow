import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/customer.dart';
import '../../../../core/shared/widgets/error_state_widget.dart';
import '../../../../core/shared/widgets/skeleton_loader.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../application/customer_providers.dart';

class CustomerDropdown extends ConsumerWidget {
  const CustomerDropdown({
    required this.label,
    super.key,
    this.value,
    this.onChanged,
  });

  final Customer? value;
  final ValueChanged<Customer?>? onChanged;
  final String label;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customers = ref.watch(customerListProvider);

    return customers.when(
      data: (List<Customer> items) {
        final sorted = List<Customer>.of(items)..sort(
          (Customer a, Customer b) => a.displayName.toLowerCase().compareTo(
            b.displayName.toLowerCase(),
          ),
        );
        return TextFormField(
          initialValue: value?.displayName ?? '',
          readOnly: true,
          decoration: InputDecoration(
            labelText: label,
            hintText: 'Search customer',
            prefixIcon: const Icon(Icons.person_search_outlined),
          ),
          onTap: () async {
            final selected = await showSearch<Customer?>(
              context: context,
              delegate: _CustomerSearchDelegate(sorted),
            );
            if (selected != null) {
              onChanged?.call(selected);
            }
          },
        );
      },
      error: (Object error, StackTrace stackTrace) {
        return ErrorStateWidget(
          title: 'Unable to load customers',
          message: error.toString(),
          onRetry: () => ref.invalidate(customerListProvider),
        );
      },
      loading: () => const SkeletonLoader(height: 56),
    );
  }
}

class _CustomerSearchDelegate extends SearchDelegate<Customer?> {
  _CustomerSearchDelegate(this.customers);

  final List<Customer> customers;

  @override
  String get searchFieldLabel => 'Search customers';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return <Widget>[
      if (query.isNotEmpty)
        IconButton(
          onPressed: () => query = '',
          icon: const Icon(Icons.close_rounded),
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null),
      icon: const Icon(Icons.arrow_back_rounded),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildCustomerResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildCustomerResults(context);
  }

  Widget _buildCustomerResults(BuildContext context) {
    final normalized = query.trim().toLowerCase();
    final filtered =
        normalized.isEmpty
            ? customers
            : customers
                .where((Customer customer) {
                  return customer.displayName.toLowerCase().contains(
                        normalized,
                      ) ||
                      (customer.phoneNumber?.value.toLowerCase().contains(
                            normalized,
                          ) ??
                          false);
                })
                .toList(growable: false);

    if (filtered.isEmpty) {
      return const Center(child: Text('No matching customers'));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemBuilder: (BuildContext context, int index) {
        final customer = filtered[index];
        return ListTile(
          leading: const CircleAvatar(
            child: Icon(Icons.person_outline_rounded),
          ),
          title: Text(customer.displayName),
          subtitle: Text(customer.phoneNumber?.value ?? 'No phone'),
          onTap: () => close(context, customer),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const Divider();
      },
      itemCount: filtered.length,
    );
  }
}
