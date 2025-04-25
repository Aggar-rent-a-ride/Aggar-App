// Define Chat States
import 'package:aggar/features/messages/model/chat_list_model.dart';
import 'package:aggar/features/messages/model/message_model.dart';
import 'package:equatable/equatable.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

// Initial state when the chat feature is first loaded
class ChatInitial extends ChatState {}

// Loading state while fetching data or connecting
class ChatLoading extends ChatState {}

// State for when connection is established
class ChatConnected extends ChatState {
  final List<ChatListModel> chatList;

  const ChatConnected(this.chatList);

  @override
  List<Object?> get props => [chatList];
}

// State for connection failure
class ChatConnectionFailed extends ChatState {
  final String error;

  const ChatConnectionFailed(this.error);

  @override
  List<Object?> get props => [error];
}

// State for the active chat conversation
class ChatConversationActive extends ChatState {
  final List<MessageModel> messages;
  final ChatListModel activeChat;
  final bool isConnected;

  const ChatConversationActive({
    required this.messages,
    required this.activeChat,
    required this.isConnected,
  });

  @override
  List<Object?> get props => [messages, activeChat, isConnected];

  ChatConversationActive copyWith({
    List<MessageModel>? messages,
    ChatListModel? activeChat,
    bool? isConnected,
  }) {
    return ChatConversationActive(
      messages: messages ?? this.messages,
      activeChat: activeChat ?? this.activeChat,
      isConnected: isConnected ?? this.isConnected,
    );
  }
}
