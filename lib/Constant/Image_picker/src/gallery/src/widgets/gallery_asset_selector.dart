import 'package:flutter/material.dart';

import '../../../../drishya_picker.dart';
import '../../../../src/gallery/src/repo/gallery_repository.dart';

///
class GalleryAssetSelector extends StatefulWidget {
  ///
  const GalleryAssetSelector({
    Key? key,
    required this.controller,
    required this.albums,
  }) : super(key: key);

  ///
  final GalleryController controller;

  ///
  final Albums albums;

  @override
  GalleryAssetSelectorState createState() => GalleryAssetSelectorState();
}

///
class GalleryAssetSelectorState extends State<GalleryAssetSelector>
    with TickerProviderStateMixin {
  late AnimationController _editOpaController;
  late AnimationController _selectOpaController;
  late AnimationController _selectSizeController;
  late Animation<double> _editOpa;
  late Animation<double> _selectOpa;

  @override
  void initState() {
    super.initState();
    const duration = Duration(milliseconds: 300);
    _editOpaController = AnimationController(vsync: this, duration: duration);
    _selectOpaController = AnimationController(vsync: this, duration: duration);
    _selectSizeController =
        AnimationController(vsync: this, duration: duration);

    // ignore: prefer_int_literals
    final tween = Tween(begin: 0.0, end: 1.0);

    _editOpa = tween.animate(
      CurvedAnimation(
        parent: _editOpaController,
        curve: Curves.easeIn,
      ),
    );

    _selectOpa = tween.animate(
      CurvedAnimation(
        parent: _selectOpaController,
        curve: Curves.easeIn,
      ),
    );

    widget.controller.addListener(() {
      if (mounted) {
        final entities = widget.controller.value.selectedEntities;

        if (!widget.controller.reachedMaximumLimit) {
          if (entities.isEmpty && _selectOpaController.value == 1.0) {
            _editOpaController.reverse();
            _selectOpaController.reverse();
          }

          if (entities.isNotEmpty) {
            if (entities.length == 1) {
              _editOpaController.forward();
              _selectOpaController.forward();
              _selectSizeController.reverse();
            } else {
              _editOpaController.reverse();
              _selectSizeController.forward();
              if (_selectOpaController.value == 0.0) {
                _selectOpaController.forward();
              }
            }
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _editOpaController.dispose();
    _selectOpaController.dispose();
    _selectSizeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const padding = 20.0 + 16.0 + 20.0;
    final buttonWidth = (size.width - padding) / 2;

    return ValueListenableBuilder<GalleryValue>(
      valueListenable: widget.controller,
      builder: (context, value, child) {
        return Column(
          children: [
            const Expanded(child: SizedBox()),
            Container(
              padding: const EdgeInsets.all(20),
              width: size.width,
              // color: Colors.cyan,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: AnimatedBuilder(
                      animation: _selectOpa,
                      builder: (context, child) {
                        final hide = (value.selectedEntities.isEmpty &&
                                !_selectOpaController.isAnimating) ||
                            _selectOpa.value == 0.0;
                        return hide
                            ? const SizedBox()
                            : Opacity(
                                opacity: _selectOpa.value,
                                child: child,
                              );
                      },
                      child: SizedBox(
                        width: buttonWidth + (buttonWidth + 20.0),
                        child: _TextButton(
                          onPressed: widget.controller.completeTask,
                          label: 'SELECT',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _TextButton extends StatelessWidget {
  const _TextButton({
    Key? key,
    this.label,
    this.background,
    this.labelColor,
    this.onPressed,
  }) : super(key: key);

  final String? label;
  final Color? background;
  final Color? labelColor;
  final ValueChanged<BuildContext>? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => onPressed?.call(context),
      style: TextButton.styleFrom(
        backgroundColor: background ?? Theme.of(context).colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
      child: Text(
        label ?? '',
        style: Theme.of(context).textTheme.labelLarge!.copyWith(
              color: labelColor ?? Theme.of(context).colorScheme.onPrimary,
            ),
      ),
    );
  }
}
