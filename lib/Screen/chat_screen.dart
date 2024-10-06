import "package:chat_bot/API/api_key.dart";
import "package:chat_bot/Chat/chat_service.dart";
import "package:chat_bot/Provider/chat_provider.dart";
import "package:dash_chat_2/dash_chat_2.dart";
import "package:flutter/material.dart";
import "package:flutter_gemini/flutter_gemini.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:google_fonts/google_fonts.dart";

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  @override
  void initState() {
    super.initState();
    Gemini.init(apiKey: apiKey);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Vox",
            style: GoogleFonts.lato(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
      ),
      body: buildUI(context),
    );
  }

  Widget buildUI(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final ChatService chatService = ref.read(chatServiceProvider.notifier);
      final List<ChatMessage> messageList = ref.watch(chatServiceProvider);
      return DashChat(
        messages: messageList,
        currentUser: chatService.currentUser,
        onSend: chatService.sendMessage,
        inputOptions: InputOptions(trailing: [
          IconButton(
              icon: const Icon(Icons.image),
              onPressed: () async {
                await chatService.sendMediaMessage();
              })
        ]),
      );
    });
  }
}
