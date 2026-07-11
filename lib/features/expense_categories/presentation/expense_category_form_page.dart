import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/application/navigation_providers.dart';
import '../../../core/models/expense_category.dart';
import '../../../core/shared/masters/base_master_form.dart';
import '../../../core/shared/masters/master_dialogs.dart';
import '../../../core/shared/widgets/app_screen.dart';
import '../../../core/shared/widgets/error_state_widget.dart';
import '../../../core/shared/widgets/page_header.dart';
import '../application/expense_category_providers.dart';
import '../domain/expense_category_input.dart';
import 'widgets/expense_category_form_fields.dart';
import 'widgets/expense_category_list_skeleton.dart';

class ExpenseCategoryFormPage extends ConsumerStatefulWidget {
  const ExpenseCategoryFormPage({super.key, this.expenseCategoryId});
  final String? expenseCategoryId;
  @override
  ConsumerState<ExpenseCategoryFormPage> createState() =>
      _ExpenseCategoryFormPageState();
}

class _ExpenseCategoryFormPageState
    extends ConsumerState<ExpenseCategoryFormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isSaving = false, _didPopulate = false;
  bool get _isEditing => widget.expenseCategoryId != null;

  @override
  void dispose() {
    _nameController.dispose();
    _typeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isEditing) return _buildForm();
    final ec = ref.watch(
      selectedExpenseCategoryProvider(widget.expenseCategoryId!),
    );
    return switch (ec) {
      AsyncData<ExpenseCategory>(:final value) => () {
        _populateOnce(value);
        return _buildForm();
      }(),
      AsyncError<ExpenseCategory>(:final error) => AppScreen(
        children: [
          const PageHeader(title: 'Edit Category', subtitle: 'Error'),
          ErrorStateWidget(
            title: 'Unable to load category',
            message: error.toString(),
            onRetry:
                () => ref.invalidate(
                  selectedExpenseCategoryProvider(widget.expenseCategoryId!),
                ),
          ),
        ],
      ),
      _ => const AppScreen(
        children: [
          PageHeader(title: 'Edit Category', subtitle: 'Loading...'),
          ExpenseCategoryListSkeleton(),
        ],
      ),
    };
  }

  Widget _buildForm() => BaseMasterForm(
    formKey: _formKey,
    title: _isEditing ? 'Edit Category' : 'Add Category',
    subtitle: _isEditing ? 'Update category details' : 'Create category',
    saveLabel: _isEditing ? 'Update Category' : 'Save Category',
    isSaving: _isSaving,
    onSave: _save,
    onCancel: _confirmCancel,
    children: [
      ExpenseCategoryFormFields(
        nameController: _nameController,
        typeController: _typeController,
        descriptionController: _descriptionController,
      ),
    ],
  );

  Future<void> _confirmCancel() async {
    if (_hasChanges) {
      final d = await MasterDialogs.confirmDiscard(context);
      if (!d) return;
    }
    _leaveForm();
  }

  bool get _hasChanges =>
      _nameController.text.trim().isNotEmpty ||
      _typeController.text.trim().isNotEmpty ||
      _descriptionController.text.trim().isNotEmpty;
  void _populateOnce(ExpenseCategory ec) {
    if (_didPopulate) return;
    _nameController.text = ec.categoryName;
    _typeController.text = ec.expenseType;
    _descriptionController.text = ec.description ?? '';
    _didPopulate = true;
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isSaving = true);
    final input = ExpenseCategoryInput(
      categoryName: _nameController.text,
      expenseType: _typeController.text,
      description: _descriptionController.text,
    );
    await saveExpenseCategoryProviders(
      ref,
      expenseCategoryId: widget.expenseCategoryId,
      input: input,
      onSuccess: (ExpenseCategory saved) {
        if (!mounted) return;
        MasterDialogs.showSaved(
          context,
          _isEditing ? 'Category updated' : 'Category added',
        );
        _leaveForm(savedExpenseCategoryId: saved.id);
      },
      onFailure: (msg) {
        if (mounted) MasterDialogs.showError(context, msg);
      },
    );
    if (mounted) setState(() => _isSaving = false);
  }

  void _leaveForm({String? savedExpenseCategoryId}) {
    final nav = ref.read(navigationServiceProvider);
    if (_isEditing) {
      nav.goToExpenseCategoryProfile(
        context,
        savedExpenseCategoryId ?? widget.expenseCategoryId!,
      );
      return;
    }
    nav.goToExpenseCategories(context);
  }
}
