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
        color: color,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Center(child: hud));
  }
}

class DelayedHud extends StatefulWidget {
  DelayedHud(
      {Key key,
      this.child,
      this.color,
      this.hud,
      this.delayedStart,
      this.hudWidget,
      this.showHud})
      : super(key: key);

  @required
  final Widget child;
  final Color color;
  final Widget hud;
  final Duration delayedStart;
  final bool Function() showHud;
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

class DelayedHud1<T1> extends StatefulWidget {
  DelayedHud1(
      {Key key,
      this.child,
      this.color,
      this.hud,
      this.delayedStart,
      this.hudWidget,
      this.showHud})
      : super(key: key);

  @required
  final Widget child;
  final Color color;
  final Widget hud;
  final Duration delayedStart;
  final bool Function(T1 value1) showHud;
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

class DelayedHud2<T1, T2> extends StatefulWidget {
  DelayedHud2(
      {Key key,
      this.child,
      this.color,
      this.hud,
      this.delayedStart,
      this.hudWidget,
      this.showHud})
      : super(key: key);

  @required
  final Widget child;
  final Color color;
  final Widget hud;
  final Duration delayedStart;
  final bool Function(T1, T2) showHud;
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

class DelayedHud3<T1, T2, T3> extends StatefulWidget {
  DelayedHud3(
      {Key key,
      this.child,
      this.color,
      this.hud,
      this.delayedStart,
      this.hudWidget,
      this.showHud})
      : super(key: key);

  @required
  final Widget child;
  final Color color;
  final Widget hud;
  final Duration delayedStart;
  final bool Function(T1 value1, T2 value2, T3 value3) showHud;
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
