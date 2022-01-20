# get_controller_plus [![Pub](https://img.shields.io/pub/v/get_controller_plus.svg)](https://pub.dartlang.org/packages/get_controller_plus)
Extension of GetxController from GetX package with support Widgets.

## Features

- Awareness of a running process with duration which requires users to be notified
- Convenient error handler macro functions
- Further encouraging decoupling of Views and View Logics
- Provided with support widgets

## Getting started

### Prerequisites
- [GetX](https://pub.dev/packages/get) package
- Knowledge of using [GetxController](https://pub.dev/documentation/get/latest/get_state_manager_src_simple_get_controllers/GetxController-class.html) class
- Knowledge of connecting Get Observables

## Usage

Implementation is the same like `GetxController`

```dart
import 'package:get_controller_plus/get_controller_plus.dart';

class MySmartController extends GetxControllerPlus {
```

### Capabilities
#### Load Aware
Introducing `LoadAware` capabilities, the `GetxControllerPlus` provides extension methods:
- `isLoading` getter and setter, and with `tag` variant, `isLoadingByTag` and     `setIsLoadingByTag`.


```dart
// under GetxControllerPlus scope
isLoading = true;
isLoading = false;
setIsLoadingByTag(true, "anotherProcess",);

// within Views
Obx(
  () => {
    final isLoading = controller.isLoading;
    // or
    // final isLoading = controller.isLoadingByTag("anotherProcess",);
    return IgnorePointer(
      ignoring: isLoading,
      child: ElevatedButton(
        onPressed: () {},
        child: isLoading ? CircularProgressIndicator.adaptive() : Text("Go",),
      ),
    );
  },
)
```
- `wait` method

```dart
// run a Future and resolves it while automatically managing the isLoading state
// usable under GetxControllerPlus scope

final result = await wait(
  download(),
);
```
- Support Widget `LoadAwareGetView` and `LoadAwareWillPopScope`

```dart
// examples
import 'package:get_controller_plus/support_widgets.dart';

LoadAwareGetView<MySmartController>(
  builder: (BuildContext context, bool isLoading, Widget? child) {
    if (isLoading) {
      return CircularProgressIndicator.adaptive();
    } else {
      return MySmartView();
    }
  },
)

// this widget will not pop out if isLoading is true
LoadAwareWillPopScope<MySmartController>(
  // you may override the default onWillPop behavior
  // onWillPop: ...
  child: Scaffold(),
)
```
#### Error Handling
`GetxControllerPlus` comes with two additional methods to handle errors.
- `setErrorHandler<T>`

```dart
// public method, can be called from View scope or the controller scope itself
// set this first to make it available within handleError method.

// within View
controller.setErrorHandler<IOException>(
  showAlertDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Error",),
        content: Text("Connection Error!",),
      );
    },
  ),
);

// within controller
// preferrably within onInit state
void _showFormatError() {
  _hasError.value = true;
}

@override
void onInit() {
  super.onInit();
  setErrorHandler<FormatException>(
    _showFormatError,
  );
}
```
- `handleError(Object err)`

```dart
// protected method, call within controller's scope
Future<void> doSomething() async {
  try {
  // myMagic();
  } catch (err) {
    handleError(err,);
  }
}
```

## Additional information

Additional ideas and concepts are welcome by publishing on Git issues.