import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_controller_plus/get_controller_plus.dart';

///
/// [GetX] widget that subscribes to [GetxControllerPlus.isLoading] value and
/// build widgets by using the [builder]. A distinct isLoading instance may be
/// accessed by providing a [tag] name, as the default isLoading implementation
/// is considered to be parent-widget global scoped.
///
/// An optional [child] may be provided to conform with [ValueWidgetBuilder]
/// pattern for the builder.
///
/// By default, the [ignorePointer] property is set to true so that whenever
/// isLoading is true, the built widget will also be wrapped under
/// [IgnorePointer] widget.
///
/// A distinct property [controllerTag] may be provided to select a different
/// controller by tag.
///
class LoadAwareGetView<T extends GetxControllerPlus> extends StatelessWidget {

  const LoadAwareGetView({
    Key? key,
    this.tag,
    required this.builder,
    this.child,
    this.ignorePointer = true,
    this.controllerTag,
  }): super(key: key,);

  @override
  Widget build(BuildContext context,) {

    return GetX<T>(
      builder: (T controller,) {
        final tag = this.tag;
        final isLoading = tag != null
            ? controller.isLoadingByTag(tag,)
            : controller.isLoading;
        if (ignorePointer) {
          return IgnorePointer(
            ignoring: isLoading,
            child: builder(context, isLoading, child,),
          );
        }
        return builder(context, isLoading, child,);
      },
      tag: controllerTag,
    );
  }

  ///
  /// Optional tag to select a specific isLoading instance within the controller
  ///
  final String? tag;

  ///
  /// The second bool param is the isLoading value provided from the controller.
  /// And the nullable/optional child is provided from [child] argument.
  ///
  final ValueWidgetBuilder<bool> builder;

  ///
  /// An optional default [Widget] to render under the [builder]
  ///
  final Widget? child;

  ///
  /// If sets to true, wrap the built widget under [IgnorePointer]
  ///
  final bool ignorePointer;

  ///
  /// An optional tag for the [GetxController]
  ///
  final String? controllerTag;
}

///
/// A [WillPopScope] extension widget under [GetX] that uses default
/// [GetxControllerPlus.onWillPop] value for [WillPopScope.onWillPop] value.
///
class LoadAwareWillPopScope<T extends GetxControllerPlus>
    extends StatelessWidget {

  const LoadAwareWillPopScope({
    Key? key,
    required this.child,
    this.tag,
  }) : super(key: key,);

  @override
  Widget build(BuildContext context) {

    final controller = Get.find<T>(tag: tag,);
    return WillPopScope(
      onWillPop: controller.onWillPop,
      child: child,
    );
  }

  final Widget child;

  ///
  /// The tag for the [GetxController]
  ///
  final String? tag;
}