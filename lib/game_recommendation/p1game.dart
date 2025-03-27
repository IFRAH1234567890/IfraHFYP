import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

class P1Game extends StatefulWidget {
  const P1Game({super.key});

  @override
  State<P1Game> createState() => _P1GameState();
}

class _P1GameState extends State<P1Game> {
  int score = 0;
  int level = 1;
  int lives = 3;
  bool showFeedback = false;
  bool isCorrect = false;
  late String currentWord;
  late String scrambledWord;
  late List<String> letterTiles;
  List<String> userAnswer = [];
  List<int> selectedIndices = [];
  bool isGameStarted = false; // For front page

  final List<String> easyWords = [
    'CAT', 'DOG', 'SUN', 'HAT', 'BALL', 'TREE', 'FISH', 'BIRD', 'FOOD', 'PLAY',
    'JUMP', 'RUN', 'SWIM', 'READ', 'BOOK'
  ];
  
  final List<String> mediumWords = [
    'FLOWER', 'PLANET', 'MONKEY', 'TURTLE', 'RABBIT', 'GUITAR', 'PENCIL', 'ORANGE',
    'SUMMER', 'WINTER', 'SINGER', 'DOCTOR', 'BANANA', 'JACKET', 'WINDOW'
  ];
  
  final List<String> hardWords = [
    'ELEPHANT', 'DINOSAUR', 'TRIANGLE', 'COMPUTER', 'HOSPITAL', 'UMBRELLA', 'CALENDAR',
    'BIRTHDAY', 'BUTTERFLY', 'CHOCOLATE', 'ASTRONAUT', 'UNIVERSE', 'VEGETABLE', 'SANDWICH',
    'ADVENTURE'
  ];

  @override
  void initState() {
    super.initState();
    generatePuzzle();
  }

  void generatePuzzle() {
    // Select word based on level
    List<String> wordList;
    if (level <= 3) {
      wordList = easyWords;
    } else if (level <= 7) {
      wordList = mediumWords;
    } else {
      wordList = hardWords;
    }
    
    Random random = Random();
    currentWord = wordList[random.nextInt(wordList.length)];
    
    // Scramble the word
    List<String> letters = currentWord.split('');
    letters.shuffle();
    scrambledWord = letters.join();
    
    // Create letter tiles
    letterTiles = scrambledWord.split('');
    
    // Reset user answer
    userAnswer = List.filled(currentWord.length, '');
    selectedIndices = [];
    showFeedback = false;
  }

  void selectLetter(int index) {
    if (selectedIndices.contains(index) || showFeedback) {
      return;
    }
    
    setState(() {
      // Find first empty slot in user answer
      int emptySlot = userAnswer.indexOf('');
      if (emptySlot != -1) {
        userAnswer[emptySlot] = letterTiles[index];
        selectedIndices.add(index);
        
        // Check if word is complete
        if (!userAnswer.contains('')) {
          checkAnswer();
        }
      }
    });
  }

  void clearAnswers() {
    setState(() {
      userAnswer = List.filled(currentWord.length, '');
      selectedIndices = [];
    });
  }

