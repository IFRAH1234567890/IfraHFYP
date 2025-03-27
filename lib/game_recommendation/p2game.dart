import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class P2Game extends StatelessWidget {
  const P2Game({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Math Challenge'),
        backgroundColor: Colors.purple.shade700,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.purple.shade100, Colors.blue.shade50],
          ),
        ),
        child: const MathGameContent(),
      ),
    );
  }
}

class MathGameContent extends StatefulWidget {
  const MathGameContent({Key? key}) : super(key: key);

  @override
  State<MathGameContent> createState() => _MathGameContentState();
}

class _MathGameContentState extends State<MathGameContent> {
  int score = 0;
  int currentLevel = 1;
  List<Problem> problems = [];
  int currentProblemIndex = 0;
  bool isGameStarted = false;
  bool isGameComplete = false;
  late Timer timer;
  int timeLeft = 0;
  int totalTime = 0;
  final TextEditingController answerController = TextEditingController();
  String feedback = '';
  bool? isCorrect;
  int stars = 0;

  @override
  void dispose() {
    if (isGameStarted && !isGameComplete) {
      timer.cancel();
    }
    answerController.dispose();
    super.dispose();
  }

  void startGame() {
    setState(() {
      isGameStarted = true;
      isGameComplete = false;
      score = 0;
      currentProblemIndex = 0;
      problems = generateProblems(currentLevel);
      startProblem();
    });
  }

