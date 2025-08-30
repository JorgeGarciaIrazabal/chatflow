import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:chatflow/src/core/models/message_model.dart';
import 'package:chatflow/src/features/chat/bloc/chat_event.dart';
import 'package:chatflow/src/features/chat/bloc/chat_state.dart';
import 'package:chatflow/src/features/chat/repository/chat_repository.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository chatRepository;

  ChatBloc({required this.chatRepository}) : super(const ChatInitial()) {
    on<ChatSendMessageEvent>(_onSendMessage);
    on<ChatLoadConversationsEvent>(_onLoadConversations);
    on<ChatSelectConversationEvent>(_onSelectConversation);
    on<ChatReceiveMessageEvent>(_onReceiveMessage);
  }

  FutureOr<void> _onSendMessage(
    ChatSendMessageEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading(
      messages: state.messages,
      conversations: state.conversations,
      selectedConversationId: state.selectedConversationId,
      isLoading: true,
    ));

    try {
      // Add user message to the state immediately for better UX
      final userMessage = MessageResponse(
        content: event.message,
        role: MessageRole.user,
        responseType: ResponseType.text,
        id: DateTime.now().millisecondsSinceEpoch,
        conversationId: state.selectedConversationId ?? 0,
        userId: null,
        createdAt: DateTime.now(),
      );

      emit(ChatLoaded(
        messages: [...state.messages, userMessage],
        conversations: state.conversations,
        selectedConversationId: state.selectedConversationId,
      ));

      // Send message to API and get response
      final response = await chatRepository.sendMessage(
        message: event.message,
        conversationId: state.selectedConversationId,
      );

      // Add AI response to messages
      emit(ChatLoaded(
        messages: [...state.messages, response],
        conversations: state.conversations,
        selectedConversationId: state.selectedConversationId,
      ));
    } catch (e) {
      emit(ChatError(
        message: e.toString(),
        messages: state.messages,
        conversations: state.conversations,
        selectedConversationId: state.selectedConversationId,
      ));
    }
  }

  FutureOr<void> _onLoadConversations(
    ChatLoadConversationsEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading(
      messages: state.messages,
      conversations: state.conversations,
      selectedConversationId: state.selectedConversationId,
      isLoading: true,
    ));

    try {
      final conversations = await chatRepository.getConversations();
      emit(ChatLoaded(
        messages: state.messages,
        conversations: conversations,
        selectedConversationId: state.selectedConversationId,
      ));
    } catch (e) {
      emit(ChatError(
        message: e.toString(),
        messages: state.messages,
        conversations: state.conversations,
        selectedConversationId: state.selectedConversationId,
      ));
    }
  }

  FutureOr<void> _onSelectConversation(
    ChatSelectConversationEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading(
      messages: state.messages,
      conversations: state.conversations,
      selectedConversationId: state.selectedConversationId,
      isLoading: true,
    ));

    try {
      final conversation = await chatRepository.getConversation(event.conversationId);
      emit(ChatLoaded(
        messages: conversation.messages,
        conversations: state.conversations,
        selectedConversationId: event.conversationId,
      ));
    } catch (e) {
      emit(ChatError(
        message: e.toString(),
        messages: state.messages,
        conversations: state.conversations,
        selectedConversationId: state.selectedConversationId,
      ));
    }
  }

  FutureOr<void> _onReceiveMessage(
    ChatReceiveMessageEvent event,
    Emitter<ChatState> emit,
  ) {
    emit(ChatLoaded(
      messages: [...state.messages, event.message],
      conversations: state.conversations,
      selectedConversationId: state.selectedConversationId,
    ));
  }
}
