library delayed_consumer_hud;

// 🎯 Dart imports:
import 'dart:async';

// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:provider/provider.dart';

class _DelayedHudBaseState<T extends StatefulWidget> extends State<T> {
  Timer _timer;
  bool _showHud = false;

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  void _startTimer(Duration duration) {
    _timer = Timer(
        duration,
        () => setState(() {
              print('Show Delayed Hud');
              _showHud = true;
            }));
  }

  void _stopTimer() {
    if (_timer != null || _showHud) {
      print('Canceled/Closing Delayed Hud timer');
      _timer?.cancel();
      _timer = null;
      _showHud = false;
    }
  }

  Widget _showHudWidget(Widget hud, Color color) {
    return Container(
        color: color ?? Color.fromARGB(200, 0, 0, 0),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Center(child: hud));
  }
}

/// Most basic delayed start HUD. It does not use a provider to trigger the HUD.
/// You must provide the value to when it should be shown.
///
/// ```
/// var isBusy = true;
///
/// DelayedHud(
///   hud: CircularProgressIndicator(),
///   child: Text('DelayedHud'),
///   showHud: () => _isBusy, // Update this variable when you want to show/hide the HUD
/// )
///
/// ```
///
/// Show a hud with 1s delay and no provider.
/// When you set the variable isBusy to true, the timer will start and once the timer reaches 1s, it will show the HUD.
/// If you change the value of isBusy before 1s, the timer will be canceled.
///
///
/// ```
///
/// var isBusy = true;
///
/// DelayedHud(
///   hud: CircularProgressIndicator(),
///   child: Text('DelayedHud'),
///   delayedStart: Duration(seconds: 1),
///   showHud: () => _isBusy, // Update this variable when you want to show/hide the HUD
/// )
///
/// ```
class DelayedHud extends StatefulWidget {
  /// Constructor, only the child attribute is required.
  DelayedHud(
      {Key key,
      this.child,
      this.color,
      this.hud,
      this.delayedStart,
      this.hudWidget,
      this.showHud})
      : super(key: key);

  /// Widget that will be rendered by the HUD.
  /// Ideally this widget is a scaffold so when the HUD is rendered it covers the entire screen.
  @required
  final Widget child;

  /// This is the color used to cover the screen in between the child and the HUD control.
  /// If you don't specify this value, a translucent black color will be used.
  final Color color;

  /// Widget that is rendered when a HUD needs to be displayed.
  /// Typically this would be a CircularProgressIndicator()
  final Widget hud;

  /// Duration that the HUD will wait before you show it.
  /// If null, it starts automatically. Ideally, consider a duration of 250ms.
  final Duration delayedStart;

  /// Return true and the HUD widget will be shown or if there is a delayedStart defined then the timer will start.
  /// The timer will trigger showing the HUD widget.
  final bool Function() showHud;

  /// This is an alternative to the hud attribute.
  /// This is a callback that lets you generate a Widget using the various providers used.
  /// This gives you additional context in case the HUD is context aware.
  final Widget Function() hudWidget;

  @override
  _DelayedHudState createState() => _DelayedHudState();
}

class _DelayedHudState extends _DelayedHudBaseState<DelayedHud> {
  @override
  Widget build(BuildContext context) {
    if (widget.showHud() == true && _timer == null) {
      print('Start Delayed Hud timer');
      if (widget.delayedStart != null &&
          widget.delayedStart.inMicroseconds > 0) {
        _startTimer(widget.delayedStart);
      } else {
        _showHud = true;
      }
    } else if (widget.showHud() == false) {
      _stopTimer();
    }

    return Stack(
      children: [widget.child, if (_showHud) _generateHudWidget()],
    );
  }

  Widget _generateHudWidget() {
    if (widget.hudWidget == null) {
      return _showHudWidget(widget.hud, widget.color);
    } else {
      return widget.hudWidget();
    }
  }
}

/// In the following example, we will use a ChangeNotificationProvider to trigger showing the HUD. It is also using a delayed start.
/// When the provider changes values, the callback showHud will be called and the provider will be passed to this function. You can then check its value to determine if you need to show the HUD.
/// ```
/// DelayedHud1<TestViewModel>(
///   hud: hud,
///   child: Text('DelayedHud1<TestViewModel>'),
///   delayedStart: delay,
///   showHud: (viewModel) {
///     return viewModel.isBusy;
///   },
/// )
/// ```
class DelayedHud1<T1> extends StatefulWidget {
  /// Constructor, only the child attribute is required.
  DelayedHud1(
      {Key key,
      this.child,
      this.color,
      this.hud,
      this.delayedStart,
      this.hudWidget,
      this.showHud})
      : super(key: key);

