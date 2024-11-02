import 'package:flutter/material.dart';
import '../widgets/drawer_menu.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Map<String, String>> chatMessages = [
    {"textoPergunta": "Qual é a sua dúvida?", "resposta": ""},
    {"textoPergunta": "Gostaria de ajuda em algo?", "resposta": ""},
  ];
  final TextEditingController messageController = TextEditingController();

  void sendMessage() {
    setState(() {
      chatMessages.add({
        "textoPergunta": messageController.text,
        "resposta": 'null',
      });
      messageController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Conversa",
          style: TextStyle(color: Colors.white), // Cor branca para o título
        ),
      ),
      drawer: DrawerMenu(), // Coloquei o drawer no Scaffold
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: chatMessages.length,
              itemBuilder: (context, index) {
                final message = chatMessages[index];
                return ListTile(
                  title: Text(message["textoPergunta"]!),
                  subtitle: Text(message["resposta"] ?? ''),
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
                    controller: messageController,
                    decoration: InputDecoration(hintText: "Digite sua resposta"),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
