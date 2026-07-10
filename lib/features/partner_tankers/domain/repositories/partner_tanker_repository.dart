import '../../../../core/models/partner_tanker.dart';
import '../../../../core/result/result.dart';
import '../partner_tanker_input.dart';

abstract interface class PartnerTankerRepository {
  Future<Result<List<PartnerTanker>>> getPartnerTankers();
  Future<Result<PartnerTanker>> getPartnerTankerById(String id);
  Future<Result<PartnerTanker>> createPartnerTanker(PartnerTankerInput input);
  Future<Result<PartnerTanker>> updatePartnerTanker(
    String id,
    PartnerTankerInput input,
  );
  Future<Result<void>> softDeletePartnerTanker(String id);
  Future<Result<List<PartnerTanker>>> searchPartnerTankers(String query);
}
