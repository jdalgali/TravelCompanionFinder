import 'package:flutter/foundation.dart';
import '../services/message_service.dart';
import '../models/message.dart';

class MessageProvider with ChangeNotifier {
  final MessageService _messageService;
  List<Message> _messages = [];
  bool _isLoading = false;
  String? _error;

  MessageProvider({required String? token})
      : _messageService = MessageService(token: token);

  List<Message> get messages => [..._messages];
  bool get isLoading => _isLoading;
  String? get error => _error;

  void updateToken(String? token) {
    _messageService.updateToken(token);
  }

  Future<void> fetchMessages() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _messages = await _messageService.getMessages();
      _error = null;
    } catch (error) {
      _error = error.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> sendMessage(String receiverId, String content) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newMessage = await _messageService.sendMessage(receiverId, content);
      _messages.insert(0, newMessage);
      _error = null;
    } catch (error) {
      _error = error.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
