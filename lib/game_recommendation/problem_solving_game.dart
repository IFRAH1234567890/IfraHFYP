import 'package:flutter/material.dart';
import 'p1game.dart';
import 'p2game.dart';
import 'p3game.dart';

class ProblemSolvingGame extends StatelessWidget {
  const ProblemSolvingGame({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Problem Solving Game',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              'https://images.unsplash.com/photo-1557683316-973673baf926?q=80&w=2029&auto=format&fit=crop',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Choose Your Challenge',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        offset: Offset(1, 1),
                        blurRadius: 3,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                _buildGameCard(
                  context,
                  'Word Puzzles ',
                  'https://th.bing.com/th?id=OIF.aym1o7IMOuokF%2f%2bScpJwWA&w=202&h=202&c=7&r=0&o=5&dpr=1.5&pid=1.7',
                  '',
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const P1Game()),
                  ),
                ),
                const SizedBox(height: 20),
                _buildGameCard(
                  context,
                  'Mathematical Challenges',
                  'https://th.bing.com/th/id/OIP.vPW8lSJhdJcm6qW3B4pg5gHaGJ?w=227&h=188&c=7&r=0&o=5&dpr=1.5&pid=1.7',
                  '',
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const P2Game()),
                  ),
                ),
                const SizedBox(height: 20),
                _buildGameCard(
                  context,
                  'Pattern Recognition',
                  'https://th.bing.com/th/id/OIP.cnVXnES8FhFbZhJtqVj8OAHaHa?w=213&h=213&c=7&r=0&o=5&dpr=1.5&pid=1.7',
                  '',
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const P3Game()),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGameCard(
    BuildContext context,
    String title,
    String imageUrl,
    String description,
    VoidCallback onPressed,
  ) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 120,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blue.shade800, Colors.purple.shade800],
            ),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
                child: Image.network(
                  imageUrl,
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(right: 16),
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}