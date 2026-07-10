import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/application/navigation_providers.dart';
import '../../../core/models/customer.dart';
import '../../../core/shared/masters/base_master_page.dart';
import '../application/customer_providers.dart';
import 'widgets/customer_card.dart';
import 'widgets/customer_list_skeleton.dart';

class CustomersPage extends ConsumerWidget {
  const CustomersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navigation = ref.watch(navigationServiceProvider);

    return BaseMasterPage<Customer>(
      title: 'Customers',
      subtitle: 'Customer master',
      searchLabel: 'Search customers',
      emptyTitle: 'No Customers Yet',
      emptyMessage: 'Add your first customer to reuse them in orders.',
      emptyIcon: Icons.people_outline_rounded,
      onAdd: () => navigation.goToCustomerForm(context),
      loadItems: (WidgetRef ref, String query) {
        return query.isEmpty
            ? ref.watch(customerListProvider)
            : ref.watch(customerSearchProvider(query));
      },
      buildLoading: CustomerListSkeleton.new,
      onRefresh: (WidgetRef ref, String query) async {
        if (query.isEmpty) {
          ref.invalidate(customerListProvider);
        } else {
          ref.invalidate(customerSearchProvider(query));
        }
        await Future<void>.delayed(const Duration(milliseconds: 250));
      },
      buildItem: (BuildContext context, Customer customer) {
        return CustomerCard(
          customer: customer,
          onTap: () => navigation.goToCustomerProfile(context, customer.id),
        );
      },
    );
  }
}
