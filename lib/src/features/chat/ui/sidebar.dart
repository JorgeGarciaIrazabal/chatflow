import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chatflow/src/features/chat/bloc/chat_bloc.dart';
import 'package:chatflow/src/features/chat/bloc/chat_event.dart';
import 'package:chatflow/src/features/chat/bloc/chat_state.dart';
import 'package:chatflow/src/core/models/conversation_model.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        return Drawer(
          child: Column(
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                ),
                child: Center(
                  child: Text(
                    'Chatflow',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: state.conversations.length,
                  itemBuilder: (context, index) {
                    final conversation = state.conversations[index];
                    return ConversationTile(conversation: conversation);
                  },
                ),
              ),
              const UserSettingsSection(),
            ],
          ),
        );
      },
    );
  }
}

class ConversationTile extends StatelessWidget {
  final ConversationResponse conversation;

  const ConversationTile({super.key, required this.conversation});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.chat_bubble_outline),
      title: Text(
        conversation.title ?? 'New Conversation',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        '${conversation.messages.length} messages',
        style: const TextStyle(fontSize: 12),
      ),
      onTap: () {
        context.read<ChatBloc>().add(
              ChatSelectConversationEvent(
                conversationId: conversation.id,
              ),
            );
        Navigator.pop(context); // Close the drawer
      },
    );
  }
}

class UserSettingsSection extends StatelessWidget {
  const UserSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Divider(),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text('Settings'),
        ),
        ListTile(
          leading: Icon(Icons.help_outline),
          title: Text('Help & Support'),
        ),
      ],
    );
  }
}
