import 'package:delayed_consumer_hud/delayed_consumer_hud.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Delayed Consumer HUD example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;
  final testViewModel = TestViewModel();

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementSlowCounter() {
    // This will trigger the HUD
    widget.testViewModel.isBusy = true;

    // This simulates a long operation
    Future<void>.delayed(Duration(seconds: 2)).then((value) {
      setState(() {
        _counter++;
        // When the long operation completes, hide the HUD
        widget.testViewModel.isBusy = false;
      });
    });
  }

  void _incrementFastCounter() {
    // This will trigger the HUD
    widget.testViewModel.isBusy = true;

    // This simulates a long operation
    Future<void>.delayed(Duration(milliseconds: 100)).then((value) {
      setState(() {
        _counter++;
        // When the long operation completes, hide the HUD
        widget.testViewModel.isBusy = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TestViewModel>.value(
        value: widget.testViewModel,
        builder: (context, child) {
          return DelayedHud1<TestViewModel>(
            showHud: (value1) {
              return value1.isBusy;
            },
            delayedStart: Duration(milliseconds: 200),
            child: Scaffold(
              appBar: AppBar(
                title: Text(widget.title),
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'You have pushed the button this many times:',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                    Text(
                      '$_counter',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    Divider(height: 40),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'These are two operations that trigger the HUD to show up. The HUD has a 200ms delayed start. The fast operation takes 100ms and the slow operation takes 2s. Only the slow operation triggers the HUD to show up.',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ),
                    ButtonBar(
                      alignment: MainAxisAlignment.center,
                      children: [
                        OutlinedButton(
                          onPressed: _incrementFastCounter,
                          child: Text('Fast operation'),
                        ),
                        OutlinedButton(
                          onPressed: _incrementSlowCounter,
                          child: Text('Slow operation'),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}

class TestViewModel extends ChangeNotifier {
  bool _isBusy = false;

  set isBusy(bool value) {
    _isBusy = value;
    notifyListeners();
  }

  bool get isBusy {
    return _isBusy;
  }
}
