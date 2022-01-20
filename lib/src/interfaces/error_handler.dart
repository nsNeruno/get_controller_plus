import 'dart:async';

import 'package:get_controller_plus/get_controller_plus.dart';
import 'package:meta/meta.dart';

///
/// Interface for [GetxControllerPlus] that simplifies error handling by
/// delegating caught error-like [Object]s under most try-catch blocks into:
/// - Exposed View (Widgets, GetViews) codes
/// - Mutating existing state values under the [GetxControllerPlus]
///
/// Example:
/// #### Delegating handlers to a View scope (GetView example)
/// ```dart
/// Widget build(BuildContext context) {
///
///   controller.setErrorHandler<FormatException>(
///     showDialog(
///       context,
///       builder: (context,) => AlertDialog(
///         title: Text("Error",),
///         message: Text("Failure to format something",),
///       ),
///     );
///   );
///
///   return MyWidget(
///   ...
///   );
/// }
/// ```
///
/// Yet another example:
/// #### Mutate Observable states under GetXController itself
/// ```dart
/// @override
/// void onInit() {
///   setErrorHandler<IOException>(...);
///   setErrorHandler<ArgumentError>(...);
/// }
/// ```
///
abstract class ErrorHandler {

  ///
  /// Recommended invoke locations:
  /// - GetxController onInit/onReady
  /// - GetView/StatelessWidget build implementation
  ///
  void setErrorHandler<T>(ErrorHandlerCallback<T> handler,);

  ///
  /// Typically invoked within catch block inside GetxController codes.
  /// Example:
  /// ```dart
  /// try {
  ///   throw UnimplementedError("...",);
  /// } catch (err) {
  ///   handleError(err,);
  /// }
  /// ```
  ///
  @protected
  FutureOr<void> handleError(Object err,);
}

typedef ErrorHandlerCallback<T> = FutureOr Function(T);