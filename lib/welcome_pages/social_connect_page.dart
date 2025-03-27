import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class SocialConnectPage extends StatefulWidget {
  const SocialConnectPage({Key? key}) : super(key: key);

  @override
  _SocialConnectPageState createState() => _SocialConnectPageState();
}

class _SocialConnectPageState extends State<SocialConnectPage> {
  final TextEditingController _searchController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _searchQuery = '';
  List<DocumentSnapshot> _filteredUsers = [];

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .where('email', isNotEqualTo: _auth.currentUser?.email)
          .get();

      setState(() {
        _filteredUsers = querySnapshot.docs;
      });
    } catch (e) {
      _showErrorSnackBar('Error fetching users: $e');
    }
  }

  void _filterUsers(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      _filteredUsers = _filteredUsers.where((user) {
        final userData = user.data() as Map<String, dynamic>;
        final name = (userData['displayName'] as String? ?? '').toLowerCase();
        final email = (userData['email'] as String? ?? '').toLowerCase();
        return name.contains(_searchQuery) || email.contains(_searchQuery);
      }).toList();
    });
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _navigateToChatDetail(DocumentSnapshot userDoc) {
    final userData = userDoc.data() as Map<String, dynamic>;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatDetailPage(
          receiverUid: userDoc.id,
          receiverName: userData['displayName'] ?? userData['email'].split('@')[0],
          receiverPhotoUrl: userData['photoUrl'],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Social Connect'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search users...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: _filterUsers,
            ),
          ),
        ),
      ),
      body: _buildUserList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement new connection/invite feature
          _showSuccessSnackBar('Find new connections');
        },
        child: const Icon(Icons.group_add),
      ),
    );
  }

  Widget _buildUserList() {
    if (_filteredUsers.isEmpty) {
      return const Center(
        child: Text(
          'No users found',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: _filteredUsers.length,
      itemBuilder: (context, index) {
        final userDoc = _filteredUsers[index];
        final userData = userDoc.data() as Map<String, dynamic>;

        return UserConnectionCard(
          userName: userData['displayName'] ?? userData['email'].split('@')[0],
          userEmail: userData['email'],
          photoUrl: userData['photoUrl'],
          onTap: () => _navigateToChatDetail(userDoc),
        );
      },
    );
  }
}

class UserConnectionCard extends StatelessWidget {
  final String userName;
  final String userEmail;
  final String? photoUrl;
  final VoidCallback onTap;

  const UserConnectionCard({
    Key? key,
    required this.userName,
    required this.userEmail,
    this.photoUrl,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: photoUrl != null ? NetworkImage(photoUrl!) : null,
          child: photoUrl == null ? Text(userName[0].toUpperCase()) : null,
        ),
        title: Text(
          userName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(userEmail),
        trailing: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: const Text('Message'),
        ),
      ),
    );
  }
}

class ChatDetailPage extends StatefulWidget {
  final String receiverUid;
  final String receiverName;
  final String? receiverPhotoUrl;

  const ChatDetailPage({
    Key? key,
    required this.receiverUid,
    required this.receiverName,
    this.receiverPhotoUrl,
  }) : super(key: key);

  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ScrollController _scrollController = ScrollController();

