import 'dart:typed_data';

import 'package:flutter/material.dart';

/// Shows the user's profile photo when [photo] is set, otherwise falls back
/// to a colored circle with their initials. Used on the home header, the
/// desktop sidebar, and the profile screen so all three stay in sync.
class UserAvatar extends StatelessWidget {
  final Uint8List? photo;
  final String initials;
  final double radius;
  final Color background;
  final Color foreground;
  final double? fontSize;

  const UserAvatar({
    super.key,
    required this.photo,
    required this.initials,
    required this.background,
    required this.foreground,
    this.radius = 18,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final photoBytes = photo;
    return CircleAvatar(
      radius: radius,
      backgroundColor: background,
      backgroundImage: photoBytes != null ? MemoryImage(photoBytes) : null,
      child: photoBytes != null
          ? null
          : Text(
              initials,
              style: TextStyle(
                color: foreground,
                fontWeight: FontWeight.w800,
                fontSize: fontSize ?? radius * 0.8,
              ),
            ),
    );
  }
}