  void startProblem() {
    totalTime = getTimeForLevel(currentLevel);
    timeLeft = totalTime;
    feedback = '';
    isCorrect = null;
    answerController.clear();
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        if (timeLeft > 0) {
          timeLeft--;
        } else {
          handleAnswer(null);
        }
      });
    });
  }

  void handleAnswer(String? userAnswer) {
    timer.cancel();
    Problem currentProblem = problems[currentProblemIndex];
    int earnedPoints = 0;
    bool correct = false;

    if (userAnswer != null) {
      correct = userAnswer.trim() == currentProblem.answer.toString();
      if (correct) {
        double timeRatio = timeLeft / totalTime;
        earnedPoints = ((timeRatio * 50) + 50).round();
      }
    }

    setState(() {
      isCorrect = correct;
      feedback = correct ? '✅ Correct! +$earnedPoints points' : '❌ Incorrect. The answer was ${currentProblem.answer}';
      score += earnedPoints;
    });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        if (currentProblemIndex < problems.length - 1) {
          currentProblemIndex++;
          startProblem();
        } else {
          isGameComplete = true;
          calculateStars();
        }
      });
    });
  }

  void calculateStars() {
    int maxScore = problems.length * 100;
    double percentage = score / maxScore;

    if (percentage >= 0.9) {
      stars = 3;
    } else if (percentage >= 0.7) {
      stars = 2;
    } else if (percentage >= 0.5) {
      stars = 1;
    } else {
      stars = 0;
    }
  }

  void restartGame() {
    setState(() {
      isGameStarted = false;
      isGameComplete = false;
    });
  }

  void nextLevel() {
    setState(() {
      currentLevel++;
      isGameStarted = false;
      isGameComplete = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isGameStarted) {
      return _buildStartScreen();
    } else if (isGameComplete) {
      return _buildCompletionScreen();
    } else {
      return _buildGameScreen();
    }
  }

  Widget _buildStartScreen() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '🧮 Math Challenge 🧮',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.purple.shade800,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple.shade200.withOpacity(0.5),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'Level $currentLevel',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple.shade700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildLevelDescription(),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: startGame,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple.shade700,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      '🎮 Start Game',
                      style: TextStyle(fontSize: 18),
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

  Widget _buildLevelDescription() {
    int difficulty = (currentLevel - 1) ~/ 3;
    String description;
    String emoji;

    switch (difficulty) {
      case 0:
        description = 'Basic addition and subtraction';
        emoji = '😊';
        break;
      case 1:
        description = 'Multiplication and division';
        emoji = '🤔';
        break;
      case 2:
        description = 'Mixed operations and parentheses';
        emoji = '😮';
        break;
      case 3:
        description = 'Percentages and averages';
        emoji = '🤯';
        break;
      default:
        description = 'Complex calculations';
        emoji = '🧠';
    }

    return Column(
      children: [
        Text(
          emoji,
          style: const TextStyle(fontSize: 36),
        ),
        const SizedBox(height: 10),
        Text(
          description,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Text(
          'Solve ${problems.isEmpty ? 5 : problems.length} problems in ${getTimeForLevel(currentLevel)} seconds each',
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black54,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildGameScreen() {
    Problem currentProblem = problems[currentProblemIndex];
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '📝 Problem ${currentProblemIndex + 1}/${problems.length}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  '🏆 $score',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          LinearProgressIndicator(
            value: timeLeft / totalTime,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(
              timeLeft < totalTime * 0.3 ? Colors.red : Colors.purple.shade700,
            ),
          ),
          Text(
            '⏱️ $timeLeft seconds',
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.purple.shade100.withOpacity(0.5),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  currentProblem.emoji + " " + currentProblem.question,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                if (currentProblem.options.isEmpty) ...[
                  TextField(
                    controller: answerController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                      hintText: 'Enter your answer',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onSubmitted: (value) {
                      handleAnswer(value);
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      handleAnswer(answerController.text);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple[700],
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const Text(
                      '📤 Submit',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ] else ...[
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 2.5,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: currentProblem.options.length,
                    itemBuilder: (context, index) {
                      return ElevatedButton(
                        onPressed: () {
                          handleAnswer(currentProblem.options[index].toString());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.purple.shade800,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: Colors.purple.shade300, width: 2),
                          ),
                        ),
                        child: Text(
                          currentProblem.options[index].toString(),
                          style: const TextStyle(fontSize: 18),
                        ),
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          AnimatedOpacity(
            opacity: feedback.isNotEmpty ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: Text(
              feedback,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isCorrect == true ? Colors.green : Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletionScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '🎉 Level Complete! 🎉',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.purple,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              return Icon(
                index < stars ? Icons.star : Icons.star_border,
                color: Colors.amber,
                size: 48,
              );
            }),
          ),
          const SizedBox(height: 20),
          Text(
            '🏆 Your Score: $score',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: restartGame,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  '🔄 Try Again',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: stars > 0 ? nextLevel : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple.shade700,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  '⏭️ Next Level',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Problem> generateProblems(int level) {
    List<Problem> levelProblems = [];
    int problemCount = 5;

    for (int i = 0; i < problemCount; i++) {
      Problem problem;
      int difficulty = (level - 1) ~/ 3;

      switch (difficulty) {
        case 0:
          problem = generateBasicProblem(level);
          break;
        case 1:
          problem = generateIntermediateProblem(level);
          break;
        case 2:
          problem = generateAdvancedProblem(level);
          break;
        case 3:
          problem = generateExpertProblem(level);
          break;
        default:
          problem = generateBasicProblem(level);
      }

      levelProblems.add(problem);
    }

    return levelProblems;
  }

  Problem generateBasicProblem(int level) {
    Random random = Random();
    String emoji = "";
    int a, b;
    int operation = random.nextInt(2);

    int levelWithinRange = level % 3 == 0 ? 3 : level % 3;
    int maxNum = 5 + (levelWithinRange * 3);

    a = random.nextInt(maxNum) + 1;
    b = random.nextInt(maxNum) + 1;

    if (operation == 0) {
      emoji = "➕";
      return Problem(
        question: '$a + $b = ?',
        answer: a + b,
        options: generateOptions(a + b, maxNum * 2),
        emoji: emoji,
      );
    } else {
      emoji = "➖";
      if (a < b) {
        int temp = a;
        a = b;
        b = temp;
      }
      return Problem(
        question: '$a - $b = ?',
        answer: a - b,
        options: generateOptions(a - b, maxNum),
        emoji: emoji,
      );
    }
  }

  Problem generateIntermediateProblem(int level) {
    Random random = Random();
    String emoji = "";
    int levelWithinRange = level % 3 == 0 ? 3 : level % 3;
    int maxA = 5 + (levelWithinRange * 2);
    int maxB = 5 + levelWithinRange;

    int operation = random.nextInt(3);

    if (operation == 0) {
      emoji = "✖️";
      int a = random.nextInt(maxA) + 1;
      int b = random.nextInt(maxB) + 1;
      return Problem(
        question: '$a × $b = ?',
        answer: a * b,
        options: generateOptions(a * b, a * b * 2),
        emoji: emoji,
      );
    } else if (operation == 1) {
      emoji = "➗";
      int b = random.nextInt(maxB) + 1;
      int a = b * (random.nextInt(maxA) + 1);
      return Problem(
        question: '$a ÷ $b = ?',
        answer: a ~/ b,
        options: generateOptions(a ~/ b, maxA + 5),
        emoji: emoji,
      );
    } else {
      emoji = "🔢";
      int a = random.nextInt(maxA) + 1;
      int b = random.nextInt(maxB) + 1;
      int c = random.nextInt(maxB) + 1;
      return Problem(
        question: '$a + $b × $c = ?',
        answer: a + (b * c),
        options: generateOptions(a + (b * c), (a + b) * c),
        emoji: emoji,
      );
    }
  }

  Problem generateAdvancedProblem(int level) {
    Random random = Random();
    String emoji = "";
    int levelWithinRange = level % 3 == 0 ? 3 : level % 3;
    int maxNum = 10 + (levelWithinRange * 5);

    int problemType = random.nextInt(3);

    if (problemType == 0) {
      emoji = "🧮";
      int a = random.nextInt(maxNum) + 1;
      int b = random.nextInt(maxNum) + 1;
      int c = random.nextInt(maxNum ~/ 2) + 1;

      int operationType = random.nextInt(2);
      if (operationType == 0) {
        return Problem(
          question: '($a + $b) × $c = ?',
          answer: (a + b) * c,
          options: [],
          emoji: emoji,
        );
      } else {
        return Problem(
          question: '$a × ($b + $c) = ?',
          answer: a * (b + c),
          options: [],
          emoji: emoji,
        );
      }
    } else if (problemType == 1) {
      emoji = "🔢";
      int a = random.nextInt(maxNum) + 1;
      int b = random.nextInt(maxNum) + 1;

      return Problem(
        question: '$a - $b + ${b - a} = ?',
        answer: a - b + (b - a),
        options: generateOptions(a - b + (b - a), maxNum),
        emoji: emoji,
      );
    } else {
      emoji = "📐";
      int a = random.nextInt(12) + 1;
      int operation = random.nextInt(2);

      if (operation == 0) {
        return Problem(
          question: '$a² = ?',
          answer: a * a,
          options: generateOptions(a * a, a * a * 2),
          emoji: emoji,
        );
      } else {
        a = random.nextInt(6) + 1;
        return Problem(
          question: '$a³ = ?',
          answer: a * a * a,
          options: [],
          emoji: emoji,
        );
      }
    }
  }

  Problem generateExpertProblem(int level) {
    Random random = Random();
    String emoji = "";
    int problemType = random.nextInt(3);

    if (problemType == 0) {
      emoji = "💯";
      int whole = (random.nextInt(20) + 5) * 10;
      int percentage = (random.nextInt(9) + 1) * 10;

      return Problem(
        question: 'What is $percentage% of $whole?',
        answer: (whole * percentage ~/ 100),
        options: [],
        emoji: emoji,
      );
    } else if (problemType == 1) {
      emoji = "🧮";
      int a = random.nextInt(20) + 1;
      int b = random.nextInt(20) + 1;
      int c = random.nextInt(20) + 1;

      return Problem(
        question: 'Solve: $a + $b × $c = ?',
        answer: a + (b * c),
        options: [],
        emoji: emoji,
      );
    } else {
      emoji = "📊";
      int a = random.nextInt(100) + 1;
      int b = random.nextInt(100) + 1;

      return Problem(
        question: 'What is the average of $a and $b?',
        answer: (a + b) ~/ 2,
        options: [],
        emoji: emoji,
      );
    }
  }

  List<int> generateOptions(int correctAnswer, int maxNum) {
    Random random = Random();
    Set<int> options = {correctAnswer};
    
    while (options.length < 4) {
      int option = correctAnswer + random.nextInt(10) - 5;
      if (option >= 0 && option <= maxNum) {
        options.add(option);
      }
    }
    
    return options.toList()..shuffle();
  }

  int getTimeForLevel(int level) {
    int difficulty = (level - 1) ~/ 3;
    switch (difficulty) {
      case 0: return 15;
      case 1: return 12;
      case 2: return 10;
      case 3: return 8;
      default: return 10;
    }
  }
}

class Problem {
  final String question;
  final int answer;
  final List<int> options;
  final String emoji;

  Problem({
    required this.question,
    required this.answer,
    required this.options,
    required this.emoji,
  });
}