import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(PomodoroApp());
}

class PomodoroApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pomodoro Timer',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        primaryColor: Colors.blueGrey[900],
      ),
      home: PomodoroPage(),
    );
  }
}

class PomodoroPage extends StatefulWidget {
  @override
  _PomodoroPageState createState() => _PomodoroPageState();
}

class _PomodoroPageState extends State<PomodoroPage> {
  int cycles = 0;
  List<String> notes = [];
  Timer? timer;
  bool isRunning = false;
  int seconds = 0;
  int minutes = 25;

  void startPomodoro() {
    if (!isRunning) {
      setState(() {
        cycles++;
        isRunning = true;
      });

      timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
        setState(() {
          if (seconds > 0) {
            seconds--;
          } else {
            if (minutes > 0) {
              minutes--;
              seconds = 59;
            } else {
              timer.cancel();
              isRunning = false;
              minutes = 25;
              seconds = 0;
            }
          }
        });
      });
    }
  }

  void addNote() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String noteText = '';

        return AlertDialog(
          title: Text('Add Note'),
          content: TextField(
            onChanged: (value) {
              noteText = value;
            },
            decoration: InputDecoration(hintText: 'Enter your note'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                setState(() {
                  notes.add(noteText);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pomodoro Timer'),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                  '•'*cycles,
                  style: TextStyle(fontSize: 36),
                ),
                Text(
                  '$minutes:${seconds.toString().padLeft(2, '0')}',
                  style: TextStyle(fontSize: 160),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  child: Text(isRunning ? 'Stop Pomodoro' : 'Start Pomodoro'),
                  onPressed: () {
                    if (isRunning) {
                      timer?.cancel();
                      setState(() {
                        isRunning = false;
                        minutes = 25;
                        seconds = 0;
                      });
                    } else {
                      startPomodoro();
                    }
                  },
                ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              children: [
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('Add Note'),
                onPressed: addNote,
              ),
              SizedBox(height: 20),
              Text(
                'Notes:',
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(
                height: 200,
                width: MediaQuery.of(context).size.width/3,
                child: ListView.builder(
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(notes[index]),
                    );
                  },
                ),
              ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
