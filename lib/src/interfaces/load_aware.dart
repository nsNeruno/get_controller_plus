import 'package:flutter/widgets.dart';
import 'package:get_controller_plus/get_controller_plus.dart';
import 'package:get_controller_plus/src/widgets/load_aware_widgets.dart';
import 'package:meta/meta.dart';

///
/// Interface for [GetxControllerPlus] that manages time-consuming tasks which
/// expects the UI to notify the user that there are one or more ongoing
/// processes running.
///
abstract class LoadAware {

  ///
  /// Parent widget bound by the [GetxController] will have [onWillPop] always
  /// return false if [isLoading] is true.
  ///
  /// Overridable
  ///
  WillPopCallback get onWillPop;

  ///
  /// Accessible within [GetxControllerPlus]
  /// Also accessed by support Widget [LoadAwareGetView].
  ///
  bool get isLoading;

  ///
  /// Implementation is expected to mutate the [isLoading] value.
  ///
  @protected
  set isLoading(bool value,);

  ///
  /// Same behavior with default [isLoading].
  /// Returns isLoading value for a specific [tag].
  ///
  bool isLoadingByTag(String tag,);

  ///
  /// Behaves like [isLoading] setter.
  /// Mutates the value of isLoading for a specific [tag]
  ///
  @protected
  void setIsLoadingByTag(String tag, bool value,);

  ///
  /// Sets [isLoading] to true, then run the [computation].
  /// Upon completion (including error), sets isLoading to false.
  ///
  @protected
  Future<T?> wait<T>(Future<T> computation, {String? tag,});
}