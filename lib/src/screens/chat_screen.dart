import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Adicione este import
import '../widgets/drawer_menu.dart';

class ChatScreen extends StatefulWidget {
  final String role;
  final String email; // Adicione esta linha

  ChatScreen({required this.role, required this.email}); // Modifique o construtor

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Map<String, dynamic>> chatMessages = []; // Atualize o tipo para dynamic
  bool isLoading = true; // Indicador de carregamento
  final TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchPerguntas(); // Chame a função de busca
  }

  Future<void> fetchPerguntas() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.18.4:5183/api/Cliente/perguntas'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': widget.email}), // Envie o email no corpo
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          chatMessages = data.map((item) {
            return {
              "textoPergunta": item["textoPergunta"],
              "resposta": item["descricao"],
              "data": item["data"],
            };
          }).toList();
          isLoading = false;
        });
      } else {
        print('Erro ao buscar perguntas: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Exceção ao buscar perguntas: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void sendMessage() {
    setState(() {
      chatMessages.add({
        "textoPergunta": messageController.text,
        "resposta": 'Aguardando resposta...',
        "data": DateTime.now().toIso8601String(),
      });
      messageController.clear();
    });
    // Aqui você pode adicionar a lógica para enviar a mensagem para a API, se necessário
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
      drawer: DrawerMenu(role: widget.role), // Coloquei o drawer no Scaffold
      body: Column(
        children: [
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: chatMessages.length,
                    itemBuilder: (context, index) {
                      final message = chatMessages[index];
                      final isUser = message["resposta"].isEmpty || message["resposta"] == 'Aguardando resposta...';
                      return Align(
                        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          decoration: BoxDecoration(
                            color: isUser ? AppTheme.accentColor : AppTheme.primaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment:
                                isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                            children: [
                              Text(
                                message["textoPergunta"],
                                style: TextStyle(
                                  color: isUser ? Colors.black : Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 5),
                              if (!isUser)
                                Text(
                                  message["resposta"],
                                  style: TextStyle(
                                    color: isUser ? Colors.black : Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                            ],
                          ),
                        ),
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
