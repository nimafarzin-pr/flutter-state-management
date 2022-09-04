import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

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
      home: ApiProvider(
        api: Api(),
        child: const Home(),
      ),
    );
  }
}

class Api {
  String? dateAndTime;
  Future<String> getDateAndTime() {
    return Future.delayed(
      const Duration(seconds: 1),
      () {
        return DateTime.now().toIso8601String();
      },
    ).then(
      (value) {
        dateAndTime = value;
        return value;
      },
    );
  }
}

class ApiProvider extends InheritedWidget {
  final Api api;
  final String uuid;

  ApiProvider({
    Key? key,
    required this.api,
    required Widget child,
  })  : uuid = const Uuid().v4(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant ApiProvider oldWidget) {
    return uuid != oldWidget.uuid;
  }

  static ApiProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ApiProvider>()!;
  }
}

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ValueKey _textKey = const ValueKey<String?>(null);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(ApiProvider.of(context).api.dateAndTime ?? ""),
        ),
        body: GestureDetector(
            onTap: () async {
              final api = ApiProvider.of(context).api;
              final dateAndTime = await api.getDateAndTime();
              setState(() {
                _textKey = ValueKey(dateAndTime);
              });
            },
            child: SizedBox.expand(
              child: Container(
                color: Colors.green,
                child: DateAndTimeWidget(key: _textKey),
              ),
            )));
  }
}

class DateAndTimeWidget extends StatelessWidget {
  const DateAndTimeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final api = ApiProvider.of(context).api;
    return Text(api.dateAndTime ?? "Tab on screen to fetch date time");
  }
}
