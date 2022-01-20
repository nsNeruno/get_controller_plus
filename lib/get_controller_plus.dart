library get_controller_plus;

import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_controller_plus/src/widgets/load_aware_widgets.dart';
import 'package:meta/meta.dart';

import 'src/interfaces/error_handler.dart';
import 'src/interfaces/load_aware.dart';

export 'src/interfaces/load_aware.dart';
export 'src/interfaces/error_handler.dart';

/// An extended version of GetX [GetxController]
///
/// Features:
/// - Awareness of a running process with duration which requires users to be notified
/// - Convenient error handler macro functions
/// - Encouraging decoupling of Views and View Logics
/// - Provided with support widgets
///
/// Typical usage:
/// ```dart
/// class MySmartController extends GetxControllerPlus {
/// // ...
/// }
///
/// class MySmartWidget extends GetView<MySmartController> {
/// // ...
/// }
///
/// class MyOtherSmartWidget extends StatelessWidget {
///
///   @override
///   Widget build(BuildContext context) {
///     final controller = Get.put(
///       MySmartController(),
///     );
///
///     // ...
///   }
/// }
/// ```
///
abstract class GetxControllerPlus extends GetxController
    implements LoadAware, ErrorHandler {

  ///
  /// Default implementation of WillPopCallback.
  /// Returns false if is [isLoading]
  ///
  /// Enforced by support Widget [LoadAwareWillPopScope].
  ///
  /// Override example:
  /// ```dart
  /// @override
  /// WillPopCallback get onWillPop async {
  ///   final bool shouldPop = await super.onWillPop();
  ///   final bool exampleCondition = true;
  ///   return shouldPop && exampleCondition;
  /// }
  /// ```
  ///
  @override
  WillPopCallback get onWillPop => () async => !isLoading;

  ///
  /// This value determines if a process is currently running and user needs to
  /// be notified about it. Reflected by the widgets built by this value.
  ///
  /// Enforced by support widget [LoadAware].
  ///
  /// Typical usage within [Obx] or [GetX] widgets.
  ///
  @override
  bool get isLoading => _isLoading.value;

  /// **_PROTECTED_**
  ///
  /// Call within the scope of [GetxControllerPlus] to notify whether a process
  /// is currently running and user needs to be notified about it.
  ///
  @override
  @protected
  set isLoading(bool value,) => _isLoading.value = value;

  ///
  /// Works the same like [isLoading], but with a specific tag. Typically used
  /// in a screen where there are more than one waitable processes and the user
  /// needs to be notified by a separate display.
  ///
  @override
  bool isLoadingByTag(String tag,) {
    final Rx<bool> isLoading = _extraIsLoadings[tag] ??= false.obs;
    return isLoading.value;
  }

  /// **_PROTECTED_**
  ///
  /// Works the same like the protected [isLoading] setter, but implemented to
  /// set the value for a specific tag.
  ///
  @override
  @protected
  void setIsLoadingByTag(String tag, bool value,) {
    final isLoading = _extraIsLoadings[tag] ??= false.obs;
    isLoading.value = value;
  }

  /// **_PROTECTED_**
  ///
  /// A wrapper for a any [Future] computation which will automatically toggle
  /// the controller-wide [isLoading] state, with optional [tag] for a specific
  /// state.
  ///
  /// Returns [computation] result, and rethrow any errors found.
  ///
  @override
  @protected
  Future<T?> wait<T>(Future<T> computation, {String? tag,}) async {
    if (tag != null) {
      setIsLoadingByTag(tag, true,);
      try {
        final result = await computation;
        setIsLoadingByTag(tag, false,);
        return result;
      } catch (err) {
        setIsLoadingByTag(tag, false,);
        rethrow;
      }
    } else {
      isLoading = true;
      try {
        final result = await computation;
        isLoading = false;
        return result;
      } catch (err) {
        isLoading = false;
        rethrow;
      }
    }
  }

  final _isLoading = false.obs;
  final Map<String, Rx<bool>> _extraIsLoadings = {};

  ///
  /// Provides a [handler] Function to handle any calls from [handleError].
  /// Handles [T] which is error-like object which is typically thrown by
  /// try-catch blocks inside the [GetxControllerPlus] scope.
  ///
  /// Typically called in either [onInit] step or the context of the Widget
  /// itself.
  ///
  @override
  void setErrorHandler<T>(ErrorHandlerCallback<T> handler) {
    final Type type = <T>() { return T; }();
    _errorHandlers[type] = handler;
  }

  /// **_PROTECTED_**
  ///
  /// Invoke an error handling Function if provided.
  ///
  @override
  @protected
  FutureOr<void> handleError(Object err,) {
    final handler = _errorHandlers[err.runtimeType];
    if (handler is Function) {
      handler(err);
    }
  }

  final Map<Type, dynamic> _errorHandlers = {};

  ///
  /// Disposes resources as usual in a typical [onClose] event.
  ///
  @override
  void onClose() {
    _isLoading.close();
    for (var e in _extraIsLoadings.values) {
      e.close();
    }
    super.onClose();
  }
}