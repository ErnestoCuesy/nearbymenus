import 'package:flutter/material.dart';
import 'flavour_config.dart';
import 'package:meta/meta.dart';

class FlavourBanner extends StatelessWidget {

  final Widget child;
  BannerConfig bannerConfig;

  FlavourBanner({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (FlavourConfig.isProduction()) return child;

    bannerConfig ??= _getDefaultBanner();

    return Stack(
      children: <Widget>[
        child,
        _buildBanner(context)
      ],
    );
  }

  BannerConfig _getDefaultBanner() {
    return BannerConfig(
      bannerName: FlavourConfig.instance.name,
      bannerColor: FlavourConfig.instance.bannerColor
    );
  }

  Widget _buildBanner(BuildContext context) {
    return Container(
      width: 50.0,
      height: 50.0,
      child: CustomPaint(
        painter: BannerPainter(
          message: bannerConfig.bannerName,
          textDirection: Directionality.of(context),
          layoutDirection: Directionality.of(context),
          location: BannerLocation.topStart,
          color: bannerConfig.bannerColor
        ),
      ),
    );
  }
}

class BannerConfig {
  final String bannerName;
  final Color bannerColor;

  BannerConfig({@required this.bannerName, @required this.bannerColor});

}
