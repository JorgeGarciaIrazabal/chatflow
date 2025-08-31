import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chatflow/src/features/chat/controllers/chat_controller.dart';
import 'package:chatflow/src/core/models/conversation_model.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
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
            child: Consumer<ChatController>(
              builder: (context, chatController, child) {
                return ListView.builder(
                  itemCount: chatController.conversations.length,
                  itemBuilder: (context, index) {
                    final conversation = chatController.conversations[index];
                    return ConversationTile(
                      conversation: conversation,
                      onTap: () {
                        chatController.selectConversation(conversation.id);
                        Navigator.pop(context); // Close the drawer
                      },
                    );
                  },
                );
              },
            ),
          ),
          const UserSettingsSection(),
        ],
      ),
    );
  }
}

class ConversationTile extends StatelessWidget {
  final ConversationResponse conversation;
  final VoidCallback onTap;

  const ConversationTile({
    super.key,
    required this.conversation,
    required this.onTap,
  });

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
      onTap: onTap,
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
