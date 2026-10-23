import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monisa/app/theme/app_colors.dart';

Widget buildImagePickerThumbnail({
  required Rxn<PlatformFile> newImage,
  required RxnString existingImageUrl,
  required VoidCallback onPick,
  required VoidCallback onRemove,
  double size = 40,
}) {
  return Obx(() {
    final file = newImage.value;
    final url = existingImageUrl.value;
    final hasImage = file != null || (url != null && url.isNotEmpty);

    if (!hasImage) {
      return GestureDetector(
        onTap: onPick,
        child: Icon(Icons.add_photo_alternate_outlined, size: size * 0.55),
      );
    }

    return GestureDetector(
      onTap: onPick, // tap gambar -> ganti gambar
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: size,
            height: size,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.black, width: 1),
            ),
            child: file?.bytes != null
                ? Image.memory(file!.bytes!, fit: BoxFit.cover)
                : Image.network(
                    url!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.broken_image, size: 18),
                  ),
          ),
          Positioned(
            top: -6,
            right: -6,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, size: 12),
              ),
            ),
          ),
        ],
      ),
    );
  });
}