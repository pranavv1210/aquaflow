import '../../errors/app_failure.dart';
import '../../result/result.dart';
import 'master_repository.dart';

class StaticMasterRepository<TItem, TInput>
    implements MasterRepository<TItem, TInput> {
  const StaticMasterRepository({
    required this.items,
    required this.matches,
    required this.idOf,
    required this.moduleName,
  });

  final List<TItem> items;
  final bool Function(TItem item, String query) matches;
  final String Function(TItem item) idOf;
  final String moduleName;

  @override
  Future<Result<List<TItem>>> getItems() async => Success<List<TItem>>(items);

  @override
  Future<Result<TItem>> getItemById(String id) async {
    final matches = items.where((TItem item) => idOf(item) == id);
    if (matches.isEmpty) {
      return Failure<TItem>(DatabaseFailure(message: '$moduleName not found.'));
    }
    return Success<TItem>(matches.first);
  }

  @override
  Future<Result<TItem>> createItem(TInput input) async {
    return Failure<TItem>(
      DatabaseFailure(message: '$moduleName is not connected yet.'),
    );
  }

  @override
  Future<Result<TItem>> updateItem(String id, TInput input) async {
    return Failure<TItem>(
      DatabaseFailure(message: '$moduleName is not connected yet.'),
    );
  }

  @override
  Future<Result<void>> softDeleteItem(String id) async {
    return Failure<void>(
      DatabaseFailure(message: '$moduleName is not connected yet.'),
    );
  }

  @override
  Future<Result<List<TItem>>> searchItems(String query) async {
    final normalized = query.trim();
    if (normalized.isEmpty) {
      return Success<List<TItem>>(items);
    }
    final results = items
        .where((TItem item) => matches(item, normalized))
        .toList(growable: false);
    return Success<List<TItem>>(results);
  }
}
