import 'dart:convert';
import 'package:aggar/features/messages/data/cubits/chat_state.dart';
import 'package:aggar/features/messages/model/chat_list_model.dart';
import 'package:aggar/features/messages/model/message_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:uuid/uuid.dart';

class ChatCubit extends Cubit<ChatState> {
  final String baseUrl = "https://aggarapi.runasp.net";
  String accessToken =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMDY5IiwianRpIjoiMjI1YzU1MjctYWYxYy00NjFkLWIxY2ItNTQ4MjczZjUyNzVlIiwidXNlcm5hbWUiOiJEZWFkTWFuIiwidWlkIjoiMTA2OSIsInJvbGVzIjpbIlVzZXIiLCJSZW50ZXIiXSwiZXhwIjoxNzQ1NTY2Nzc0LCJpc3MiOiJBZ2dhckFwaSIsImF1ZCI6IkZsdXR0ZXIifQ.U3aPGqA2J9OdU7UNUVgM9HIOuI8X571ueh2neRJqNYU";

  HubConnection? hubConnection;
  final uuid = const Uuid();

  bool isConnected = false;
  List<ChatListModel> chatList = [];
  List<MessageModel> messages = [];
  int currentUserId = 1063;
  ChatListModel? activeChat;

  ChatCubit() : super(ChatInitial());

  Future<void> initialize() async {
    emit(ChatLoading());

    try {
      await _initializeSignalR();

      _loadDummyChatList();

      emit(ChatConnected(chatList));
    } catch (e) {
      emit(ChatConnectionFailed(e.toString()));
    }
  }

  // Initialize SignalR connection
  Future<void> _initializeSignalR() async {
    try {
      // Create a new hub connection
      hubConnection = HubConnectionBuilder()
          .withUrl('$baseUrl/Chat?access_token=$accessToken')
          .build();

      // Handle received messages
      hubConnection!.on('ReceiveMessage', _handleReceiveMessage);

      // Handle user connection/disconnection events if available
      hubConnection!.on('UserConnected', _handleUserConnected);
      hubConnection!.on('UserDisconnected', _handleUserDisconnected);

      // Start the connection
      await hubConnection!.start();

      isConnected = true;
      print('SignalR connection established');
    } catch (e) {
      isConnected = false;
      print('Error establishing SignalR connection: $e');
      throw Exception('Failed to connect to chat server');
    }
  }

  // Close the SignalR connection
  Future<void> closeConnection() async {
    await hubConnection?.stop();
    isConnected = false;
  }

  // Handle received messages from SignalR
  void _handleReceiveMessage(List<Object?>? parameters) {
    if (parameters == null || parameters.isEmpty) return;

    try {
      // Parse the received message
      final Map<String, dynamic> messageData =
          jsonDecode(parameters[0].toString());

      final message = MessageModel(
        clientMessageId: messageData['clientMessageId'] ?? uuid.v4(),
        senderId: messageData['senderId'] ?? 0,
        receiverId: messageData['receiverId'] ?? 0,
        content: messageData['content'] ?? '',
        timestamp: DateTime.now(),
        isMe: messageData['senderId'] == currentUserId,
      );

      // Update the messages list if this is for the active chat
      if (activeChat != null &&
          (activeChat!.userId == message.senderId ||
              activeChat!.userId == message.receiverId)) {
        messages.add(message);

        if (state is ChatConversationActive) {
          emit((state as ChatConversationActive)
              .copyWith(messages: List.from(messages)));
        }
      }

      // Update the last message in chat list
      final chatIndex = chatList.indexWhere(
        (c) =>
            c.userId == (message.isMe ? message.receiverId : message.senderId),
      );

      if (chatIndex != -1) {
        chatList[chatIndex].lastMessage = message.content;
        chatList[chatIndex].lastMessageTime = message.timestamp;

        // If we're in the connected state, update the chat list
        if (state is ChatConnected) {
          emit(ChatConnected(List.from(chatList)));
        }
      }
    } catch (e) {
      print('Error handling received message: $e');
    }
  }

