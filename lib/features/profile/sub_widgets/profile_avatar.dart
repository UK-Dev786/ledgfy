import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text.dart';
import '../../../core/widgets/my_text.dart';
import '../../../core/widgets/shared_bottom_sheet.dart';

class ProfileAvatar extends StatelessWidget {
  final String initials;
  final File? imageFile;
  final ValueChanged<File?> onImageChanged;

  const ProfileAvatar({
    super.key,
    required this.initials,
    required this.imageFile,
    required this.onImageChanged,
  });

  static String initialsFromName(String? name, {String fallback = '?'}) {
    final trimmed = name?.trim();
    if (trimmed == null || trimmed.isEmpty) return fallback;

    final parts = trimmed.split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return parts.first[0].toUpperCase();
  }

  Future<void> _openPhotoSheet(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => SharedBottomSheet(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const MyText(
              AppText.profileEditPhoto,
              font: AppFont.inter,
              size: AppSizes.title,
              color: AppColors.white,
              weight: FontWeight.w700,
              align: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.lg),
            _PhotoOptionTile(
              icon: Icons.photo_library_outlined,
              label: AppText.profileChooseGallery,
              onTap: () async {
                Navigator.of(ctx).pop();
                final picker = ImagePicker();
                final file = await picker.pickImage(
                  source: ImageSource.gallery,
                  imageQuality: 85,
                  maxWidth: 1024,
                );
                if (file != null) {
                  onImageChanged(File(file.path));
                }
              },
            ),
            if (imageFile != null) ...[
              const SizedBox(height: AppSizes.sm),
              _PhotoOptionTile(
                icon: Icons.delete_outline_rounded,
                label: AppText.profileRemovePhoto,
                color: AppColors.error,
                onTap: () {
                  Navigator.of(ctx).pop();
                  onImageChanged(null);
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 104,
          height: 104,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.35),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.15),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipOval(
            child: imageFile != null
                ? Image.file(
                    imageFile!,
                    fit: BoxFit.cover,
                    width: 104,
                    height: 104,
                  )
                : ColoredBox(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    child: Center(
                      child: MyText(
                        initials,
                        font: AppFont.inter,
                        size: AppSizes.header2,
                        color: AppColors.primary,
                        weight: FontWeight.bold,
                      ),
                    ),
                  ),
          ),
        ),
        Positioned(
          right: -2,
          bottom: -2,
          child: Material(
            color: AppColors.primary,
            shape: const CircleBorder(),
            elevation: 4,
            shadowColor: AppColors.primary.withValues(alpha: 0.4),
            child: InkWell(
              onTap: () => _openPhotoSheet(context),
              customBorder: const CircleBorder(),
              child: const Padding(
                padding: EdgeInsets.all(8),
                child: Icon(
                  Icons.edit_rounded,
                  color: AppColors.white,
                  size: AppSizes.iconSm,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PhotoOptionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;

  const _PhotoOptionTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white.withValues(alpha: 0.05),
      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.md,
            vertical: AppSizes.md,
          ),
          child: Row(
            children: [
              Icon(icon, color: color, size: AppSizes.iconMd),
              const SizedBox(width: AppSizes.md),
              Expanded(
                child: MyText(
                  label,
                  font: AppFont.sourceSans,
                  size: AppSizes.body,
                  color: color == AppColors.error
                      ? AppColors.error
                      : AppColors.white,
                  weight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
