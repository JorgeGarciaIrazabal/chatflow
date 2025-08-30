import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chatflow/src/features/auth/bloc/auth_bloc.dart';
import 'package:chatflow/src/features/auth/bloc/auth_event.dart';
import 'package:chatflow/src/features/chat/bloc/chat_bloc.dart';
import 'package:chatflow/src/features/chat/bloc/chat_event.dart';
import 'package:chatflow/src/features/chat/bloc/chat_state.dart';
import 'package:chatflow/src/features/chat/ui/sidebar.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chatflow'),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(AuthLogoutEvent());
            },
          ),
        ],
      ),
      drawer: const Sidebar(),
      body: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          if (state is ChatLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ChatError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      'Error occurred',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        // Try to reload the conversations
                        context.read<ChatBloc>().add(ChatLoadConversationsEvent());
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: state.messages.length,
                  itemBuilder: (context, index) {
                    final message = state.messages[index];
                    return ListTile(
                      title: Text(message.content),
                      subtitle: Text(message.role.toString()),
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
                        decoration: const InputDecoration(
                          hintText: 'Type your message...',
                          border: OutlineInputBorder(),
                        ),
                        onSubmitted: (text) {
                          if (text.isNotEmpty) {
                            context.read<ChatBloc>().add(
                                  ChatSendMessageEvent(message: text),
                                );
                          }
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () {
                        // TODO: Implement send message
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
