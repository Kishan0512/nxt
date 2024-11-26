import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meta/meta.dart';

import '../../../../animations/animations.dart';
import '../../../../drishya_picker.dart';
import '../../../drishya_entity.dart';
import '../widgets/ui_handler.dart';

///
/// Gallery controller
class GalleryController extends ValueNotifier<GalleryValue> {
  ///
  /// Gallery controller constructor
  GalleryController()
      : panelKey = GlobalKey(),
        _panelController = PanelController(),
        _albumVisibility = ValueNotifier(false),
        super(const GalleryValue()) {
    init();
  }

  /// Slidable gallery key
  final GlobalKey panelKey;

  /// Panel controller
  final PanelController _panelController;

  /// Recent entities notifier
  final ValueNotifier<bool> _albumVisibility;

  /// Panel setting
  late PanelSetting _panelSetting;

  /// Panel setting
  PanelSetting get panelSetting => _panelSetting;

  late GallerySetting _setting;

  /// Gallery setting
  GallerySetting get setting => _setting;

  // Completer for gallerry picker controller
  late Completer<List<DrishyaEntity>> _completer;

  // Flag to handle updating controller value internally
  var _internal = false;

  // Flag which will used to determine that controller can be auto dispose
  // or not.
  var _autoDispose = false;

  /// Value will be true if controller can be auto dispose
  @internal
  bool get autoDispose => _autoDispose;

  // Gallery picker on changed event callback handler
  void Function(DrishyaEntity entity, bool removed)? _onChanged;

   VoidCallback? onCamaraPress;

  ///
  /// Initialize controller setting
  @internal
  void init({GallerySetting? setting}) {
    _setting = setting ?? const GallerySetting();
    _panelSetting = _setting.panelSetting ?? const PanelSetting();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (_setting.selectedEntities.isNotEmpty) {
        _internal = true;
        value = value.copyWith(selectedEntities: _setting.selectedEntities);
      }
    });
  }

  ///
  /// Update album visibility
  @internal
  void setAlbumVisibility({required bool visible}) {
    _panelController.isGestureEnabled = !visible;
    _albumVisibility.value = visible;
    _internal = true;
    value = value.copyWith(isAlbumVisible: visible);
  }

  ///
  /// Toogle force multi selection button
  @internal
  void toogleMultiSelection() {
    _internal = true;
    value = value.copyWith(
      enableMultiSelection: !value.enableMultiSelection,
    );
  }

  ///
  /// Selecting and unselecting entities
  @internal
  void select(
    BuildContext context,
    DrishyaEntity entity, {
    bool edited = false,
  }) {
    // Check limit

    // Handle single selection mode
    if (singleSelection) {
      _onChanged?.call(entity, false);
      completeTask(context, items: [entity]);
     return;
    }

    final entities = value.selectedEntities.toList();
    final isSelected = entities.contains(entity);

    // Unselect item if selected previously
    if (isSelected) {
      _onChanged?.call(entity, true);
      entities.remove(entity);
      _internal = true;
      value = value.copyWith(selectedEntities: entities);
      return;
    }
    if (reachedMaximumLimit) {
      Fluttertoast.showToast(
        msg: 'Maximum selection limit of '
            '${setting.maximumCount} has been reached!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }
    // Unselect previous item and continue if it was edited
    if (edited && entities.isNotEmpty) {
      final item = entities.last;
      _onChanged?.call(item, true);
      entities.remove(item);
    }

    entities.add(entity);
    _onChanged?.call(entity, false);
    _internal = true;
    value = value.copyWith(selectedEntities: entities);
  }

  ///
  /// Open gallery using [GalleryViewField]
  @internal
  Future<List<DrishyaEntity>> onGalleryFieldPressed(
    BuildContext context, {
    void Function(DrishyaEntity entity, bool removed)? onChanged,
    GallerySetting? setting,
    VoidCallback? onCamaraPres,
    CustomRouteSetting? routeSetting,
    bool disposeOnFinish = false,
  }) async {
    _onChanged = onChanged;
    onCamaraPress = onCamaraPres;
    // Dispose controller created inside [GalleryViewField]
    // onPressed which need to be disposed.
    _autoDispose = disposeOnFinish;
    final entities =
        await pick(context, setting: setting, routeSetting: routeSetting);
    _onChanged = null;
    return entities;
  }

  ///
  /// Handle picking process for slidable gallery using completer
  Future<List<DrishyaEntity>> _collapsableGallery(BuildContext context) {
    _completer = Completer<List<DrishyaEntity>>();
    _panelController.openPanel();
    FocusScope.of(context).unfocus();
    return _completer.future;
  }

  ///
  /// Complete selection process
  @internal
  List<DrishyaEntity> completeTask(
    BuildContext context, {
    List<DrishyaEntity>? items,
  }) {
    final entities = items ?? value.selectedEntities;

    // In fullscreen mode just pop the widget with selected entities
    if (fullScreenMode) {
      UIHandler.of(context).pop(entities);
      return entities;
    }

    _panelController.closePanel();
    _internal = true;
    value = const GalleryValue();
    _completer.complete(entities);
    List<DrishyaEntity>? Image = entities;
    return Image;
  }

  ///
  /// Complete selection process
  @internal
void ClosePenal() {
    // value.selectedEntities.clear();
    _panelController.closePanel();
  }
  // ======================== PUBLIC ========================

  ///
  /// Clear selected entities
  void clearSelection() {
    _internal = true;
    value = value.copyWith(selectedEntities: []);
  }

  ///
  /// Pick assets
  Future<List<DrishyaEntity>> pick(
    BuildContext context, {
    GallerySetting? setting,
    CustomRouteSetting? routeSetting,
  }) async {
    if (fullScreenMode) {
      final entities = await GalleryView.pick(
        context,
        controller: this,
        setting: setting,
        routeSetting: routeSetting,
      );
      await UIHandler.showStatusBar();
      return entities ?? [];
    }
    if (setting != null) {
      init(setting: setting);
    }
    return _collapsableGallery(context);
  }

  // ===================== GETTERS ==========================

  ///
  /// Album visibility notifier
  ValueNotifier<bool> get albumVisibility => _albumVisibility;

  ///
  /// return true if gallery is in full screen mode,
  bool get fullScreenMode => panelKey.currentState == null;

  ///
  /// return true if selected media reached to maximum selection limit
  bool get reachedMaximumLimit =>
      value.selectedEntities.length == setting.maximumCount;

  ///
  /// return true is gallery is in single selection mode
  bool get singleSelection =>
      _setting.selectionMode == SelectionMode.actionBased
          ? !value.enableMultiSelection
          : setting.maximumCount == 1;

  ///
  /// Gallery view pannel controller
  PanelController get panelController => _panelController;

  @override
  set value(GalleryValue newValue) {
    if (!_internal || value == newValue) return;
    super.value = newValue;
    _internal = false;
  }

  @override
  void dispose() {
    _panelController.dispose();
    _albumVisibility.dispose();
    super.dispose();
  }

//
}
