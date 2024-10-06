import 'package:chat_bot/Chat/chat_service.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final StateNotifierProvider<ChatService, List<ChatMessage>>
    chatServiceProvider =
    StateNotifierProvider<ChatService, List<ChatMessage>>((_) => ChatService());