  void _handleUserConnected(List<Object?>? parameters) {
    if (parameters == null || parameters.isEmpty) return;
    print('User connected: ${parameters[0]}');
    // Update UI if needed
  }

  void _handleUserDisconnected(List<Object?>? parameters) {
    if (parameters == null || parameters.isEmpty) return;
    print('User disconnected: ${parameters[0]}');
    // Update UI if needed
  }

  // Load dummy chat list (replace with API call later)
  void _loadDummyChatList() {
    chatList = [
      ChatListModel(
        userId: 1060,
        name: "John Doe",
        imageUrl: "https://randomuser.me/api/portraits/men/1.jpg",
        lastMessage: "Hello there!",
        lastMessageTime: DateTime.now().subtract(const Duration(minutes: 15)),
      ),
      ChatListModel(
        userId: 1061,
        name: "Jane Smith",
        imageUrl: "https://randomuser.me/api/portraits/women/1.jpg",
        lastMessage: "Are you there?",
        lastMessageTime: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      // Add more chat items as needed
    ];
  }

  // Open a chat conversation
  Future<void> openChat(ChatListModel chat) async {
    emit(ChatLoading());

    activeChat = chat;

    // Load messages (using dummy data for now)
    await _loadMessages(chat.userId);

    emit(ChatConversationActive(
      messages: messages,
      activeChat: chat,
      isConnected: isConnected,
    ));
  }

  // Load messages for a specific chat
  Future<void> _loadMessages(int receiverId) async {
    // In a real app, fetch messages from your backend
    // Using dummy data for now
    messages = [
      MessageModel(
        clientMessageId: uuid.v4(),
        senderId: currentUserId,
        receiverId: receiverId,
        content: "Hi there!",
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        isMe: true,
      ),
      MessageModel(
        clientMessageId: uuid.v4(),
        senderId: receiverId,
        receiverId: currentUserId,
        content: "Hello! How are you?",
        timestamp: DateTime.now().subtract(const Duration(minutes: 25)),
        isMe: false,
      ),
      // Add more messages as needed
    ];
  }

  // Send a message
  Future<void> sendMessage(String content) async {
    if (content.trim().isEmpty || !isConnected || activeChat == null) return;

    final String clientMessageId = uuid.v4();
    final int receiverId = activeChat!.userId;

    try {
      // Send message through SignalR
      await hubConnection!.invoke(
        'SendMessageAsync',
        args: <Object>[
          {
            'clientMessageId': clientMessageId,
            'receiverId': receiverId,
            'content': content,
          },
        ],
      );

      // Add message to local state for immediate display
      final newMessage = MessageModel(
        clientMessageId: clientMessageId,
        senderId: currentUserId,
        receiverId: receiverId,
        content: content,
        timestamp: DateTime.now(),
        isMe: true,
      );

      messages.add(newMessage);

      // Update the last message in chat list
      final chatIndex = chatList.indexWhere((c) => c.userId == receiverId);
      if (chatIndex != -1) {
        chatList[chatIndex].lastMessage = content;
        chatList[chatIndex].lastMessageTime = DateTime.now();
      }

      // Emit updated state
      if (state is ChatConversationActive) {
        emit((state as ChatConversationActive)
            .copyWith(messages: List.from(messages)));
      }
    } catch (e) {
      print('Error sending message: $e');
      // You could emit an error state here if needed
    }
  }

  // Refresh connection
  Future<void> refreshConnection() async {
    emit(ChatLoading());

    if (!isConnected) {
      try {
        await _initializeSignalR();
      } catch (e) {
        emit(ChatConnectionFailed(e.toString()));
        return;
      }
    }

    _loadDummyChatList();
    emit(ChatConnected(chatList));
  }

  // Format time for messages
  String formatMessageTime(DateTime time) {
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }
}