  void _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    try {
      final chatDocRef = _firestore
          .collection('chats')
          .doc(_generateChatId(currentUser.uid, widget.receiverUid));

      await chatDocRef.collection('messages').add({
        'text': message,
        'senderId': currentUser.uid,
        'senderEmail': currentUser.email,
        'receiverId': widget.receiverUid,
        'timestamp': FieldValue.serverTimestamp(),
        'isRead': false,
      });

      await chatDocRef.set({
        'lastMessage': message,
        'lastMessageTimestamp': FieldValue.serverTimestamp(),
        'participants': [currentUser.uid, widget.receiverUid],
        'unreadCount': FieldValue.increment(1),
      }, SetOptions(merge: true));

      _messageController.clear();
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } catch (e) {
      _showErrorSnackBar('Failed to send message: $e');
    }
  }

  void _markMessagesAsRead() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    final chatId = _generateChatId(currentUser.uid, widget.receiverUid);
    final chatDocRef = _firestore.collection('chats').doc(chatId);

    try {
      final unreadMessagesQuery = await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .where('receiverId', isEqualTo: currentUser.uid)
          .where('isRead', isEqualTo: false)
          .get();

      final batch = _firestore.batch();
      for (var doc in unreadMessagesQuery.docs) {
        batch.update(doc.reference, {'isRead': true});
      }
      await batch.commit();

      await chatDocRef.update({'unreadCount': 0});
    } catch (e) {
      _showErrorSnackBar('Error marking messages as read: $e');
    }
  }

  void _clearChat() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    final chatId = _generateChatId(currentUser.uid, widget.receiverUid);
    
    try {
      final messagesSnapshot = await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .get();

      final batch = _firestore.batch();
      for (var doc in messagesSnapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();

      await _firestore.collection('chats').doc(chatId).update({
        'lastMessage': '',
        'lastMessageTimestamp': null,
        'unreadCount': 0,
      });

      _showSuccessSnackBar('Chat cleared successfully');
    } catch (e) {
      _showErrorSnackBar('Failed to clear chat: $e');
    }
  }

  void _blockUser() {
    // TODO: Implement user blocking logic
    _showSuccessSnackBar('User blocked');
  }

  void _reportUser() {
    // TODO: Implement user reporting logic
    _showSuccessSnackBar('User reported');
  }

  String _generateChatId(String userId1, String userId2) {
    return userId1.compareTo(userId2) < 0
        ? '${userId1}_$userId2'
        : '${userId2}_$userId1';
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showChatOptionsBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.delete_forever),
                title: const Text('Clear Chat'),
                onTap: () {
                  Navigator.pop(context);
                  _clearChat();
                },
              ),
              ListTile(
                leading: const Icon(Icons.block),
                title: const Text('Block User'),
                onTap: () {
                  Navigator.pop(context);
                  _blockUser();
                },
              ),
              ListTile(
                leading: const Icon(Icons.report),
                title: const Text('Report User'),
                onTap: () {
                  Navigator.pop(context);
                  _reportUser();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _markMessagesAsRead();
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatId = _generateChatId(
      _auth.currentUser!.uid,
      widget.receiverUid,
    );

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: widget.receiverPhotoUrl != null
                  ? NetworkImage(widget.receiverPhotoUrl!)
                  : null,
              child: widget.receiverPhotoUrl == null
                  ? Text(widget.receiverName[0].toUpperCase())
                  : null,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.receiverName),
                const Text(
                  'Online',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: _clearChat,
            tooltip: 'Clear Chat',
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              _showChatOptionsBottomSheet();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('chats')
                  .doc(chatId)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  controller: _scrollController,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final messageData = messages[index].data() as Map<String, dynamic>;
                    final isMe = messageData['senderId'] == _auth.currentUser!.uid;

                    return _MessageBubble(
                      message: messageData['text'],
                      isMe: isMe,
                      timestamp: messageData['timestamp'],
                      isRead: messageData['isRead'] ?? false,
                    );
                  },
                );
              },
            ),
          ),
          _ChatInputArea(
            messageController: _messageController,
            onSendMessage: _sendMessage,
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final Timestamp? timestamp;
  final bool isRead;

  const _MessageBubble({
    required this.message,
    required this.isMe,
    this.timestamp,
    this.isRead = false,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMe 
            ? (isRead ? Colors.blue[100] : Colors.blue[200]) 
            : Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              message,
              style: TextStyle(
                color: isMe ? Colors.blue[900] : Colors.black87,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _formatTimestamp(timestamp),
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 10,
                  ),
                ),
                if (!isMe && !isRead)
                  const Padding(
                    padding: EdgeInsets.only(left: 4),
                    child: Icon(
                      Icons.circle,
                      color: Colors.red,
                      size: 8,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return '';
    final dateTime = timestamp.toDate();
    return DateFormat('hh:mm a').format(dateTime);
  }
}

class _ChatInputArea extends StatelessWidget {
  final TextEditingController messageController;
  final VoidCallback onSendMessage;

  const _ChatInputArea({
    required this.messageController,
    required this.onSendMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
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
                const SnackBar(content: Text('File attachment coming soon')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.emoji_emotions),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Emoji picker coming soon')),
              );
            },
          ),
          Expanded(
            child: TextField(
              controller: messageController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
              ),
              maxLines: null,
              keyboardType: TextInputType.multiline,
            ),
          ),
          const SizedBox(width: 8),
          FloatingActionButton.small(
            onPressed: onSendMessage,
            child: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}