import '../../../../../core/presentation/providers/provider_utils.dart';
import '../../../../../core/presentation/utils/fp_framework.dart';
import '../../../../../core/presentation/utils/riverpod_framework.dart';
import '../../../../home/presentation/providers/location_stream_provider.dart';
import '../../../domain/place_directions.dart';
import '../../../infrastructure/repos/map_repo.dart';
import 'target_location_geo_point_provider.dart';

part 'target_location_directions_provider.g.dart';

@riverpod
Option<PlaceDirections> targetLocationDirections(
  Ref ref,
) {
  final asyncValue = ref.watch(getTargetLocationDirectionsProvider);

  return asyncValue.maybeWhen(
    skipError: true,
    skipLoadingOnReload: true,
    skipLoadingOnRefresh: true,
    data: Some.new,
    orElse: () => const None(),
  );
}

@riverpod
Future<PlaceDirections> getTargetLocationDirections(
  Ref ref,
) async {
  final myLocation =
      ref.watch(locationStreamProvider.select((value) => value.valueOrNull));
  if (myLocation == null) throw AbortedException();

  final targetLocationOpt = ref.watch(targetLocationGeoPointProvider);
  final targetLocation = targetLocationOpt.getOrElse(() {
    throw AbortedException();
  });

  final cancelToken = ref.cancelToken();
  final query = PlaceDirectionsQuery(
    origin: myLocation,
    destination: targetLocation,
  );

  return ref
      .watch(mapRepoProvider)
      .getPlaceDirections(query, cancelToken: cancelToken);
}
