import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../result/result.dart';

typedef MasterRepositoryReader<TRepository> = TRepository Function(Ref ref);

FutureProvider<List<TItem>> createMasterListProvider<TItem, TRepository>({
  required Provider<TRepository> repositoryProvider,
  required Future<Result<List<TItem>>> Function(TRepository repository) load,
}) {
  return FutureProvider.autoDispose<List<TItem>>((Ref ref) async {
    final result = await load(ref.watch(repositoryProvider));
    return result.getOrThrow();
  });
}

createMasterSearchProvider<TItem, TRepository>({
  required Provider<TRepository> repositoryProvider,
  required Future<Result<List<TItem>>> Function(
    TRepository repository,
    String query,
  )
  search,
}) {
  return FutureProvider.autoDispose.family<List<TItem>, String>((
    Ref ref,
    String query,
  ) async {
    final result = await search(ref.watch(repositoryProvider), query);
    return result.getOrThrow();
  });
}

createSelectedMasterProvider<TItem, TRepository>({
  required Provider<TRepository> repositoryProvider,
  required Future<Result<TItem>> Function(TRepository repository, String id)
  load,
}) {
  return FutureProvider.autoDispose.family<TItem, String>((
    Ref ref,
    String id,
  ) async {
    final result = await load(ref.watch(repositoryProvider), id);
    return result.getOrThrow();
  });
}
