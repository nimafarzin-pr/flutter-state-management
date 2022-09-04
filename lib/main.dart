import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

final sliderData = SliderData();

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home page')),
      body: SliderInheritedNotifire(
        sliderData: sliderData,
        //inclode the context of SliderInheritedNotifire
        // if dont use builder then context point to build and notifire dont work
        child: Builder(builder: (context) {
          return Column(
            children: [
              Slider(
                value: SliderInheritedNotifire.of(context),
                onChanged: (value) {
                  sliderData.value = value;
                },
              ),
              Row(
                children: [
                  Opacity(
                    opacity: SliderInheritedNotifire.of(context),
                    child: Container(
                      height: 200,
                      color: Colors.amber,
                    ),
                  ),
                  Opacity(
                    opacity: SliderInheritedNotifire.of(context),
                    child: Container(
                      height: 200,
                      color: Colors.blue,
                    ),
                  ),
                ].expandedEqualy().toList(),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class SliderData extends ChangeNotifier {
  double _value = 0.0;
  double get value => _value;

  set value(double newValue) {
    if (newValue != _value) {
      _value = newValue;
      notifyListeners();
    }
  }
}

class SliderInheritedNotifire extends InheritedNotifier<SliderData> {
  const SliderInheritedNotifire({
    Key? key,
    required SliderData sliderData,
    required Widget child,
  }) : super(
          key: key,
          child: child,
          notifier: sliderData,
        );

  static double of(BuildContext context) {
    return context
            .dependOnInheritedWidgetOfExactType<SliderInheritedNotifire>()
            ?.notifier
            ?.value ??
        0.0;
  }
}

extension ExpandedEqualu on Iterable<Widget> {
  Iterable<Widget> expandedEqualy() => map(
        (widget) => Expanded(child: widget),
      );
}
