import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/message_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/user.dart';

class MessageScreen extends StatefulWidget {
  static const routeName = '/messages';

  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final _messageController = TextEditingController();
  String? _selectedUserId;

  @override
  void initState() {
    super.initState();
    context.read<MessageProvider>().fetchMessages();
    context.read<AuthProvider>().fetchUsers(); // Fetch users initially
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.isEmpty || _selectedUserId == null) return;

    await context
        .read<MessageProvider>()
        .sendMessage(_selectedUserId!, _messageController.text);
    _messageController.clear();
  }

  Future<void> _refreshUsers() async {
    await context.read<AuthProvider>().fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    final messages = context.watch<MessageProvider>().messages;
    final users = context.watch<AuthProvider>().users;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshUsers,
          ),
        ],
      ),
      body: Column(
        children: [
          DropdownButton<String>(
            hint: const Text('Select User'),
            value: _selectedUserId,
            onChanged: (String? newValue) {
              setState(() {
                _selectedUserId = newValue;
              });
            },
            items: users.map<DropdownMenuItem<String>>((User user) {
              return DropdownMenuItem<String>(
                value: user.id,
                child: Text(user.name),
              );
            }).toList(),
          ),
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return ListTile(
                  title: Text(message.content),
                  subtitle: Text(
                      'From: ${message.senderId} To: ${message.receiverId}'),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      labelText: 'Type a message',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}
