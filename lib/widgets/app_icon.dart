import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../core/icons_data.dart';

/// Renders one of the game's inline SVG icons (icons.js). Monochrome icons
/// use "currentColor" in their source, which isn't a real SVG color value -
/// [color] is substituted directly into the SVG source per instance, rather
/// than via a ColorFilter, so icons that bake in their own colors (coin,
/// diamond) can be used unmodified by simply omitting it.
class AppIcon extends StatelessWidget {
  const AppIcon(this.name, {super.key, this.size = 24, this.color});

  final String name;
  final double size;
  final Color? color;

  static String _hex(Color c) {
    final argb = c.toARGB32();
    return '#${(argb & 0xFFFFFF).toRadixString(16).padLeft(6, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final raw = kIconSvgs[name] ?? '';
    final svg = color == null ? raw : raw.replaceAll('currentColor', _hex(color!));
    return SvgPicture.string(svg, width: size, height: size);
  }
}
