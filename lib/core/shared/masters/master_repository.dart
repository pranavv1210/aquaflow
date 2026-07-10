import '../../result/result.dart';

abstract interface class MasterRepository<TItem, TInput> {
  Future<Result<List<TItem>>> getItems();

  Future<Result<TItem>> getItemById(String id);

  Future<Result<TItem>> createItem(TInput input);

  Future<Result<TItem>> updateItem(String id, TInput input);

  Future<Result<void>> softDeleteItem(String id);

  Future<Result<List<TItem>>> searchItems(String query);
}
