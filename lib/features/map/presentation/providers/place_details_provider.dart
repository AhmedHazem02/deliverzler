import '../../../../core/presentation/providers/provider_utils.dart';
import '../../../../core/presentation/utils/fp_framework.dart';
import '../../../../core/presentation/utils/riverpod_framework.dart';
import '../../domain/place_autocomplete.dart';
import '../../domain/place_details.dart';
import '../../infrastructure/repos/map_repo.dart';
import 'session_token_provider.dart';

part 'place_details_provider.g.dart';

@riverpod
Option<PlaceDetails> currentPlaceDetails(Ref ref) {
  final selectedPlaceId = ref.watch(
    selectedPlaceAutocompleteProvider.select(
      (value) => value.match<Option<String>>(
        () => const None(),
        (autocomplete) => Some(autocomplete.placeId),
      ),
    ),
  );

  return selectedPlaceId.flatMap(
    (placeId) =>
        ref.watch(getPlaceDetailsProvider(placeId).select(valueToOption)),
  );
}

@riverpod
class SelectedPlaceAutocomplete extends _$SelectedPlaceAutocomplete {
  @override
  Option<PlaceAutocomplete> build() => const None();

  void update(
      Option<PlaceAutocomplete> Function(Option<PlaceAutocomplete> state) fn) {
    state = fn(state);
  }
}

@riverpod
Future<PlaceDetails> getPlaceDetails(
  Ref ref,
  String placeId,
) async {
  ref.listenSelf((previous, next) {
    if (next is AsyncData) {
      ref.invalidate(sessionTokenProvider);
    }
  });

  final cancelToken = ref.cancelToken();

  final placeDetails = await ref
      .watch(mapRepoProvider)
      .getPlaceDetails(placeId, cancelToken: cancelToken);
  return placeDetails;
}
