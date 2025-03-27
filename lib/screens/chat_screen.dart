import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void main() => runApp(const ChatApp());

class ChatApp extends StatelessWidget {
  const ChatApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6200EA),
          brightness: Brightness.light,
          primary: const Color(0xFF6200EA),
          secondary: const Color(0xFFFF6D00),
          tertiary: const Color(0xFF00C853),
        ),
        fontFamily: 'Poppins',
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6200EA),
          brightness: Brightness.dark,
          primary: const Color(0xFF7C4DFF),
          secondary: const Color(0xFFFF9E40),
          tertiary: const Color(0xFF69F0AE),
        ),
        fontFamily: 'Poppins',
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      home: const ChatHomeScreen(),
    );
  }
}

class ChatHomeScreen extends StatefulWidget {
  const ChatHomeScreen({Key? key}) : super(key: key);

  @override
  State<ChatHomeScreen> createState() => _ChatHomeScreenState();
}

class _ChatHomeScreenState extends State<ChatHomeScreen>
    with SingleTickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isSearching = false;
  String _searchQuery = '';
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showActionSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Wrap(
        children: [
          ListTile(
            leading: Icon(Icons.settings,
                color: Theme.of(context).colorScheme.primary),
            title: Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Settings opened')),
              );
            },
          ),
          ListTile(
            leading:
                Icon(Icons.logout, color: Theme.of(context).colorScheme.error),
            title: Text('Logout',
                style: TextStyle(color: Theme.of(context).colorScheme.error)),
            onTap: () {
              _auth.signOut();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Logged out successfully')),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: _isSearching
            ? TextField(
                autofocus: true,
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                decoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .onPrimary
                          .withOpacity(0.7)),
                  border: InputBorder.none,
                ),
                onChanged: (value) =>
                    setState(() => _searchQuery = value.toLowerCase()),
              )
            : Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onPrimary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.chat_bubble,
                      color: Theme.of(context).colorScheme.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 8),
                 Text('ConnectChat'),
                ],
              ),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () => setState(() {
              _isSearching = !_isSearching;
              if (!_isSearching) _searchQuery = '';
            }),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: _showActionSheet,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Theme.of(context).colorScheme.onPrimary,
          labelColor: Theme.of(context).colorScheme.onPrimary,
          tabs: const [
            Tab(text: 'Chats'),
            Tab(text: 'Status'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildUsersList(),
       Center(child: Text('Status updates coming soon!')),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        foregroundColor: Theme.of(context).colorScheme.onSecondary,
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('New chat feature coming soon!')),
          );
        },
        child: const Icon(Icons.chat),
      ),
    );
  }

  Widget _buildUsersList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.secondary,
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.people,
                  size: 80,
                  color:
                      Theme.of(context).colorScheme.tertiary.withOpacity(0.7),
                ),
                const SizedBox(height: 16),
            Text(
                  'No users available',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        }

        final users = snapshot.data!.docs;
        final filteredUsers = users.where((doc) {
          final userData = doc.data() as Map<String, dynamic>;
          // Safely handle potential null values
          final userEmail = userData['email'] as String?;

          if (userEmail == null) return false;

          return userEmail != _auth.currentUser?.email &&
              (_searchQuery.isEmpty ||
                  userEmail.toLowerCase().contains(_searchQuery));
        }).toList();

        if (filteredUsers.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off,
                  size: 80,
                  color:
                      Theme.of(context).colorScheme.tertiary.withOpacity(0.7),
                ),
                const SizedBox(height: 16),
                Text(
                  _searchQuery.isEmpty
                      ? 'No users available'
                      : 'No matching users',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: filteredUsers.length,
          itemBuilder: (context, index) {
            final userData =
                filteredUsers[index].data() as Map<String, dynamic>;
            final userEmail = userData['email'] as String? ?? 'Unknown';
            final displayName =
                userData['displayName'] as String? ?? userEmail.split('@')[0];
            final photoUrl = userData['photoUrl'] as String?;
            final lastSeen = userData['lastSeen'] as Timestamp?;

            // Determine online status
            String status = 'Offline';
            Color statusColor = Theme.of(context).colorScheme.error;

            if (lastSeen != null) {
              final lastSeenTime = lastSeen.toDate();
              final difference = DateTime.now().difference(lastSeenTime);

              if (difference.inMinutes < 5) {
                status = 'Online';
                statusColor = Theme.of(context).colorScheme.tertiary;
              } else if (difference.inHours < 1) {
                status = 'Away';
                statusColor = Theme.of(context).colorScheme.secondary;
              }
            }

            return Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  backgroundImage:
                      photoUrl != null ? NetworkImage(photoUrl) : null,
                  child: photoUrl == null
                      ? Text(displayName[0].toUpperCase(),
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary))
                      : null,
                ),
                title: Text(displayName,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(status),
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(Icons.message,
                      color: Theme.of(context).colorScheme.primary),
                  onPressed: () {},
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChatDetailScreen(
                      receiverEmail: userEmail,
                      receiverName: displayName,
                      receiverPhotoUrl: photoUrl,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class ChatDetailScreen extends StatefulWidget {
  final String receiverEmail;
  final String receiverName;
  final String? receiverPhotoUrl;

  const ChatDetailScreen({
    Key? key,
    required this.receiverEmail,
    required this.receiverName,
    this.receiverPhotoUrl,
  }) : super(key: key);

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ScrollController _scrollController = ScrollController();

  String _generateChatId(String email1, String email2) {
    return email1.compareTo(email2) < 0
        ? '${email1}_${email2}'
        : '${email2}_${email1}';
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return;

      final chatId = _generateChatId(currentUser.email!, widget.receiverEmail);

      _firestore
          .collection('chatRooms')
          .doc(chatId)
          .collection('messages')
          .add({
        'text': _messageController.text.trim(),
        'sender': currentUser.email,
        'senderName':
            currentUser.displayName ?? currentUser.email!.split('@')[0],
        'receiver': widget.receiverEmail,
        'receiverName': widget.receiverName,
        'timestamp': FieldValue.serverTimestamp(),
        'isRead': false,
      });

      // Update last message in chat room document
      _firestore.collection('chatRooms').doc(chatId).set({
        'lastMessage': _messageController.text.trim(),
        'lastMessageTime': FieldValue.serverTimestamp(),
        'participants': [currentUser.email, widget.receiverEmail],
      }, SetOptions(merge: true));

      _messageController.clear();
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _showProfileOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            padding: const EdgeInsets.all(16),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                backgroundImage: widget.receiverPhotoUrl != null
                    ? NetworkImage(widget.receiverPhotoUrl!)
                    : null,
                radius: 30,
                child: widget.receiverPhotoUrl == null
                    ? Text(widget.receiverName[0].toUpperCase(),
                        style:
                            const TextStyle(fontSize: 24, color: Colors.white))
                    : null,
              ),
              title: Text(widget.receiverName,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              subtitle: Text(widget.receiverEmail),
            ),
          ),
          ListTile(
            leading: Icon(Icons.person_add,
                color: Theme.of(context).colorScheme.primary),
            title: Text('View Profile'),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile view coming soon')),
              );
            },
          ),
          ListTile(
            leading:
                Icon(Icons.block, color: Theme.of(context).colorScheme.error),
            title:  Text('Block User'),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${widget.receiverName} blocked')),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.delete_outline,
                color: Theme.of(context).colorScheme.error),
            title: Text('Clear Chat'),
            onTap: () {
              final chatId = _generateChatId(
                  _auth.currentUser!.email!, widget.receiverEmail);
              _firestore
                  .collection('chatRooms')
                  .doc(chatId)
                  .collection('messages')
                  .get()
                  .then((snapshot) {
                for (var doc in snapshot.docs) {
                  doc.reference.delete();
                }
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Chat cleared')),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final chatId =
        _generateChatId(_auth.currentUser!.email!, widget.receiverEmail);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        leadingWidth: 30,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.onPrimary,
              backgroundImage: widget.receiverPhotoUrl != null
                  ? NetworkImage(widget.receiverPhotoUrl!)
                  : null,
              child: widget.receiverPhotoUrl == null
                  ? Text(widget.receiverName[0].toUpperCase(),
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary))
                  : null,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.receiverName,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.tertiary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Online',
                    style: TextStyle(
                      fontSize: 10,
                      color: Theme.of(context).colorScheme.onTertiary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.video_call),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(content: Text('Video call initiated')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.call),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                 SnackBar(content: Text('Voice call initiated')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: _showProfileOptions,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background.withOpacity(0.9),
          image: DecorationImage(
            image: const AssetImage('assets/chat_bg.png'),
            fit: BoxFit.cover,
            opacity: 0.1,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('chatRooms')
                    .doc(chatId)
                    .collection('messages')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.secondary,
                    ));
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.chat_bubble_outline,
                            size: 80,
                            color: Theme.of(context)
                                .colorScheme
                                .secondary
                                .withOpacity(0.5),
                          ),
                          const SizedBox(height: 16),
                           Text(
                            'Say hi to start the conversation!',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  }

                  final messages = snapshot.data!.docs;

                  return ListView.builder(
                    controller: _scrollController,
                    reverse: true,
                    padding: const EdgeInsets.all(12),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final messageData =
                          messages[index].data() as Map<String, dynamic>;
                      final messageText =
                          messageData['text'] as String? ?? 'Empty message';
                      final messageSender =
                          messageData['sender'] as String? ?? '';
                      final timestamp = messageData['timestamp'] as Timestamp?;

                      final isMe = messageSender == _auth.currentUser!.email;

                      // Format timestamp
                      String timeString = 'now';
                      if (timestamp != null) {
                        final messageTime = timestamp.toDate();
                        final now = DateTime.now();
                        final difference = now.difference(messageTime);

                        if (difference.inMinutes < 1) {
                          timeString = 'now';
                        } else if (difference.inHours < 1) {
                          timeString = '${difference.inMinutes}m ago';
                        } else if (difference.inDays < 1) {
                          timeString = '${difference.inHours}h ago';
                        } else {
                          timeString = '${difference.inDays}d ago';
                        }
                      }

                      return Align(
                        alignment:
                            isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: isMe
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.secondary,
                            borderRadius: BorderRadius.circular(20).copyWith(
                              bottomRight:
                                  isMe ? const Radius.circular(5) : null,
                              bottomLeft:
                                  !isMe ? const Radius.circular(5) : null,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.75,
                          ),
                          child: Column(
                            crossAxisAlignment: isMe
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              Text(
                                messageText,
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    timeString,
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary
                                          .withOpacity(0.7),
                                      fontSize: 11,
                                    ),
                                  ),
                                  if (isMe) ...[
                                    const SizedBox(width: 4),
                                    Icon(
                                      Icons.done_all,
                                      size: 14,
                                      color: messageData['isRead'] == true
                                          ? Theme.of(context)
                                              .colorScheme
                                              .tertiary
                                          : Theme.of(context)
                                              .colorScheme
                                              .onPrimary
                                              .withOpacity(0.7),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    offset: const Offset(0, -1),
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.attach_file),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                       SnackBar(
                            content: Text('Attachment feature coming soon')),
                      );
                    },
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  IconButton(
                    icon: const Icon(Icons.emoji_emotions_outlined),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                         SnackBar(
                            content: Text('Emoji picker coming soon')),
                      );
                    },
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TextField(
                        controller: _messageController,
                        decoration: const InputDecoration(
                          hintText: 'Type a message',
                          border: InputBorder.none,
                        ),
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: _sendMessage,
                      color: Theme.of(context).colorScheme.onSecondary,
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
