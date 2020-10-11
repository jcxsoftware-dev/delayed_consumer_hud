# HUD with delayed start and provider tigger

A HUD that comes with two key features, the ability to delay showing the HUD and using a provider to determine when to show the HUD.

This HUD is useful when you perform lots of fast async calls that sometimes can be slow. In these cases you want to have the opportunity to show a HUD is the async call happens to be slow. An example of this could be calls to Firebase.

## Demo

In this demo of the [example code](https://github.com/jcxsoftware-dev/delayed_consumer_hud/blob/master/example/lib/main.dart). We configured the HUD with a start delay of 1s. It is using a provider to set the flag to show the HUD when you press the plus button. It has a Future.delay of 2s and at the end of the delay, it sets the provider's flag to false and the HUD is hidden.

<img src="https://github.com/jcxsoftware-dev/delayed_consumer_hud/raw/master/doc/delayed_consumer_hud_demo.gif" width=400/>

## Usage

To use this plugin, add delayed_consumer_hud as a [dependency in your pubspec.yaml file](https://flutter.dev/platform-plugins/).

Show a hud with no delay and no provider:

```

var isBusy = true;

DelayedHud(
  hud: CircularProgressIndicator(),
  child: Text('DelayedHud'),
  showHud: () => _isBusy, // Update this variable when you want to show/hide the HUD
)

```

Show a hud with 1s delay and no provider. When you set the variable isBusy to true, the timer will start and once the timer reaches 1s, it will show the HUD. If you change the value of isBusy before 1s, the timer will be canceled.


```

var isBusy = true;

DelayedHud(
  hud: CircularProgressIndicator(),
  child: Text('DelayedHud'),
  delayedStart: Duration(seconds: 1),
  showHud: () => _isBusy, // Update this variable when you want to show/hide the HUD
)

```

In the following example, we will use a ChangeNotificationProvider to trigger showing the HUD. It is also using a delayed start.

When the provider changes values, the callback showHud will be called and the provider will be passed to this function. You can then check its value to determine if you need to show the HUD.

```

DelayedHud1<TestViewModel>(
  hud: hud,
  child: Text('DelayedHud1<TestViewModel>'),
  delayedStart: delay,
  showHud: (viewModel) {
    return viewModel.isBusy;
  },
)

```

There are three versions of DelayedHud + Provider to allow you to pass 1 to 3 providers to the HUD. Similar to how Consumers work.

```

DelayedHud2<TestViewModel, AnotherViewModel>(
  hud: hud,
  child: Text('Test'),
  delayedStart: delay,
  showHud: (TestViewModel testViewModel, AnotherViewModel anotherViewModel) {
    return testViewModel.isBusy || anotherViewModel.isSaving;
  },
)


```

## Customizations

Instead of using a simple Widget for the HUD, you have the alternative to return a Widget using the values of the providers passed to the control.

Instead of using hud property, use the hudWidget callback. This callback gets called when the HUD control needs to be rendered and the providers are passed as arguments. This will give you greater control on what to show.

```

DelayedHud1<TestViewModel>(
  child: Text('DelayedHud1<TestViewModel>'),
  delayedStart: delay,
  showHud: (viewModel) {
    return viewModel.isBusy;
  },
  hudWidget: (viewModel) {
    return Text(viewModel.label);
  }
)

```

## Performance

One key design characteristic of this implementation is that changes to the provider would not trigger a redraw of the HUD's child widget. We use a stack and the only HUD is wrapped with a consumer.

## Required Attributes

* child - The child that will be rendered under the HUD. Typically you want this to be a Scaffold
* showHud - Return true and the HUD widget will be shown or if there is a delayedStart defined then the timer will start. The timer will trigger showing the HUD widget.

## Optional Attributes

* color - Define the overlay color that will cover the entire screen. Ideally this widget is the root widget of your page.
* hud - The widget that you will draw as the HUD. The simplest example would be to use CircularProgressIndicator()
* delayedStart - Duration that the HUD will wait before you show it. If null, it starts automatically. Ideally, consider a duration of 250ms.
* hudWidget - This is an alternative to the hud attribute. This is a callback that lets you generate a Widget using the various providers used. This gives you additional context in case the HUD is context aware.
