import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/shared/masters/master_list_item.dart';
import '../../../core/shared/masters/master_providers.dart';
import '../../../core/shared/masters/static_master_repository.dart';
import '../data/repositories/partner_tanker_repository.dart';

final partnerTankerRepositoryProvider = Provider<PartnerTankerRepository>((
  ref,
) {
  return _StaticPartnerTankerRepository();
});

final partnerTankerListProvider =
    createMasterListProvider<MasterListItem, PartnerTankerRepository>(
      repositoryProvider: partnerTankerRepositoryProvider,
      load: (PartnerTankerRepository repository) => repository.getItems(),
    );

final partnerTankerSearchProvider =
    createMasterSearchProvider<MasterListItem, PartnerTankerRepository>(
      repositoryProvider: partnerTankerRepositoryProvider,
      search: (PartnerTankerRepository repository, String query) {
        return repository.searchItems(query);
      },
    );

final selectedPartnerTankerProvider =
    createSelectedMasterProvider<MasterListItem, PartnerTankerRepository>(
      repositoryProvider: partnerTankerRepositoryProvider,
      load: (PartnerTankerRepository repository, String id) {
        return repository.getItemById(id);
      },
    );

class _StaticPartnerTankerRepository
    extends StaticMasterRepository<MasterListItem, Object>
    implements PartnerTankerRepository {
  _StaticPartnerTankerRepository()
    : super(
        items: const <MasterListItem>[],
        moduleName: 'Partner Tankers',
        idOf: (MasterListItem item) => item.id,
        matches: (MasterListItem item, String query) {
          final normalized = query.toLowerCase();
          return item.title.toLowerCase().contains(normalized) ||
              item.subtitle.toLowerCase().contains(normalized);
        },
      );
}