  /// Widget that will be rendered by the HUD.
  /// Ideally this widget is a scaffold so when the HUD is rendered it covers the entire screen.
  @required
  final Widget child;

  /// This is the color used to cover the screen in between the child and the HUD control.
  /// If you don't specify this value, a translucent black color will be used.
  final Color color;

  /// Widget that is rendered when a HUD needs to be displayed.
  /// Typically this would be a CircularProgressIndicator()
  final Widget hud;

  /// Duration that the HUD will wait before you show it.
  /// If null, it starts automatically. Ideally, consider a duration of 250ms.
  final Duration delayedStart;

  /// Return true and the HUD widget will be shown or if there is a delayedStart defined then the timer will start.
  /// The timer will trigger showing the HUD widget. Use the value of the provider to determine if you should show the HUD or not.
  final bool Function(T1 value1) showHud;

  /// This is an alternative to the hud attribute.
  /// This is a callback that lets you generate a Widget using the various providers used.
  /// This gives you additional context in case the HUD is context aware.
  final Widget Function(T1 value1) hudWidget;

  bool _showHudProxy(
    dynamic value1,
  ) {
    if (value1 is T1) {
      return showHud(value1);
    } else {
      throw Exception('Invalid types when calling _showHudProxy');
    }
  }

  Widget _hudWidgetProxy(
    dynamic value1,
  ) {
    if (value1 is T1) {
      return hudWidget(value1);
    } else {
      throw Exception('Invalid types when calling _showHudProxy');
    }
  }

  @override
  _DelayedHudState1 createState() => _DelayedHudState1<T1>();
}

class _DelayedHudState1<T1> extends _DelayedHudBaseState<DelayedHud1> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        Consumer<T1>(builder: (BuildContext context, value1, child) {
          if (widget._showHudProxy(value1) == true && _timer == null) {
            print('Start Delayed Hud timer');
            if (widget.delayedStart != null &&
                widget.delayedStart.inMicroseconds > 0) {
              _startTimer(widget.delayedStart);
            } else {
              _showHud = true;
            }
          } else if (widget._showHudProxy(value1) == false) {
            _stopTimer();
          }
          if (_showHud) {
            if (widget.hudWidget == null) {
              return _showHudWidget(widget.hud, widget.color);
            } else {
              return widget._hudWidgetProxy(value1);
            }
          } else {
            return Container();
          }
        })
      ],
    );
  }
}

/// In the following example, we will use a ChangeNotificationProvider to trigger showing the HUD. It is also using a delayed start.
/// When one of the providers change values, the callback showHud will be called and the providers will be passed to this function.
/// You can then check its value to determine if you need to show the HUD.
/// ```
/// DelayedHud1<TestViewModel>(
///   hud: hud,
///   child: Text('DelayedHud1<TestViewModel, AnotherViewModel>'),
///   delayedStart: delay,
///   showHud: (viewModel1, viewModel2) {
///     return viewModel.isBusy || viewModel2.isSaving;
///   },
/// )
/// ```
class DelayedHud2<T1, T2> extends StatefulWidget {
  /// Constructor, only the child attribute is required.
  DelayedHud2(
      {Key key,
      this.child,
      this.color,
      this.hud,
      this.delayedStart,
      this.hudWidget,
      this.showHud})
      : super(key: key);

  /// Widget that will be rendered by the HUD.
  /// Ideally this widget is a scaffold so when the HUD is rendered it covers the entire screen.
  @required
  final Widget child;

  /// This is the color used to cover the screen in between the child and the HUD control.
  /// If you don't specify this value, a translucent black color will be used.
  final Color color;

  /// Widget that is rendered when a HUD needs to be displayed.
  /// Typically this would be a CircularProgressIndicator()
  final Widget hud;

  /// Duration that the HUD will wait before you show it.
  /// If null, it starts automatically. Ideally, consider a duration of 250ms.
  final Duration delayedStart;

  /// Return true and the HUD widget will be shown or if there is a delayedStart defined then the timer will start.
  /// The timer will trigger showing the HUD widget. Use the value of the provider to determine if you should show the HUD or not.
  final bool Function(T1 value1, T2 value2) showHud;

  /// This is an alternative to the hud attribute.
  /// This is a callback that lets you generate a Widget using the various providers used.
  /// This gives you additional context in case the HUD is context aware.
  final Widget Function(T1 value1, T2 value2) hudWidget;

  bool _showHudProxy(dynamic value1, dynamic value2) {
    if (value1 is T1 && value2 is T2) {
      return showHud(value1, value2);
    } else {
      throw Exception('Invalid types when calling _showHudProxy');
    }
  }

  Widget _hudWidgetProxy(dynamic value1, dynamic value2) {
    if (value1 is T1 && value2 is T2) {
      return hudWidget(value1, value2);
    } else {
      throw Exception('Invalid types when calling _showHudProxy');
    }
  }

