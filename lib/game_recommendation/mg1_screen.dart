import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class MG1Screen extends StatelessWidget {
  const MG1Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Memory Master'),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor.withOpacity(0.7),
            ],
          ),
        ),
        child: SafeArea(
          child: MemoryMasterGame(),
        ),
      ),
    );
  }
}

class MemoryMasterGame extends StatefulWidget {
  const MemoryMasterGame({Key? key}) : super(key: key);

  @override
  _MemoryMasterGameState createState() => _MemoryMasterGameState();
}

class _MemoryMasterGameState extends State<MemoryMasterGame> {
  bool _isPlaying = false;
  
  @override
  Widget build(BuildContext context) {
    return _isPlaying 
      ? const LevelSelectionScreen() 
      : HomeScreen(onStartGame: () {
          setState(() {
            _isPlaying = true;
          });
        });
  }
}

class HomeScreen extends StatelessWidget {
  final VoidCallback onStartGame;
  
  const HomeScreen({Key? key, required this.onStartGame}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Memory Master',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  blurRadius: 10.0,
                  color: Colors.black26,
                  offset: Offset(2.0, 2.0),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Train your brain with emoji recall',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 80),
          ElevatedButton(
            onPressed: onStartGame,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Theme.of(context).primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              'Start Game',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LeaderboardScreen(),
                ),
              );
            },
            child: const Text(
              'Leaderboard',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('How to Play'),
                    content: const SingleChildScrollView(
                      child: Text(
                        '1. Memorize the emojis shown on screen.\n'
                        '2. After they disappear, type the emojis in the correct order.\n'
                        '3. Score points for correct answers and speed.\n'
                        '4. Progress through increasingly difficult levels!\n\n'
                        'Tip: Focus on groups of emojis to remember more at once.',
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Got it!'),
                      ),
                    ],
                  );
                },
              );
            },
            child: const Text(
              'How to Play',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LevelSelectionScreen extends StatelessWidget {
  const LevelSelectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final levels = [
      {
        'name': 'Beginner',
        'description': '5 emojis, 5 seconds',
        'emojiCount': 5,
        'displayTime': 5,
        'icon': Icons.sentiment_satisfied,
        'color': Colors.green,
      },
      {
        'name': 'Intermediate',
        'description': '8 emojis, 4 seconds',
        'emojiCount': 8,
        'displayTime': 4,
        'icon': Icons.sentiment_neutral,
        'color': Colors.amber,
      },
      {
        'name': 'Advanced',
        'description': '12 emojis, 3 seconds',
        'emojiCount': 12,
        'displayTime': 3,
        'icon': Icons.sentiment_very_dissatisfied,
        'color': Colors.orange,
      },
      {
        'name': 'Expert',
        'description': '15 emojis, 2 seconds',
        'emojiCount': 15,
        'displayTime': 2,
        'icon': Icons.psychology,
        'color': Colors.red,
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Choose your challenge:',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: levels.length,
              itemBuilder: (context, index) {
                final level = levels[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EmojiRecallPage(
                            emojiCount: level['emojiCount'] as int,
                            displayTime: level['displayTime'] as int,
                            levelName: level['name'] as String,
                          ),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: (level['color'] as Color).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              level['icon'] as IconData,
                              color: level['color'] as Color,
                              size: 32,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  level['name'] as String,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  level['description'] as String,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class EmojiRecallPage extends StatefulWidget {
  final int emojiCount;
  final int displayTime;
  final String levelName;

  const EmojiRecallPage({
    Key? key,
    required this.emojiCount,
    required this.displayTime,
    required this.levelName,
  }) : super(key: key);

  @override
  _EmojiRecallPageState createState() => _EmojiRecallPageState();
}

class _EmojiRecallPageState extends State<EmojiRecallPage> with SingleTickerProviderStateMixin {
  // Game states
  bool _isEmojisVisible = false;
  bool _isGameActive = false;
  bool _isRecalling = false;
  bool _isGameOver = false;
  
  // Timers
  late Timer _displayTimer;
  late Timer _gameTimer;
  late Stopwatch _recallStopwatch;
  
  // Game data
  late List<String> _emojis;
  late List<String> _allEmojis;
  TextEditingController _recallController = TextEditingController();
  
  // Scoring
  int _score = 0;
  int _currentRound = 1;
  int _consecutiveCorrect = 0;
  int _timeRemaining = 0;
  
  // Animation
  late AnimationController _animationController;
  late Animation<double> _animation;

  // Emoji pool
  final List<String> _emojiPool = [
    '😀', '😃', '😄', '😁', '😆', '😅', '😂', '🤣', '😊', '😇',
    '🙂', '🙃', '😉', '😌', '😍', '🥰', '😘', '😗', '😙', '😚',
    '🍏', '🍎', '🍐', '🍊', '🍋', '🍌', '🍉', '🍇', '🍓', '🫐',
    '🍈', '🍒', '🍑', '🥭', '🍍', '🥥', '🥝', '🍅', '🍆', '🥑',
    '🐶', '🐱', '🐭', '🐹', '🐰', '🦊', '🐻', '🐼', '🐻‍❄️', '🐨',
    '🐯', '🦁', '🐮', '🐷', '🐸', '🐵', '🙈', '🙉', '🙊', '🐒',
    '⚽', '🏀', '🏈', '⚾', '🥎', '🎾', '🏐', '🏉', '🎱', '🏓',
    '🪀', '🪁', '🎯', '🎮', '🎲', '🎭', '🪄', '🧩', '♟️', '🎨',
  ];

  String _feedbackMessage = '';
  Color _feedbackColor = Colors.blue;
  
  @override
  void initState() {
    super.initState();
    _recallStopwatch = Stopwatch();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _allEmojis = List.from(_emojiPool);
    _allEmojis.shuffle();
    _initializeGame();
  }
  
  void _initializeGame() {
    _timeRemaining = 60; // 60 seconds for the entire game
    _isGameActive = true;
    _startGameTimer();
    _startNextRound();
  }
  
  void _startGameTimer() {
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeRemaining > 0) {
          _timeRemaining--;
        } else {
          _endGame();
        }
      });
    });
  }
  
  void _startNextRound() {
    // Generate new emojis for this round
    _generateRandomEmojis();
    
    // Reset UI state
    setState(() {
      _isEmojisVisible = true;
      _isRecalling = false;
      _recallController.clear();
      _feedbackMessage = '';
    });
    
    // Show emojis for the specified time
    _displayTimer = Timer(Duration(seconds: widget.displayTime), () {
      setState(() {
        _isEmojisVisible = false;
        _isRecalling = true;
        // Start the stopwatch to measure recall time
        _recallStopwatch.reset();
        _recallStopwatch.start();
      });
      _animationController.forward(from: 0.0);
    });
  }
  
  void _generateRandomEmojis() {
    // Ensure we have enough unique emojis
    if (_allEmojis.length < widget.emojiCount) {
      _allEmojis = List.from(_emojiPool);
      _allEmojis.shuffle();
    }
    
    // Take the first n emojis from the shuffled list
    _emojis = _allEmojis.take(widget.emojiCount).toList();
    // Remove used emojis from the pool
    _allEmojis.removeRange(0, widget.emojiCount);
  }
  
  void _checkRecall() {
    _recallStopwatch.stop();
    String recallInput = _recallController.text.trim();
    String correctEmojis = _emojis.join('');
    
    // Calculate match percentage
    int matchCount = 0;
    for (int i = 0; i < min(recallInput.length, correctEmojis.length); i++) {
      if (i < recallInput.length && i < correctEmojis.length && recallInput[i] == correctEmojis[i]) {
        matchCount++;
      }
    }
    
    double matchPercentage = correctEmojis.isEmpty ? 0 : matchCount / correctEmojis.length;
    int basePoints = (matchPercentage * 100).round();
    
    // Time bonus: faster recall = more points
    int maxRecallTime = widget.displayTime * 2000; // milliseconds
    int actualRecallTime = _recallStopwatch.elapsedMilliseconds;
    double timeBonus = max(0, 1 - (actualRecallTime / maxRecallTime));
    int timeBonusPoints = (timeBonus * 50).round();
    
    // Streak bonus
    int streakBonus = 0;
    if (matchPercentage >= 0.9) { // 90% or better is considered correct
      _consecutiveCorrect++;
      streakBonus = min(50, _consecutiveCorrect * 5); // Cap at 50 points
    } else {
      _consecutiveCorrect = 0;
    }
    
    // Calculate total points for this round
    int roundScore = basePoints + timeBonusPoints + streakBonus;
    _score += roundScore;
    
    // Prepare feedback message
    setState(() {
      if (matchPercentage >= 0.9) {
        _feedbackColor = Colors.green;
        _feedbackMessage = 'Great job! ${(matchPercentage * 100).round()}% correct\n'
                          '+$basePoints base points\n'
                          '+$timeBonusPoints speed bonus\n'
                          '+$streakBonus streak bonus\n'
                          'Total: +$roundScore points';
      } else if (matchPercentage >= 0.6) {
        _feedbackColor = Colors.orange;
        _feedbackMessage = 'Not bad! ${(matchPercentage * 100).round()}% correct\n'
                          '+$basePoints base points\n'
                          '+$timeBonusPoints speed bonus\n'
                          'Total: +$roundScore points';
      } else {
        _feedbackColor = Colors.red;
        _feedbackMessage = 'Try again! ${(matchPercentage * 100).round()}% correct\n'
                          'Correct sequence: $correctEmojis\n'
                          'Your input: $recallInput\n'
                          '+$basePoints base points';
      }
      
      _isRecalling = false;
      _currentRound++;
    });
    
    // Wait 3 seconds before starting next round
    Timer(const Duration(seconds: 3), () {
      if (_isGameActive && !_isGameOver) {
        _startNextRound();
      }
    });
  }
  
  void _endGame() {
    _gameTimer.cancel();
    if (_displayTimer.isActive) {
      _displayTimer.cancel();
    }
    
    setState(() {
      _isGameActive = false;
      _isGameOver = true;
      _isEmojisVisible = false;
      _isRecalling = false;
    });
    
    // Show game summary
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Game Over'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Final Score: $_score',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text('Level: ${widget.levelName}'),
              Text('Rounds Completed: ${_currentRound - 1}'),
              const SizedBox(height: 20),
              const Text('How did you do?'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Return to level selection
              },
              child: const Text('Back to Levels'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Reset and restart the game
                setState(() {
                  _score = 0;
                  _currentRound = 1;
                  _consecutiveCorrect = 0;
                  _isGameOver = false;
                });
                _initializeGame();
              },
              child: const Text('Play Again'),
            ),
          ],
        );
      },
    );
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    if (_gameTimer.isActive) {
      _gameTimer.cancel();
    }
    if (_displayTimer.isActive) {
      _displayTimer.cancel();
    }
    _recallController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Level: ${widget.levelName}'),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Row(
                children: [
                  const Icon(Icons.timer, size: 20),
                  const SizedBox(width: 4),
                  Text(
                    '$_timeRemaining s',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Score and round info
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Score: $_score',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Round: $_currentRound',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              // Game area
              Expanded(
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _buildGameContent(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildGameContent() {
    if (_isEmojisVisible) {
      // Show emojis to memorize
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Memorize these emojis!',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: _emojis.map((emoji) {
              return Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  emoji,
                  style: const TextStyle(fontSize: 36),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 30),
          // Countdown timer
          Text(
            'Time remaining: ${widget.displayTime} seconds',
            style: const TextStyle(fontSize: 18),
          ),
        ],
      );
    } else if (_isRecalling) {
      // Show input field for recall
      return FadeTransition(
        opacity: _animation,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'What were the emojis?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Type them in the correct order',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _recallController,
              decoration: InputDecoration(
                labelText: 'Enter the emojis',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              style: const TextStyle(fontSize: 20),
              autofocus: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _checkRecall,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Submit Answer',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      );
    } else if (_feedbackMessage.isNotEmpty) {
      // Show feedback after checking recall
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Results',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: _feedbackColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _feedbackColor),
            ),
            child: Text(
              _feedbackMessage,
              style: TextStyle(
                fontSize: 18,
                color: _feedbackColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 30),
          const Text(
            'Get ready for the next round...',
            style: TextStyle(fontSize: 16),
          ),
        ],
      );
    } else if (_isGameOver) {
      // Game over screen
      return const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Game Over!',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Text(
            'See your final results',
            style: TextStyle(fontSize: 20),
          ),
        ],
      );
    } else {
      // Initial state or loading
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sample leaderboard data (in a real app, this would come from a database)
    final leaderboardData = [
      {'name': 'Alex', 'score': 950, 'level': 'Expert'},
      {'name': 'Sam', 'score': 875, 'level': 'Advanced'},
      {'name': 'Taylor', 'score': 820, 'level': 'Expert'},
      {'name': 'Jordan', 'score': 780, 'level': 'Intermediate'},
      {'name': 'Riley', 'score': 720, 'level': 'Advanced'},
      {'name': 'Casey', 'score': 690, 'level': 'Intermediate'},
      {'name': 'Morgan', 'score': 650, 'level': 'Advanced'},
      {'name': 'Drew', 'score': 620, 'level': 'Beginner'},
      {'name': 'Jamie', 'score': 580, 'level': 'Intermediate'},
      {'name': 'Quinn', 'score': 540, 'level': 'Beginner'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Top Players',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: leaderboardData.length,
                itemBuilder: (context, index) {
                  final entry = leaderboardData[index];
                  return Card(
                    elevation: index < 3 ? 4 : 2,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: index == 0
                              ? Colors.amber
                              : index == 1
                                  ? Colors.grey[300]
                                  : index == 2
                                      ? Colors.brown[300]
                                      : Colors.blue[100],
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: index < 3 ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        entry['name'] as String,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      subtitle: Text('Level: ${entry['level']}'),
                      trailing: Text(
                        '${entry['score']}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Back to Game'),
            ),
          ],
        ),
      ),
    );
  }
}