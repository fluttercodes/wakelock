import 'dart:async';

import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:import_js_library/import_js_library.dart';
import 'package:js/js.dart';
import 'package:wakelock_platform_interface/wakelock_platform_interface.dart';
import 'package:wakelock_web/src/js_wakelock.dart' as Wakelock;

/// The web implementation of the [WakelockPlatformInterface].
///
/// This class implements the `wakelock` plugin functionality for web.
class WakelockWeb extends WakelockPlatformInterface {
  /// Registers [WakelockWeb] as the default instance of the
  /// [WakelockPlatformInterface].
  static void registerWith(Registrar registrar) {
    // Import a version of `NoSleep.js` that was adjusted for the wakelock
    // plugin.
    importJsLibrary(
        url: 'assets/no_sleep.js', flutterPluginName: 'wakelock_web');

    WakelockPlatformInterface.instance = WakelockWeb();
  }

  @override
  Future<void> toggle({bool enable}) async {
    assert(enable != null);

    Wakelock.toggle(enable);
  }

  @override
  Future<bool> get enabled async {
    final completer = Completer<bool>();

    Wakelock.enabled().then(
      // onResolve
      allowInterop((value) {
        assert(value is bool);

        completer.complete(value);
      }),
      // onReject
      allowInterop((error) {
        completer.completeError(error);
      }),
    );

    return completer.future;
  }
}
