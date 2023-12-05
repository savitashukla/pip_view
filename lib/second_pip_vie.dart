import 'package:floating/floating.dart';
import 'package:flutter/material.dart';
import 'package:pip_view/pip_view.dart';
class ExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}
class HomeScreen extends StatefulWidget  {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {


  final floating = Floating();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    floating.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState lifecycleState) {
    if (lifecycleState == AppLifecycleState.inactive) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>  HomeScreen()),
      );
      floating.enable(Rational.square());
    }
  }

  Future<void> enablePip() async {
    final status = await floating.enable(Rational.landscape());
    debugPrint('PiP enabled? $status');
  }

  @override
  Widget build(BuildContext context) {
    return PIPView(
      builder: (context, isFloating) {
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text('This page will float!'),
                  MaterialButton(
                    color: Theme.of(context).primaryColor,
                    child: Text('Start floating!'),
                    onPressed: () {
                      PIPView.of(context)!.presentBelow(BackgroundScreen());
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class BackgroundScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text('This is the background page!'),
              Text('If you tap on the floating screen, it stops floating.'),
              Text('Navigation works as expected.'),
              MaterialButton(
                color: Theme.of(context).primaryColor,
                child: Text('Push to navigation'),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => NavigatedScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NavigatedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Navigated Screen'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text('This is the page you navigated to.'),
              Text('See how it stays below the floating page?'),
              Text('Just amazing!'),
              Spacer(),
              Text('It also avoids keyboard!'),
              TextField(),
            ],
          ),
        ),
      ),
    );
  }
}