  @override
  _DelayedHudState2 createState() => _DelayedHudState2<T1, T2>();
}

class _DelayedHudState2<T1, T2> extends _DelayedHudBaseState<DelayedHud2> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        Consumer2<T1, T2>(
            builder: (BuildContext context, value1, value2, child) {
          if (widget._showHudProxy(value1, value2) == true && _timer == null) {
            print('Start Delayed Hud timer');
            if (widget.delayedStart != null &&
                widget.delayedStart.inMicroseconds > 0) {
              _startTimer(widget.delayedStart);
            } else {
              _showHud = true;
            }
          } else if (widget._showHudProxy(value1, value2) == false) {
            _stopTimer();
          }
          if (_showHud) {
            if (widget.hudWidget == null) {
              return _showHudWidget(widget.hud, widget.color);
            } else {
              return widget._hudWidgetProxy(value1, value2);
            }
          } else {
            return Container();
          }
        })
      ],
    );
  }
}

/// In the following example, we will use a ChangeNotificationProvider to trigger showing the HUD. It is also using a delayed start.
/// When one of the providers change values, the callback showHud will be called and the providers will be passed to this function.
/// You can then check its value to determine if you need to show the HUD.
/// ```
/// DelayedHud1<TestViewModel>(
///   hud: hud,
///   child: Text('DelayedHud1<TestViewModel, AnotherViewModel, YetAnotherViewModel>'),
///   delayedStart: delay,
///   showHud: (viewModel1, viewModel2, viewModel3) {
///     return viewModel.isBusy || viewModel2.isSaving || viewModel3.isProcessing;
///   },
/// )
/// ```
class DelayedHud3<T1, T2, T3> extends StatefulWidget {
  /// Constructor, only the child attribute is required.
  DelayedHud3(
      {Key key,
      this.child,
      this.color,
      this.hud,
      this.delayedStart,
      this.hudWidget,
      this.showHud})
      : super(key: key);

  /// Widget that will be rendered by the HUD.
  /// Ideally this widget is a scaffold so when the HUD is rendered it covers the entire screen.
  @required
  final Widget child;

  /// This is the color used to cover the screen in between the child and the HUD control.
  /// If you don't specify this value, a translucent black color will be used.
  final Color color;

  /// Widget that is rendered when a HUD needs to be displayed.
  /// Typically this would be a CircularProgressIndicator()
  final Widget hud;

  /// Duration that the HUD will wait before you show it.
  /// If null, it starts automatically. Ideally, consider a duration of 250ms.
  final Duration delayedStart;

  /// Return true and the HUD widget will be shown or if there is a delayedStart defined then the timer will start.
  /// The timer will trigger showing the HUD widget. Use the value of the provider to determine if you should show the HUD or not.
  final bool Function(T1 value1, T2 value2, T3 value3) showHud;

  /// This is an alternative to the hud attribute.
  /// This is a callback that lets you generate a Widget using the various providers used.
  /// This gives you additional context in case the HUD is context aware.
  final Widget Function(T1 value1, T2 value2, T3 value3) hudWidget;

  bool _showHudProxy(dynamic value1, dynamic value2, dynamic value3) {
    if (value1 is T1 && value2 is T2 && value3 is T3) {
      return showHud(value1, value2, value3);
    } else {
      throw Exception('Invalid types when calling _showHudProxy');
    }
  }

  Widget _hudWidgetProxy(dynamic value1, dynamic value2, dynamic value3) {
    if (value1 is T1 && value2 is T2) {
      return hudWidget(value1, value2, value3);
    } else {
      throw Exception('Invalid types when calling _showHudProxy');
    }
  }

  @override
  _DelayedHudState3 createState() => _DelayedHudState3<T1, T2, T3>();
}

class _DelayedHudState3<T1, T2, T3> extends _DelayedHudBaseState<DelayedHud3> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        Consumer3<T1, T2, T3>(
            builder: (BuildContext context, value1, value2, value3, child) {
          if (widget._showHudProxy(
                    value1,
                    value2,
                    value3,
                  ) ==
                  true &&
              _timer == null) {
            print('Start Delayed Hud timer');
            if (widget.delayedStart != null &&
                widget.delayedStart.inMicroseconds > 0) {
              _startTimer(widget.delayedStart);
            } else {
              _showHud = true;
            }
          } else if (widget._showHudProxy(value1, value2, value3) == false) {
            _stopTimer();
          }
          if (_showHud) {
            if (widget.hudWidget == null) {
              return _showHudWidget(widget.hud, widget.color);
            } else {
              return widget._hudWidgetProxy(value1, value2, value3);
            }
          } else {
            return Container();
          }
        })
      ],
    );
  }
}
