import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class MG2Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Memory Match'),
        centerTitle: true,
      ),
      body: const DifficultySelectionScreen(),
    );
  }
}

class DifficultySelectionScreen extends StatelessWidget {
  const DifficultySelectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Select Difficulty',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 40),
          _buildDifficultyButton(
            context,
            'Easy',
            Colors.green,
            Icons.sentiment_satisfied_outlined,
            Difficulty.easy,
          ),
          const SizedBox(height: 20),
          _buildDifficultyButton(
            context,
            'Medium',
            Colors.orange,
            Icons.sentiment_neutral_outlined,
            Difficulty.medium,
          ),
          const SizedBox(height: 20),
          _buildDifficultyButton(
            context,
            'Hard',
            Colors.red,
            Icons.sentiment_very_dissatisfied_outlined,
            Difficulty.hard,
          ),
        ],
      ),
    );
  }

  Widget _buildDifficultyButton(BuildContext context, String title, Color color,
      IconData icon, Difficulty difficulty) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MemoryGameScreen(difficulty: difficulty),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 24),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}

enum Difficulty { easy, medium, hard }

class MemoryGameScreen extends StatefulWidget {
  final Difficulty difficulty;

  const MemoryGameScreen({Key? key, required this.difficulty})
      : super(key: key);

  @override
  _MemoryGameScreenState createState() => _MemoryGameScreenState();
}

class _MemoryGameScreenState extends State<MemoryGameScreen> {
  // Emoji sets for different themes
  final List<String> fruits = [
    '🍎', '🍌', '🍇', '🍉', '🥕', '🌽', '🍒', '🍓', '🍍', '🥭', '🍊', '🥝'
  ];
  final List<String> animals = [
    '🐶', '🐱', '🐭', '🐰', '🦊', '🐻', '🐼', '🐨', '🦁', '🐯', '🦄', '🐸'
  ];
  final List<String> sports = [
    '⚽', '🏀', '🏈', '⚾', '🎾', '🏐', '🏉', '🎱', '🏓', '🏸', '🥊', '🏹'
  ];

  late List<String> allEmojis;
  late List<String> gameCards;
  late List<bool> flipped;
  late List<bool> matched;
  List<int> selectedCards = [];
  int score = 0;
  int attempts = 0;
  int secondsElapsed = 0;
  Timer? timer;
  bool gameOver = false;
  bool timeOut = false;
  late int gridSize;
  late int pairsCount;
  late Duration flipDelay;
  late int timeLimit; // Time limit in seconds

  @override
  void initState() {
    super.initState();
    allEmojis = [...fruits, ...animals, ...sports];
    allEmojis.shuffle();
    
    // Set difficulty parameters
    switch (widget.difficulty) {
      case Difficulty.easy:
        gridSize = 4; // 4x4 grid
        pairsCount = 8; // 8 pairs
        flipDelay = const Duration(milliseconds: 1000);
        timeLimit = 60; // 60 seconds for easy mode
        break;
      case Difficulty.medium:
        gridSize = 4; // 4x4 grid
        pairsCount = 8; // 8 pairs
        flipDelay = const Duration(milliseconds: 800);
        timeLimit = 45; // 45 seconds for medium mode
        break;
      case Difficulty.hard:
        gridSize = 6; // 6x6 grid
        pairsCount = 18; // 18 pairs
        flipDelay = const Duration(milliseconds: 600);
        timeLimit = 60; // 60 seconds for hard mode
        break;
    }

    initializeGame();
    startTimer();
  }

  void initializeGame() {
    // Select a subset of emojis based on difficulty
    List<String> selectedEmojis = allEmojis.sublist(0, pairsCount);
    
    // Create pairs and shuffle
    gameCards = [...selectedEmojis, ...selectedEmojis];
    gameCards.shuffle();
    
    // Initialize flipped and matched states
    flipped = List.generate(gameCards.length, (index) => false);
    matched = List.generate(gameCards.length, (index) => false);
    timeOut = false;
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
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
        
        // Update score based on difficulty
        score += widget.difficulty == Difficulty.easy 
            ? 10
            : widget.difficulty == Difficulty.medium 
                ? 20 
                : 30;
                
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
          score -= widget.difficulty == Difficulty.easy 
              ? 1
              : widget.difficulty == Difficulty.medium 
                  ? 2 
                  : 3;
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

  String getTimeRemainingText() {
    int remaining = timeLimit - secondsElapsed;
    if (remaining <= 0) return "TIME OUT";
    return formatTime(remaining);
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Congratulations!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('You completed the game!'),
              const SizedBox(height: 10),
              Text('Time: ${formatTime(secondsElapsed)}'),
              Text('Score: $score'),
              Text('Attempts: $attempts'),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Play Again'),
              onPressed: () {
                Navigator.of(context).pop();
                resetGame();
              },
            ),
            TextButton(
              child: const Text('Main Menu'),
              onPressed: () {
                Navigator.of(context).pop();
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
          title: const Text('Time Out!', style: TextStyle(color: Colors.red)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('You ran out of time!'),
              const SizedBox(height: 10),
              Text('Final Score: $score'),
              Text('Attempts: $attempts'),
              Text('Pairs Found: ${matched.where((match) => match).length ~/ 2}/${pairsCount}'),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Play Again'),
              onPressed: () {
                Navigator.of(context).pop();
                resetGame();
              },
            ),
            TextButton(
              child: const Text('Main Menu'),
              onPressed: () {
                Navigator.of(context).pop();
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
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.difficulty.name.toUpperCase()} Mode'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                timeOut ? "TIME OUT" : getTimeRemainingText(),
                style: TextStyle(
                  fontSize: 18, 
                  fontWeight: FontWeight.bold,
                  color: (timeLimit - secondsElapsed) <= 10 && !timeOut ? Colors.red : null,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoCard(
                  'Score',
                  score.toString(),
                  Colors.blue.shade100,
                  Icons.stars,
                ),
                _buildInfoCard(
                  'Attempts',
                  attempts.toString(),
                  Colors.orange.shade100,
                  Icons.touch_app,
                ),
              ],
            ),
          ),
          if (timeOut) _buildTimeOutOverlay(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                children: [
                  GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: widget.difficulty == Difficulty.hard ? 6 : 4,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: resetGame,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Restart Game',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Return to previous screen
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Back',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeOutOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.7),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'TIME OUT',
              style: TextStyle(
                color: Colors.red,
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Score: $score',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, Color color, IconData icon) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.45,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCard(int index) {
    return GestureDetector(
      onTap: () => flipCard(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        transform: flipped[index]
            ? Matrix4.identity()
            : (Matrix4.identity()..rotateY(pi)),
        transformAlignment: Alignment.center,
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: matched[index]
                ? const BorderSide(color: Colors.green, width: 2)
                : BorderSide.none,
          ),
          color: matched[index]
              ? Colors.green.shade50
              : flipped[index]
                  ? Colors.white
                  : getCardBackColor(),
          child: Center(
            child: flipped[index] || matched[index]
                ? Text(
                    gameCards[index],
                    style: const TextStyle(fontSize: 32),
                  )
                : Icon(
                    Icons.question_mark,
                    size: 32,
                    color: Colors.white,
                  ),
          ),
        ),
      ),
    );
  }

  Color getCardBackColor() {
    switch (widget.difficulty) {
      case Difficulty.easy:
        return Colors.green.shade700;
      case Difficulty.medium:
        return Colors.orange.shade700;
      case Difficulty.hard:
        return Colors.red.shade700;
    }
  }
}