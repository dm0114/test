import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Routine App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RoutineListPage(),
    );
  }
}

class RoutineListPage extends StatefulWidget {
  @override
  _RoutineListPageState createState() => _RoutineListPageState();
}

class _RoutineListPageState extends State<RoutineListPage> {
  final _textController = TextEditingController();
  List<String> _routines = [];

  @override
  void initState() {
    super.initState();
    _loadRoutines();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Routine App'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: _routines.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(_routines[index]),
                  background: Container(
                    color: Colors.red,
                  ),
                  onDismissed: (direction) {
                    setState(() {
                      _routines.removeAt(index);
                      _saveRoutines();
                    });
                  },
                  child: ListTile(
                    title: Text(_routines[index]),
                  ),
                );
              },
            ),
          ),
          TextField(
            controller: _textController,
            decoration: InputDecoration(
              hintText: 'Enter a new routine',
            ),
          ),
          ElevatedButton(
            child: Text('Add'),
            onPressed: () {
              setState(() {
                _routines.add(_textController.text);
                _textController.clear();
                _saveRoutines();
              });
            },
          ),
        ],
      ),
    );
  }

  Future<void> _loadRoutines() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> routines = prefs.getStringList('routines') ?? [];
    setState(() {
      if (routines == null || routines.isEmpty) {
        routines = [
          'Take a shower',
          'Brush your teeth',
          'Make your bed',
          'Have breakfast',
          'Go for a walk',
        ];
      }
      _routines = routines;
      _saveRoutines();
    });
  }

  Future<void> _saveRoutines() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('routines', _routines);
  }
}
