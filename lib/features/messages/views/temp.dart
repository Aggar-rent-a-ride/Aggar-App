import 'package:aggar/features/messages/data/cubits/chat_cubit.dart';
import 'package:aggar/features/messages/data/cubits/chat_state.dart';
import 'package:aggar/features/messages/model/chat_list_model.dart';
import 'package:aggar/features/messages/model/message_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Main Chat App Component
class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BlocProvider(
        create: (_) => ChatCubit()..initialize(),
        child: const ChatsTabScreen(),
      ),
    );
  }
}

// Chat Tab Screen - Main entry point
class ChatsTabScreen extends StatefulWidget {
  const ChatsTabScreen({super.key});

  @override
  State<ChatsTabScreen> createState() => _ChatsTabScreenState();
}

class _ChatsTabScreenState extends State<ChatsTabScreen> {
  @override
  void dispose() {
    // Close the connection when disposing of the widget
    context.read<ChatCubit>().closeConnection();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        actions: [
          BlocBuilder<ChatCubit, ChatState>(
            builder: (context, state) {
              final bool isConnected = state is ChatConnected ||
                  (state is ChatConversationActive && state.isConnected);

              return Row(
                children: [
                  // Connection status indicator
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: Icon(
                      isConnected ? Icons.cloud_done : Icons.cloud_off,
                      color: isConnected ? Colors.green : Colors.red,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () {
                      context.read<ChatCubit>().refreshConnection();
                    },
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<ChatCubit, ChatState>(
        builder: (context, state) {
          if (state is ChatLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ChatConnectionFailed) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Connection failed: ${state.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<ChatCubit>().refreshConnection(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (state is ChatConnected) {
            return _buildChatList(context, state.chatList);
          }

          // Default fallback
          return const Center(child: Text('Something went wrong'));
        },
      ),
    );
  }

  Widget _buildChatList(BuildContext context, List<ChatListModel> chatList) {
    return ListView.separated(
      itemBuilder: (ctx, i) {
        final chat = chatList[i];
        return ListTile(
          title: Text(chat.name),
          subtitle: Text(chat.lastMessage ?? ''),
          trailing: chat.lastMessageTime != null
              ? Text(_formatTime(chat.lastMessageTime!))
              : null,
          leading: CircleAvatar(
            backgroundColor: Colors.grey,
            backgroundImage: NetworkImage(chat.imageUrl),
          ),
          onTap: () => _openChatScreen(context, chat),
        );
      },
      separatorBuilder: (ctx, i) => const Divider(),
      itemCount: chatList.length,
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }

  void _openChatScreen(BuildContext context, ChatListModel chat) {
    // Open the chat in the cubit
    context.read<ChatCubit>().openChat(chat);

    // Show the chat screen
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const ChatScreen(),
    );
  }
}

// Chat Screen for Individual Conversations
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController messageTextController = TextEditingController();
  final ScrollController chatScrollController = ScrollController();

  @override
  void dispose() {
    messageTextController.dispose();
    chatScrollController.dispose();
    super.dispose();
  }

  // Helper to scroll to bottom of chat
  void _scrollToBottom() {
    if (chatScrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        chatScrollController.animateTo(
          chatScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatCubit, ChatState>(
      listener: (context, state) {
        if (state is ChatConversationActive) {
          _scrollToBottom();
        }
      },
      builder: (context, state) {
        if (state is! ChatConversationActive) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.9,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        final activeChat = state.activeChat;
        final messages = state.messages;
        final isConnected = state.isConnected;

        return Container(
          height: MediaQuery.of(context).size.height * 0.9,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: NetworkImage(activeChat.imageUrl),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            activeChat.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            isConnected ? "Online" : "Offline",
                            style: const TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                IconButton(icon: const Icon(Icons.videocam), onPressed: () {}),
                IconButton(icon: const Icon(Icons.call), onPressed: () {}),
                IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
              ],
            ),
            body: Column(
              children: [
                // Connection status message if not connected
                if (!isConnected)
                  Container(
                    color: Colors.red.shade100,
                    padding: const EdgeInsets.all(8),
                    child: const Row(
                      children: [
                        Icon(Icons.error_outline, color: Colors.red),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Not connected to the server. Messages will not be sent.',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Chat messages area
                Expanded(
                  child: ListView.builder(
                    controller: chatScrollController,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      return _buildMessageItem(context, message);
                    },
                  ),
                ),

                // Message input area
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  height: 70,
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.attach_file),
                        onPressed: () {},
                      ),
                      Expanded(
                        child: TextField(
                          controller: messageTextController,
                          decoration: InputDecoration(
                            hintText: "Type a message",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                              vertical: 10.0,
                            ),
                            filled: true,
                            fillColor: Colors.grey[200],
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: isConnected
                            ? () {
                                if (messageTextController.text
                                    .trim()
                                    .isNotEmpty) {
                                  context.read<ChatCubit>().sendMessage(
                                        messageTextController.text,
                                      );
                                  messageTextController.clear();
                                }
                              }
                            : null,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMessageItem(BuildContext context, MessageModel message) {
    final isMyMessage = message.isMe;
    final cubit = context.read<ChatCubit>();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment:
            isMyMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMyMessage)
            CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage(
                (cubit.state as ChatConversationActive).activeChat.imageUrl,
              ),
            ),
          const SizedBox(width: 8),
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isMyMessage ? Colors.blue[100] : Colors.grey[200],
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(message.content, style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 4),
                Text(
                  cubit.formatMessageTime(message.timestamp),
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (isMyMessage)
            const CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage(
                "https://randomuser.me/api/portraits/men/1.jpg", // This would be the current user's image
              ),
            ),
        ],
      ),
    );
  }
}