  void checkAnswer() {
    String userWord = userAnswer.join();
    bool correct = userWord == currentWord;
    
    setState(() {
      isCorrect = correct;
      showFeedback = true;
      
      if (correct) {
        score += 10 * level;
        // Move to next level after a delay
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              level++;
              generatePuzzle();
            });
          }
        });
      } else {
        lives--;
        if (lives <= 0) {
          // Game over logic
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              showGameOverDialog();
            }
          });
        } else {
          // Clear after a delay
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              setState(() {
                clearAnswers();
                showFeedback = false;
              });
            }
          });
        }
      }
    });
  }

  void showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Game Over'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Your final score: $score'),
              Text('You reached level: $level'),
              const SizedBox(height: 10),
              Text('The word was: $currentWord'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  score = 0;
                  level = 1;
                  lives = 3;
                  generatePuzzle();
                });
              },
              child: const Text('Play Again'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  isGameStarted = false; // Return to front page
                });
              },
              child: const Text('Back to Menu'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Word Puzzle Game', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.purple,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: isGameStarted ? _buildGameScreen() : _buildFrontPage(),
    );
  }

  // Simplified Front Page with colorful elements
  Widget _buildFrontPage() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF9C27B0), // Purple
            Color(0xFF3F51B5), // Indigo
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Game logo - using a custom letter-tiles design with vibrant colors
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: 'PUZZLE'.split('').asMap().entries.map((entry) {
                int index = entry.key;
                String letter = entry.value;
                
                // Colorful tile with a different color for each letter
                List<Color> tileColors = [
                  Colors.orange,
                  Colors.red,
                  Colors.green,
                  Colors.blue,
                  Colors.yellow,
                  Colors.pink,
                ];
                
                return Container(
                  width: 50,
                  height: 50,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: tileColors[index % tileColors.length],
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    letter,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                );
              }).toList(),
            ),
            
            const SizedBox(height: 30),
            
            const Text(
              'Word Puzzle Challenge',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    blurRadius: 10.0,
                    color: Colors.black,
                    offset: Offset(2.0, 2.0),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              margin: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
              ),
              child: const Text(
                'Unscramble letters to form words and challenge your vocabulary!',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            
            const SizedBox(height: 50),
            
            // Game features section with colorful icons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildFeatureItem(Icons.speed, 'Multiple\nLevels', Colors.orange),
                _buildFeatureItem(Icons.emoji_events, 'Score\nPoints', Colors.green),
                _buildFeatureItem(Icons.lightbulb, 'Train Your\nBrain', Colors.yellow),
              ],
            ),
            
            const SizedBox(height: 50),
            
            // Start button with gradient
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: const LinearGradient(
                  colors: [Colors.orange, Colors.red],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    isGameStarted = true;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'START GAME',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // Helper method to build colorful feature items
  Widget _buildFeatureItem(IconData icon, String text, Color color) {
    return Container(
      width: 100,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
           child: Icon(
  Icons.star, // Using a specific icon from the Icons class
  size: 30,
  color: Colors.white,
),
          ),
          const SizedBox(height: 10),
          Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Colorful Game Screen Design
  Widget _buildGameScreen() {
    // Create a colorful background
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF6A1B9A), // Deep Purple
            Color(0xFF4527A0), // Deep Indigo
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Score, Level and Lives with better contrast
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Level: $level', 
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  Text('Score: $score', 
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  Row(
                    children: List.generate(3, (index) => 
                      Icon(
                        Icons.favorite,
                        color: index < lives ? Colors.red : Colors.grey.withOpacity(0.5),
                        size: 24,
                      )
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Instructions
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Text(
                'Unscramble the letters to form a word',
                style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            
            const SizedBox(height: 40),
            
            // User answer with nicer tiles
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  currentWord.length,
                  (index) => Container(
                    width: 45,
                    height: 45,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: showFeedback 
                          ? (isCorrect ? Colors.green.shade400 : Colors.red.shade400) 
                          : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 3,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      userAnswer[index],
                      style: TextStyle(
                        fontSize: 22, 
                        fontWeight: FontWeight.bold,
                        color: showFeedback ? Colors.white : Colors.purple.shade900,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Clear button with gradient
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: LinearGradient(
                  colors: [Colors.blue.shade700, Colors.blue.shade500],
                ),
              ),
              child: ElevatedButton.icon(
                onPressed: showFeedback ? null : clearAnswers,
                icon: const Icon(Icons.refresh),
                label: const Text('Clear', style: TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  shadowColor: Colors.transparent,
                  disabledBackgroundColor: Colors.grey.withOpacity(0.3),
                  disabledForegroundColor: Colors.white.withOpacity(0.5),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Letter tiles with colorful design
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 1.0,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: letterTiles.length,
                itemBuilder: (context, index) {
                  bool isSelected = selectedIndices.contains(index);
                  
                  // Create a list of vibrant colors for the tiles
                  List<Color> tileColors = [
                    Colors.pink.shade400,
                    Colors.blue.shade400,
                    Colors.orange.shade400,
                    Colors.green.shade400,
                    Colors.purple.shade400,
                    Colors.teal.shade400,
                  ];
                  
                  return InkWell(
                    onTap: () => selectLetter(index),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.grey.shade400 : tileColors[index % tileColors.length],
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        letterTiles[index],
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.grey.shade800 : Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            
            // Feedback message
            if (showFeedback)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 20, top: 10),
                decoration: BoxDecoration(
                  color: isCorrect ? Colors.green.shade600 : Colors.red.shade600,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isCorrect ? Icons.check_circle : Icons.error,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        isCorrect 
                            ? 'Correct! Well done!' 
                            : 'Incorrect! The word was "$currentWord"',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}