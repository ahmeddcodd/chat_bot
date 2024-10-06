import 'dart:io';
import 'dart:typed_data';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class ChatService extends StateNotifier<List<ChatMessage>> {
  ChatService() : super([]);
  final Gemini _gemini = Gemini.instance;
  final ChatUser currentUser = ChatUser(id: "0", firstName: "User");
  final ChatUser geminiBot = ChatUser(id: "1", firstName: "vox");

  void sendMessage(ChatMessage message) {
    state = [message, ...state];
    List<Uint8List>? images;
    if (message.medias?.isNotEmpty ?? false) {
      images = [
        File(message.medias!.first.url).readAsBytesSync(),
      ];
    }
    final String question = message.text;
    ChatMessage? lastMessage = state.firstOrNull;
    _gemini.streamGenerateContent(question, images: images).listen((event) {
      if (lastMessage != null && lastMessage!.user == geminiBot) {
        lastMessage = state.removeAt(0);
        String? response = event.content?.parts?.fold(
            "",
            (previousValue, currentValue) =>
                "$previousValue ${currentValue.text}");
        lastMessage!.text += response!;
        state = [lastMessage!, ...state];
      } else {
        String? response = event.content?.parts?.fold(
            "",
            (previousValue, currentValue) =>
                "$previousValue ${currentValue.text}");
        final ChatMessage message = ChatMessage(
            text: response!, user: geminiBot, createdAt: DateTime.now());
        state = [message, ...state];
      }
    });
  }

  Future<void> sendMediaMessage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      final ChatMessage message = ChatMessage(
          user: currentUser,
          text: "Describe this picture",
          createdAt: DateTime.now(),
          medias: [
            ChatMedia(url: file.path, fileName: "", type: MediaType.image)
          ]);
      sendMessage(message);
    }
  }
}
