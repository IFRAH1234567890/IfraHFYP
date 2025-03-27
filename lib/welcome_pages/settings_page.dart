import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[900],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
     title: Text( // Removed 'const'
  'SETTINGS',
  style: TextStyle(
    color: Colors.white, // Colors.white is not a constant
    fontWeight: FontWeight.bold,
    fontSize: 22,
  ),
),

        centerTitle: true,
        elevation: 10,
        shadowColor: Colors.deepPurple[800],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple[800]!, Colors.indigo[900]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
           Text(
  'App Settings',
  style: TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.white, // Colors.white is not a constant
  ),
),

              const SizedBox(height: 20),
              _buildSettingItem(
                icon: Icons.notifications,
                title: 'Notifications',
                subtitle: 'Manage your notification preferences',
                color: Colors.amber[700]!,
              ),
              _buildSettingItem(
                icon: Icons.accessibility_new,
                title: 'Accessibility',
                subtitle: 'Configure accessibility features',
                color: Colors.teal[400]!,
              ),
              _buildSettingItem(
                icon: Icons.privacy_tip,
                title: 'Privacy',
                subtitle: 'Manage your privacy settings',
                color: Colors.pink[400]!,
              ),
              _buildSettingItem(
                icon: Icons.help_outline,
                title: 'Help & Support',
                subtitle: 'Get assistance and support',
                color: Colors.blue[400]!,
              ),
              _buildSettingItem(
                icon: Icons.info_outline,
                title: 'About',
                subtitle: 'Learn more about NeuroRevive',
                color: Colors.green[400]!,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.8),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.white,
          size: 16,
        ),
      ),
    );
  }
}
