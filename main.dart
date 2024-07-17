import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Define the CounterModel with ChangeNotifier
class CounterModel with ChangeNotifier {
  int _count = 0;

  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }

  void decrement() {
    _count--;
    notifyListeners();
  }

  void reset() {
    _count = 0;
    notifyListeners();
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CounterModel(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple)
            .copyWith(secondary: Colors.yellow),
        scaffoldBackgroundColor: Colors.purple.shade50,
        textTheme: TextTheme(
          headlineMedium: TextStyle(
            color: Colors.purple.shade900,
            fontWeight: FontWeight.bold,
          ),
        ),
        appBarTheme: AppBarTheme(
          color: Colors.purple.shade700,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.yellow,
        ),
      ),
      home: CounterScreen(),
    );
  }
}

class CounterScreen extends StatefulWidget {
  @override
  _CounterScreenState createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Counter App'),
      ),
      body: Center(
        child: CounterText(),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FloatingActionButton(
              onPressed: () {
                Provider.of<CounterModel>(context, listen: false).increment();
                _showSnackbar(context, 'Incremented!');
              },
              tooltip: 'Increment',
              child: Icon(Icons.add),
            ),
            SizedBox(width: 16),
            FloatingActionButton(
              onPressed: () {
                Provider.of<CounterModel>(context, listen: false).decrement();
                _showSnackbar(context, 'Decremented!');
              },
              tooltip: 'Decrement',
              child: Icon(Icons.remove),
            ),
            SizedBox(width: 16),
            FloatingActionButton(
              onPressed: () {
                Provider.of<CounterModel>(context, listen: false).reset();
                _showSnackbar(context, 'Reset!');
              },
              tooltip: 'Reset',
              child: Icon(Icons.refresh),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.purple,
        onTap: _onItemTapped,
      ),
    );
  }
}

class CounterText extends StatefulWidget {
  @override
  _CounterTextState createState() => _CounterTextState();
}

class _CounterTextState extends State<CounterText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CounterModel>(
      builder: (context, counter, child) {
        _controller.forward(from: 0.0); // Restart the animation
        return FadeTransition(
          opacity: _animation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '${counter.count}',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              if (counter.count == 0)
                Text(
                  'Counter is at zero',
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
