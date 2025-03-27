import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class MG3Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Memory Match'),
        centerTitle: true,
      ),
      body: MemoryGameContent(),
    );
  }
}

class MemoryGameContent extends StatefulWidget {
  @override
  _MemoryGameContentState createState() => _MemoryGameContentState();
}

class _MemoryGameContentState extends State<MemoryGameContent> {
  // Game configuration
  late List<String> emojis;
  late List<String> gameCards;
  late List<bool> flipped;
  late List<bool> matched;
  List<int> selectedCards = [];
  int gridSize = 4; // 4x4 grid
  int pairsCount = 8;
  int score = 0;
  int attempts = 0;
  int secondsElapsed = 0;
  Timer? timer;
  bool gameOver = false;
  bool timeOut = false;
  int timeLimit = 60; // 60 seconds time limit
  Duration flipDelay = Duration(milliseconds: 800);

  // Lists of emojis by theme
  final List<String> animals = [
    '🐶', '🐱', '🦁', '🐯', '🐻', '🐨', '🐼', '🐸', '🦊', '🦄', '🐷', '🐮'
  ];
  
  final List<String> fruits = [
    '🍎', '🍌', '🍇', '🍉', '🍓', '🍑', '🍍', '🥝', '🍒', '🥭', '🍊', '🥑'
  ];
  
  final List<String> sports = [
    '⚽', '🏀', '🏈', '⚾', '🎾', '🏐', '🎱', '🏓', '🏸', '🥊', '🏹', '🛹'
  ];

  @override
  void initState() {
    super.initState();
    // Combine all emoji sets and shuffle
    emojis = [...animals, ...fruits, ...sports];
    emojis.shuffle();
    initializeGame();
    startTimer();
  }

  void initializeGame() {
    // Create pairs of cards
    List<String> selectedEmojis = emojis.sublist(0, pairsCount);
    gameCards = [...selectedEmojis, ...selectedEmojis];
    gameCards.shuffle();
    
    // Initialize card states
    flipped = List.generate(gameCards.length, (index) => false);
    matched = List.generate(gameCards.length, (index) => false);
    selectedCards = [];
    score = 0;
    attempts = 0;
    secondsElapsed = 0;
    gameOver = false;
    timeOut = false;
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        secondsElapsed++;
        
        // Check if time limit is reached
        if (secondsElapsed >= timeLimit && !gameOver) {
          timeOut = true;
          gameOver = true;
          timer.cancel();
          _showTimeOutDialog();
        }
      });
    });
  }

  void flipCard(int index) {
    // Prevent flipping if game is over or card is already flipped/matched
    if (gameOver || flipped[index] || matched[index]) return;

    if (selectedCards.length < 2) {
      setState(() {
        flipped[index] = true;
        selectedCards.add(index);
      });

      if (selectedCards.length == 2) {
        attempts++;
        Timer(flipDelay, checkMatch);
      }
    }
  }

  void checkMatch() {
    if (selectedCards.length != 2) return;
    
    // Check if the two cards match
    if (gameCards[selectedCards[0]] == gameCards[selectedCards[1]]) {
      setState(() {
        // Mark cards as matched
        matched[selectedCards[0]] = true;
        matched[selectedCards[1]] = true;
        
        // Update score
        score += 10;
                
        // Check if all cards are matched
        if (matched.every((isMatched) => isMatched)) {
          gameOver = true;
          timer?.cancel();
          _showGameOverDialog();
        }
      });
    } else {
      setState(() {
        // Flip cards back
        flipped[selectedCards[0]] = false;
        flipped[selectedCards[1]] = false;
        
        // Penalty for wrong match
        if (score > 0) {
          score -= 1;
        }
      });
    }
    
    // Clear selection
    selectedCards.clear();
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Congratulations!', 
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('You completed the game!'),
              SizedBox(height: 10),
              Text('Time: ${formatTime(secondsElapsed)}'),
              Text('Score: $score'),
              Text('Attempts: $attempts'),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Play Again'),
              onPressed: () {
                Navigator.of(context).pop();
                resetGame();
              },
            ),
            TextButton(
              child: Text('Exit'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showTimeOutDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Time Out!', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('You ran out of time!'),
              SizedBox(height: 10),
              Text('Final Score: $score'),
              Text('Attempts: $attempts'),
              Text('Pairs Found: ${matched.where((match) => match).length ~/ 2}/$pairsCount'),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Play Again'),
              onPressed: () {
                Navigator.of(context).pop();
                resetGame();
              },
            ),
            TextButton(
              child: Text('Exit'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void resetGame() {
    setState(() {
      gameCards.shuffle();
      flipped = List.generate(gameCards.length, (index) => false);
      matched = List.generate(gameCards.length, (index) => false);
      selectedCards = [];
      score = 0;
      attempts = 0;
      secondsElapsed = 0;
      gameOver = false;
      timeOut = false;
    });
    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Game header with info
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildInfoCard(
                'Score',
                score.toString(),
                Icons.emoji_events,
                Colors.amber,
              ),
              _buildInfoCard(
                'Time',
                formatTime(timeLimit - secondsElapsed),
                Icons.timer,
                (timeLimit - secondsElapsed) <= 10 ? Colors.red : Colors.blue,
              ),
              _buildInfoCard(
                'Attempts',
                attempts.toString(),
                Icons.touch_app,
                Colors.purple,
              ),
            ],
          ),
        ),
        
        // Game grid
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Stack(
              children: [
                GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: gridSize,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: gameCards.length,
                  itemBuilder: (context, index) {
                    return buildCard(index);
                  },
                ),
                if (timeOut) _buildTimeOutOverlay(),
              ],
            ),
          ),
        ),
        
        // Game controls
        Padding(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: resetGame,
                icon: Icon(Icons.refresh),
                label: Text('Restart'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              OutlinedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('How to Play'),
                      content: Text(
                        'Find all matching pairs before time runs out!\n\n'
                        '• Tap cards to flip them\n'
                        '• Remember card positions\n'
                        '• Match all pairs to win\n'
                        '• You have ${timeLimit} seconds'
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Got it!'),
                        ),
                      ],
                    ),
                  );
                },
                icon: Icon(Icons.help_outline),
                label: Text('Help'),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon, Color color) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 16),
            SizedBox(width: 4),
            Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildTimeOutOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.7),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.alarm_off,
              color: Colors.red,
              size: 64,
            ),
            SizedBox(height: 16),
            Text(
              'TIME OUT',
              style: TextStyle(
                color: Colors.red,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Score: $score',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                resetGame();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              ),
              child: Text('Try Again', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCard(int index) {
    return GestureDetector(
      onTap: () => flipCard(index),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        transform: flipped[index]
            ? Matrix4.identity()
            : (Matrix4.identity()..rotateY(pi)),
        transformAlignment: Alignment.center,
        child: Card(
          elevation: matched[index] ? 1 : 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: matched[index]
                ? BorderSide(color: Colors.green, width: 2)
                : BorderSide.none,
          ),
          color: matched[index]
              ? Colors.green.shade50
              : flipped[index]
                  ? Colors.white
                  : Colors.blue.shade700,
          child: Center(
            child: flipped[index] || matched[index]
                ? Text(
                    gameCards[index],
                    style: TextStyle(fontSize: 32),
                  )
                : Opacity(
                    opacity: 0.8,
                    child: Icon(
                      Icons.question_mark,
                      size: 32,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}