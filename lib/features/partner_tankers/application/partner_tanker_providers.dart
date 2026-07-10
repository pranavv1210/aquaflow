import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/application/use_case.dart';
import '../../../core/models/partner_tanker.dart';
import '../../../core/services/supabase_providers.dart';
import '../../../core/shared/masters/master_providers.dart';
import '../data/repositories/supabase_partner_tanker_repository.dart';
import '../domain/partner_tanker_input.dart';
import '../domain/repositories/partner_tanker_repository.dart';
import 'partner_tanker_validation_service.dart';
import 'use_cases/partner_tanker_use_cases.dart';

final partnerTankerRepositoryProvider = Provider<PartnerTankerRepository>((ref) => SupabasePartnerTankerRepository(ref.watch(supabaseClientProvider)));
final partnerTankerValidationServiceProvider = Provider<PartnerTankerValidationService>((ref) => const PartnerTankerValidationService());
final getPartnerTankersUseCaseProvider = Provider<GetPartnerTankersUseCase>((ref) => GetPartnerTankersUseCase(ref.watch(partnerTankerRepositoryProvider)));
final getPartnerTankerUseCaseProvider = Provider<GetPartnerTankerUseCase>((ref) => GetPartnerTankerUseCase(ref.watch(partnerTankerRepositoryProvider)));
final searchPartnerTankersUseCaseProvider = Provider<SearchPartnerTankersUseCase>((ref) => SearchPartnerTankersUseCase(ref.watch(partnerTankerRepositoryProvider)));
final createPartnerTankerUseCaseProvider = Provider<CreatePartnerTankerUseCase>((ref) => CreatePartnerTankerUseCase(ref.watch(partnerTankerRepositoryProvider), ref.watch(partnerTankerValidationServiceProvider)));
final updatePartnerTankerUseCaseProvider = Provider<UpdatePartnerTankerUseCase>((ref) => UpdatePartnerTankerUseCase(ref.watch(partnerTankerRepositoryProvider), ref.watch(partnerTankerValidationServiceProvider)));
final deletePartnerTankerUseCaseProvider = Provider<DeletePartnerTankerUseCase>((ref) => DeletePartnerTankerUseCase(ref.watch(partnerTankerRepositoryProvider)));
final refreshPartnerTankersUseCaseProvider = Provider<RefreshPartnerTankersUseCase>((ref) => const RefreshPartnerTankersUseCase());

final partnerTankerListProvider = createMasterListProvider<PartnerTanker, GetPartnerTankersUseCase>(repositoryProvider: getPartnerTankersUseCaseProvider, load: (u) => u());
final partnerTankerSearchProvider = createMasterSearchProvider<PartnerTanker, SearchPartnerTankersUseCase>(repositoryProvider: searchPartnerTankersUseCaseProvider, search: (u, q) => u(q));
final selectedPartnerTankerProvider = createSelectedMasterProvider<PartnerTanker, GetPartnerTankerUseCase>(repositoryProvider: getPartnerTankerUseCaseProvider, load: (u, id) => u(id));

Future<void> refreshPartnerTankerProviders(WidgetRef ref) async { await ref.read(refreshPartnerTankersUseCaseProvider)(); ref.invalidate(partnerTankerListProvider); }

Future<void> savePartnerTankerProviders(WidgetRef ref, {required String? partnerTankerId, required PartnerTankerInput input, required void Function(PartnerTanker) onSuccess, required void Function(String) onFailure}) async {
  final result = partnerTankerId == null ? await ref.read(createPartnerTankerUseCaseProvider)(input) : await ref.read(updatePartnerTankerUseCaseProvider)(UpdateParams<PartnerTankerInput>(id: partnerTankerId, input: input));
  result.when(success: (pt) { ref.invalidate(partnerTankerListProvider); ref.invalidate(selectedPartnerTankerProvider(pt.id)); onSuccess(pt); }, failure: (f) => onFailure(f.message));
}
