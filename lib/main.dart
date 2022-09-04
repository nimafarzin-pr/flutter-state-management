import 'dart:math';

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

class _HomeState extends State<Home> {
  MaterialColor color1 = Colors.blue;
  MaterialColor color2 = Colors.amber;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home page')),
      body: AvailableColorWidget(
          color1: color1,
          color2: color2,
          child: Column(
            children: [
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        color1 = colors.getRandomElememt() as MaterialColor;
                      });
                    },
                    child: const Text(
                      'Change color 1',
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        color2 = colors.getRandomElememt() as MaterialColor;
                      });
                    },
                    child: const Text(
                      'Change color 2',
                      style: TextStyle(color: Colors.green),
                    ),
                  )
                ],
              ),
              const ColorWidget(colors: AvailableColors.one),
              const ColorWidget(colors: AvailableColors.two)
            ],
          )),
    );
  }
}

enum AvailableColors { one, two }

final colors = [
  Colors.amber,
  Colors.red,
  Colors.green,
  Colors.yellow,
  Colors.black,
  Colors.blue,
  Colors.pink,
  Colors.purple,
];

extension RandomElement<T> on Iterable<T> {
  T getRandomElememt() => elementAt(
        Random().nextInt(length),
      );
}

class AvailableColorWidget extends InheritedModel<AvailableColors> {
  final MaterialColor color1;
  final MaterialColor color2;

  const AvailableColorWidget({
    Key? key,
    required this.color1,
    required this.color2,
    required Widget child,
  }) : super(
          key: key,
          child: child,
        );

  static AvailableColorWidget of(BuildContext context, AvailableColors aspect) {
    return InheritedModel.inheritFrom<AvailableColorWidget>(context,
        aspect: aspect)!;
  }

  @override
  bool updateShouldNotify(covariant AvailableColorWidget oldWidget) {
    print("updateShouldNotify");
    return color1 != oldWidget.color1 || color2 != oldWidget.color2;
  }

  @override
  bool updateShouldNotifyDependent(covariant AvailableColorWidget oldWidget,
      Set<AvailableColors> dependencies) {
    if (dependencies.contains(AvailableColors.one) &&
        color1 != oldWidget.color1) {
      return true;
    }
    if (dependencies.contains(AvailableColors.two) &&
        color2 != oldWidget.color2) {
      return true;
    }
    print("updateShouldNotifyDependent");
    return false;
  }
}

class ColorWidget extends StatelessWidget {
  final AvailableColors colors;
  const ColorWidget({
    Key? key,
    required this.colors,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (colors) {
      case AvailableColors.one:
        print('Color one widget is rebuild');
        break;

      case AvailableColors.two:
        print('Color two widget is rebuild');
        break;
      default:
    }
    final provider = AvailableColorWidget.of(context, colors);
    return Container(
      height: 100,
      color: colors == AvailableColors.one ? provider.color1 : provider.color2,
    );
  }
}
