import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class AppCachedImage extends StatelessWidget {
  const AppCachedImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.headers,
    this.forceRefresh = false,
    this.placeholder,
    this.errorWidget,
    this.backgroundColor = const Color(0xFFF2F2F2),
    this.maxMemCacheSize = 1024,
  });

  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Map<String, String>? headers;
  final bool forceRefresh;
  final Widget? placeholder;
  final Widget? errorWidget;
  final Color backgroundColor;

  /// memCache 最大边长，防止原图解码
  final int maxMemCacheSize;

  @override
  Widget build(BuildContext context) {
    final url = forceRefresh
        ? '$imageUrl?v=${DateTime.now().millisecondsSinceEpoch}'
        : imageUrl;

    return LayoutBuilder(
      builder: (context, constraints) {
        final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;

        final resolvedWidth = _resolveSize(
          width,
          constraints.maxWidth,
          devicePixelRatio,
        );

        // final resolvedHeight = _resolveSize(
        //   height,
        //   constraints.maxHeight,
        //   devicePixelRatio,
        // );

        return CachedNetworkImage(
          imageUrl: url,
          width: width,
          height: height,
          fit: fit,
          fadeInDuration: Duration.zero,
          fadeOutDuration: Duration.zero,
          placeholderFadeInDuration: Duration.zero,
          cacheManager: AdvancedImageCacheManager(),
          httpHeaders: headers,

          ///永远有安全值，防止原图解码
          memCacheWidth: resolvedWidth,
          // memCacheHeight: resolvedHeight,
          placeholder: (_, __) => placeholder ?? SizedBox.shrink(),
          errorWidget: (_, __, ___) => errorWidget ?? _buildError(),
        );
      },
    );
  }

  int? _resolveSize(
    double? explicitSize,
    double constraintSize,
    double devicePixelRatio,
  ) {
    double logicalSize;

    if (explicitSize != null && explicitSize > 0) {
      logicalSize = explicitSize;
    } else if (constraintSize > 0 && constraintSize != double.infinity) {
      logicalSize = constraintSize;
    } else {
      // 无法确定尺寸 → 直接返回 null
      return null;
    }

    final physicalSize = logicalSize * devicePixelRatio;

    final result = physicalSize.clamp(1, maxMemCacheSize.toDouble()).toInt();

    return result;
  }

  Widget _buildError() {
    return Container(
      width: width,
      height: height,
      color: backgroundColor,
      alignment: Alignment.center,
      child: const Icon(
        Icons.broken_image_outlined,
        color: Colors.grey,
        size: 32,
      ),
    );
  }
}

class AdvancedImageCacheManager extends CacheManager {
  static const _key = 'advancedImageCache';

  static final AdvancedImageCacheManager _instance =
      AdvancedImageCacheManager._internal();

  factory AdvancedImageCacheManager() => _instance;

  AdvancedImageCacheManager._internal()
    : super(
        Config(
          _key,
          stalePeriod: const Duration(days: 7),
          maxNrOfCacheObjects: 500,
        ),
      );
}
