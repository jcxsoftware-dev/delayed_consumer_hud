import 'package:delayed_consumer_hud/delayed_consumer_hud.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets("DelayedHud no delay", (WidgetTester tester) async {
    final key = Key('CircularProgressIndicator');
    Widget hud = CircularProgressIndicator(key: key);

    await tester.pumpWidget(MediaQuery(
      data: MediaQueryData(size: Size(1024, 768)),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: DelayedHud(
          hud: hud,
          child: Text('DelayedHud'),
          delayedStart: null,
          showHud: () => true,
        ),
      ),
    ));

    expect(find.byKey(key), findsOneWidget);
  });

  testWidgets("DelayedHud no delay and generate widget callback",
      (WidgetTester tester) async {
    final key = Key('CircularProgressIndicator');
    await tester.pumpWidget(MediaQuery(
      data: MediaQueryData(size: Size(1024, 768)),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: DelayedHud(
          hudWidget: () {
            return CircularProgressIndicator(key: key);
          },
          child: Text('DelayedHud'),
          delayedStart: null,
          showHud: () => true,
        ),
      ),
    ));

    expect(find.byKey(key), findsOneWidget);
  });

  testWidgets("DelayedHud with delay", (WidgetTester tester) async {
    final key = Key('CircularProgressIndicator');
    Widget hud = CircularProgressIndicator(key: key);

    final delay = Duration(seconds: 1);

    await tester.pumpWidget(MediaQuery(
      data: MediaQueryData(size: Size(1024, 768)),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: DelayedHud(
          hud: hud,
          child: Text('DelayedHud'),
          delayedStart: delay,
          showHud: () => true,
        ),
      ),
    ));

    expect(find.byKey(key), findsNothing);

    await tester.pump(delay);

    expect(find.byKey(key), findsOneWidget);
  });

  testWidgets("DelayedHud1 with provider and delay",
      (WidgetTester tester) async {
    final key = Key('CircularProgressIndicator');
    Widget hud = CircularProgressIndicator(key: key);

    final delay = Duration(seconds: 1);

    var testViewModel = TestViewModel();

    await tester.pumpWidget(MediaQuery(
      data: MediaQueryData(size: Size(1024, 768)),
      child: ChangeNotifierProvider<TestViewModel>.value(
          value: testViewModel,
          builder: (context, child) {
            return Directionality(
              textDirection: TextDirection.ltr,
              child: DelayedHud1<TestViewModel>(
                hud: hud,
                child: Text('DelayedHud1<TestViewModel>'),
                delayedStart: delay,
                showHud: (viewModel) {
                  return viewModel.isBusy;
                },
              ),
            );
          }),
    ));

    expect(find.byKey(key), findsNothing);

    await tester.pump(delay);

    testViewModel.isBusy = true;

    await tester.pump();

    expect(find.byKey(key), findsNothing);

    await tester.pump(delay);

    expect(find.byKey(key), findsOneWidget);

    testViewModel.isBusy = false;

    await tester.pump();

    expect(find.byKey(key), findsNothing);
  });

  testWidgets("DelayedHud1 with provider and delay and cancel",
      (WidgetTester tester) async {
    final key = Key('CircularProgressIndicator');
    Widget hud = CircularProgressIndicator(key: key);

    final delay = Duration(seconds: 2);
    final halfDelay = Duration(seconds: 1);

    var testViewModel = TestViewModel();

    await tester.pumpWidget(MediaQuery(
      data: MediaQueryData(size: Size(1024, 768)),
      child: ChangeNotifierProvider<TestViewModel>.value(
          value: testViewModel,
          builder: (context, child) {
            return Directionality(
              textDirection: TextDirection.ltr,
              child: DelayedHud1<TestViewModel>(
                hud: hud,
                child: Text('DelayedHud1<TestViewModel>'),
                delayedStart: delay,
                showHud: (viewModel) {
                  return viewModel.isBusy;
                },
              ),
            );
          }),
    ));

    expect(find.byKey(key), findsNothing);

    await tester.pump(delay);

    testViewModel.isBusy = true;

    await tester.pump();

    expect(find.byKey(key), findsNothing);

    await tester.pump(halfDelay);

    expect(find.byKey(key), findsNothing);

    testViewModel.isBusy = false;

    await tester.pump(halfDelay);

    expect(find.byKey(key), findsNothing);
  });

  testWidgets("DelayedHud2 with provider and delay",
      (WidgetTester tester) async {
    final key = Key('CircularProgressIndicator');
    Widget hud = CircularProgressIndicator(key: key);

    final delay = Duration(seconds: 1);

    var testViewModel1 = TestViewModel();
    var testViewModel2 = AnotherViewModel();

    await tester.pumpWidget(
      MediaQuery(
        data: MediaQueryData(size: Size(1024, 768)),
        child: MultiProvider(
            providers: [
              ChangeNotifierProvider<TestViewModel>.value(
                  value: testViewModel1),
              ChangeNotifierProvider<AnotherViewModel>.value(
                  value: testViewModel2),
            ],
            builder: (context, child) {
              return Directionality(
                textDirection: TextDirection.ltr,
                child: DelayedHud2<TestViewModel, AnotherViewModel>(
                  hud: hud,
                  child: Text('DelayedHud2<TestViewModel, TestViewModel>'),
                  delayedStart: delay,
                  showHud: (viewModel1, viewModel2) {
                    return viewModel1.isBusy || viewModel2.isSaving;
                  },
                ),
              );
            }),
      ),
    );

    expect(find.byKey(key), findsNothing);

    await tester.pump(delay);

    testViewModel1.isBusy = true;

    await tester.pump();

    expect(find.byKey(key), findsNothing);

    await tester.pump(delay);

    expect(find.byKey(key), findsOneWidget);

    testViewModel1.isBusy = false;

    await tester.pump();

    expect(find.byKey(key), findsNothing);

    testViewModel2.isSaving = true;

    await tester.pump();

    expect(find.byKey(key), findsNothing);

    await tester.pump(delay);

    expect(find.byKey(key), findsOneWidget);

    testViewModel2.isSaving = false;

    await tester.pump();

    expect(find.byKey(key), findsNothing);
  });

  testWidgets("DelayedHud3 with provider and delay",
      (WidgetTester tester) async {
    final key = Key('CircularProgressIndicator');
    Widget hud = CircularProgressIndicator(key: key);

    final delay = Duration(seconds: 1);

    var testViewModel1 = TestViewModel();
    var testViewModel2 = AnotherViewModel();
    var testViewModel3 = YetAnotherViewModel();

    await tester.pumpWidget(
      MediaQuery(
        data: MediaQueryData(size: Size(1024, 768)),
        child: MultiProvider(
            providers: [
              ChangeNotifierProvider<TestViewModel>.value(
                  value: testViewModel1),
              ChangeNotifierProvider<AnotherViewModel>.value(
                  value: testViewModel2),
              ChangeNotifierProvider<YetAnotherViewModel>.value(
                  value: testViewModel3),
            ],
            builder: (context, child) {
              return Directionality(
                textDirection: TextDirection.ltr,
                child: DelayedHud3<TestViewModel, AnotherViewModel,
                    YetAnotherViewModel>(
                  hud: hud,
                  child: Text('DelayedHud2<TestViewModel, TestViewModel>'),
                  delayedStart: delay,
                  showHud: (viewModel1, viewModel2, viewModel3) {
                    return viewModel1.isBusy ||
                        viewModel2.isSaving ||
                        viewModel3.isProcessing;
                  },
                ),
              );
            }),
      ),
    );

    expect(find.byKey(key), findsNothing);

    await tester.pump(delay);

    testViewModel1.isBusy = true;

    await tester.pump();

    expect(find.byKey(key), findsNothing);

    await tester.pump(delay);

    expect(find.byKey(key), findsOneWidget);

    testViewModel1.isBusy = false;

    await tester.pump();

    expect(find.byKey(key), findsNothing);

    testViewModel2.isSaving = true;

    await tester.pump();

    expect(find.byKey(key), findsNothing);

    await tester.pump(delay);

    expect(find.byKey(key), findsOneWidget);

    testViewModel2.isSaving = false;

    await tester.pump();

    expect(find.byKey(key), findsNothing);

    testViewModel3.isProcessing = true;

    await tester.pump();

    expect(find.byKey(key), findsNothing);

    await tester.pump(delay);

    expect(find.byKey(key), findsOneWidget);

    testViewModel3.isProcessing = false;

    await tester.pump();

    expect(find.byKey(key), findsNothing);
  });
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

class AnotherViewModel extends ChangeNotifier {
  bool _isSaving = false;

  set isSaving(bool value) {
    _isSaving = value;
    notifyListeners();
  }

  bool get isSaving {
    return _isSaving;
  }
}

class YetAnotherViewModel extends ChangeNotifier {
  bool _isProcessing = false;

  set isProcessing(bool value) {
    _isProcessing = value;
    notifyListeners();
  }

  bool get isProcessing {
    return _isProcessing;
  }
}
