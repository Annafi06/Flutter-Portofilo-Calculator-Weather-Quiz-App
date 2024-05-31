import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const QuizApp());
}

enum QuizMode {
  Normal,
  Timed,
  Practice,
}

class QuizApp extends StatelessWidget {
  const QuizApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const QuizPage(),
    );
  }
}

class QuizPage extends StatefulWidget {
  const QuizPage({Key? key}) : super(key: key);

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final List<Category> _categories = [
    Category('Geography', [
      Question('The capital of France is Paris.', true),
      Question('The capital of Japan is Beijing.', false),
    ]),
    Category('Science', [
      Question('The earth is flat.', false),
      Question('Flutter is developed by Google.', true),
    ]),
  ];

  int _currentCategoryIndex = 0;
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _showScore = false;
  bool _showFeedback = false;
  QuizMode _quizMode = QuizMode.Normal;

  late Timer _timer;
  int _secondsRemaining = 0;

  void _answerQuestion(bool answer) {
    setState(() {
      if (_categories[_currentCategoryIndex].questions[_currentQuestionIndex].answer == answer) {
        _score++;
        _showFeedback = true;
      } else {
        _showFeedback = false;
      }
      if (_currentQuestionIndex < _categories[_currentCategoryIndex].questions.length - 1) {
        _currentQuestionIndex++;
      } else {
        if (_currentCategoryIndex < _categories.length - 1) {
          _currentCategoryIndex++;
          _currentQuestionIndex = 0;
        } else {
          _showScore = true;
          if (_quizMode == QuizMode.Timed) {
            _timer.cancel();
          }
        }
      }
    });
  }

  void _resetQuiz() {
    setState(() {
      _score = 0;
      _currentCategoryIndex = 0;
      _currentQuestionIndex = 0;
      _showScore = false;
      _showFeedback = false;
      if (_quizMode == QuizMode.Timed) {
        _startTimer();
      }
    });
  }

  void _startTimer() {
    _secondsRemaining = 60; // Change to desired time
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          timer.cancel();
          _answerQuestion(false); // Auto submit if time runs out
        }
      });
    });
  }

  void _startQuiz(QuizMode mode) {
    setState(() {
      _quizMode = mode;
      _resetQuiz();
      if (_quizMode == QuizMode.Timed) {
        _startTimer();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz App'),
      ),
      body: _showScore
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Your Score: $_score/${_categories.fold(0, (sum, cat) => sum + cat.questions.length)}',
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _resetQuiz,
                    child: const Text('Restart Quiz'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to the leaderboard screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LeaderboardScreen()),
                      );
                    },
                    child: const Text('View Leaderboard'),
                  ),
                ],
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButton<QuizMode>(
                  value: _quizMode,
                  onChanged: (mode) => _startQuiz(mode!),
                  items: [
                    const DropdownMenuItem(
                      value: QuizMode.Normal,
                      child: Text('Normal'),
                    ),
                    const DropdownMenuItem(
                      value: QuizMode.Timed,
                      child: Text('Timed'),
                    ),
                    const DropdownMenuItem(
                      value: QuizMode.Practice,
                      child: Text('Practice'),
                    ),
                  ],
                ),
                if (_quizMode != QuizMode.Normal)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Mode: ${_quizMode.toString().split('.').last}',
                      style: const TextStyle(fontSize: 22),
                    ),
                  ),
                if (_quizMode == QuizMode.Timed)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Time Remaining: $_secondsRemaining seconds',
                      style: const TextStyle(fontSize: 22),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Category: ${_categories[_currentCategoryIndex].name}',
                    style: const TextStyle(fontSize: 22),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Question ${_currentQuestionIndex + 1}/${_categories[_currentCategoryIndex].questions.length}',
                    style: const TextStyle(fontSize: 22),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    _categories[_currentCategoryIndex].questions[_currentQuestionIndex].questionText,
                    style: const TextStyle(fontSize: 22),
                  ),
                ),
                if (_showFeedback)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      _score == 1 ? 'Correct!' : 'Incorrect!',
                      style: TextStyle(fontSize: 22, color: _score == 1 ? Colors.green : Colors.red),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () => _answerQuestion(true),
                    child: const Text('True'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () => _answerQuestion(false),
                    child: const Text('False'),
                  ),
                ),
              ],
            ),
    );
  }
}

class Question {
  final String questionText;
  final bool answer;

  Question(this.questionText, this.answer);
}

class Category {
  final String name;
  final List<Question> questions;

  Category(this.name, this.questions);
}

class LeaderboardScreen extends StatelessWidget {
  // Sample leaderboard data
  final List<Map<String, dynamic>> _leaderboardData = [
    {'name': 'Player 1', 'score': 20},
    {'name': 'Player 2', 'score': 18},
    {'name': 'Player 3', 'score': 15},
    {'name': 'Player 4', 'score': 14},
    {'name': 'Player 5', 'score': 12},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leaderboard'),
      ),
      body: ListView.builder(
        itemCount: _leaderboardData.length,
        itemBuilder: (context, index) {
          final player = _leaderboardData[index];
          return ListTile(
            leading: Text('${index + 1}'), // Display rank
            title: Text(player['name']), // Display player name
            trailing: Text('${player['score']}'), // Display player score
          );
        },
      ),
    );
  }
}

