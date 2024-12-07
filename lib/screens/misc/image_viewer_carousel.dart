import 'dart:io';

import 'package:flutter/material.dart';
import 'package:park_in/components/theme/color_scheme.dart';

class ImageViewerCarousel extends StatefulWidget {
  final File? currentImage;
  final File? closeUpImage;
  final File? midShotImage;
  final File? wideShotImage;

  const ImageViewerCarousel({
    required this.currentImage,
    required this.closeUpImage,
    required this.midShotImage,
    required this.wideShotImage,
    super.key,
  });

  @override
  _ImageViewerCarouselState createState() => _ImageViewerCarouselState();
}

class _ImageViewerCarouselState extends State<ImageViewerCarousel> {
  late File? currentImage;

  @override
  void initState() {
    super.initState();
    currentImage = widget.currentImage;
  }

  void _nextImage() {
    setState(() {
      if (currentImage == widget.closeUpImage && widget.midShotImage != null) {
        currentImage = widget.midShotImage;
      } else if (currentImage == widget.midShotImage &&
          widget.wideShotImage != null) {
        currentImage = widget.wideShotImage;
      } else if (currentImage == widget.wideShotImage &&
          widget.closeUpImage != null) {
        currentImage = widget.closeUpImage;
      }
    });
  }

  void _previousImage() {
    setState(() {
      if (currentImage == widget.wideShotImage && widget.midShotImage != null) {
        currentImage = widget.midShotImage;
      } else if (currentImage == widget.midShotImage &&
          widget.closeUpImage != null) {
        currentImage = widget.closeUpImage;
      } else if (currentImage == widget.closeUpImage &&
          widget.wideShotImage != null) {
        currentImage = widget.wideShotImage;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackColor,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: currentImage != null
                    ? Image.file(currentImage!)
                    : const Text(
                        'No image available',
                        style: TextStyle(color: whiteColor),
                      ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton.filled(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    currentImage == widget.closeUpImage &&
                            widget.wideShotImage == null
                        ? blackColor.withOpacity(0.2)
                        : blackColor.withOpacity(0.5),
                  ),
                ),
                icon: const Icon(Icons.arrow_back_rounded, color: whiteColor),
                onPressed: currentImage == widget.closeUpImage &&
                        widget.wideShotImage == null
                    ? null
                    : _previousImage,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton.filled(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    currentImage == widget.wideShotImage &&
                            widget.closeUpImage == null
                        ? blackColor.withOpacity(0.2)
                        : blackColor.withOpacity(0.5),
                  ),
                ),
                icon:
                    const Icon(Icons.arrow_forward_rounded, color: whiteColor),
                onPressed: currentImage == widget.wideShotImage &&
                        widget.closeUpImage == null
                    ? null
                    : _nextImage,
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: IconButton.filled(
                style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(whiteColor)),
                icon: const Icon(
                  Icons.close_rounded,
                  color: blackColor,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
