import 'package:flutter/material.dart';

import '../core/avatars_data.dart';
import '../theme/app_colors.dart';
import '../theme/app_palette.dart';

/// A gradient-circle stand-in for an avatar's full inline-SVG emblem (see
/// AvatarInfo's doc comment) - shows the avatar's identity colors and its
/// first Hebrew letter.
class AvatarCircle extends StatelessWidget {
  const AvatarCircle({super.key, required this.avatar, this.size = 56, this.locked = false});

  final AvatarInfo avatar;
  final double size;
  final bool locked;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: avatar.colors),
        // A white ring lifts the saturated circle off the light page, the
        // way the avatars in the reference apps are ringed.
        border: Border.all(color: context.palette.panelLight, width: 2.5),
        boxShadow: context.palette.shadowSm,
      ),
      child: Center(
        child: locked
            ? Icon(Icons.lock, color: AppColors.textLight.withValues(alpha: 0.85), size: size * 0.4)
            : Text(
                avatar.name[0],
                style: TextStyle(
                  fontFamily: 'Rubik',
                  fontWeight: FontWeight.w800,
                  fontSize: size * 0.4,
                  color: AppColors.textLight,
                ),
              ),
      ),
    );
  }
}
