import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:logging/logging.dart';

import '../../../gen/my_assets.dart';
import '../../infrastructure/services/cache_service.dart';
import '../utils/riverpod_framework.dart';

void _reportImageError(WidgetRef ref, Object error) {
  // You can also report to Crashlytics as non-fatal error.
  Logger.root.severe(error, StackTrace.current);
}

class CachedNetworkImageCircular extends ConsumerWidget {
  const CachedNetworkImageCircular({
    required this.imageUrl,
    required this.radius,
    this.spareImageUrl = '', // Use empty string, will fall back to local asset
    this.maxHeightDiskCache = 400,
    this.maxWidthDiskCache = 400,
    super.key,
  });
  final String? imageUrl;
  final String spareImageUrl;
  final double radius;
  final int? maxHeightDiskCache;
  final int? maxWidthDiskCache;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cacheService = ref.watch(cacheServiceProvider);

    return CachedNetworkImage(
      cacheManager: cacheService.customCacheManager,
      errorListener: (error) {
        _reportImageError(ref, error);
      },
      imageUrl: (imageUrl != null && imageUrl!.contains('http'))
          ? imageUrl!
          : (spareImageUrl.isNotEmpty && spareImageUrl.contains('http'))
              ? spareImageUrl
              : 'https://via.placeholder.com/150',
      imageBuilder: (context, imageProvider) => CircleAvatar(
        radius: radius,
        backgroundImage: imageProvider,
      ),
      placeholder: (context, url) => CircleAvatar(
        radius: radius,
        backgroundImage:
            const AssetImage(MyAssets.ASSETS_IMAGES_CORE_LOADING_GIF),
      ),
      errorWidget: (context, url, error) => CircleAvatar(
        radius: radius,
        backgroundImage:
            const AssetImage(MyAssets.ASSETS_IMAGES_CORE_NO_INTERNET_PNG),
      ),
    );
  }
}
