import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Adicione este import
import 'dart:convert'; // Adicione este import
import '../widgets/drawer_menu.dart';
import 'package:app_one/src/constants/theme.dart'; // Add this line

class ChatScreen extends StatefulWidget {
  final String role;
  final String? email; // Make email an optional parameter

  const ChatScreen({super.key, required this.role, this.email}); // Made email optional

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Map<String, dynamic>> chatMessages = []; // Removed static data
  bool isLoading = true; // Indicador de carregamento
  final TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchPerguntas(); // Chame a função de busca
  }

  Future<void> fetchPerguntas() async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.18.4:5183/api/Pergunta/PorUsuario'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(widget.email), // Send email as JSON string
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        List<Map<String, dynamic>> perguntas = data.map((item) {
          return {
            "idPergunta": item["idPergunta"],
            "textoPergunta": item["textoPergunta"],
            "resposta": "",
            "data": item["data"],
          };
        }).toList();

        // Fetch responses for each question
        for (int i = 0; i < perguntas.length; i++) {
          final idPergunta = perguntas[i]["idPergunta"];
          final responseResposta = await http.post(
            Uri.parse('http://192.168.18.4:5183/api/Resposta/respostas-por-pergunta-usuario'),
            headers: {
              'Content-Type': 'application/json',
              'idPergunta': idPergunta.toString(),
              'emailUsuario': widget.email ?? '',
            },
          );

          if (responseResposta.statusCode == 200) {
            final respostaData = json.decode(responseResposta.body);
            if (respostaData.isNotEmpty) {
              perguntas[i]["resposta"] = respostaData[0]["textoResposta"] ?? "";
            }
          }
        }

        setState(() {
          chatMessages = perguntas;
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

  Future<void> enviarResposta(int idPergunta, String textoResposta, int index) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.18.4:5183/api/Resposta/adicionar'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "idPergunta": idPergunta,
          "emailUsuario": widget.email,
          "textoResposta": textoResposta,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          chatMessages[index]["resposta"] = textoResposta; // Update resposta
        });
      } else {
        // Optional: Handle error, e.g., show a Snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao enviar resposta.')),
        );
      }
    } catch (e) {
      // Optional: Handle exception, e.g., show a Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Exceção ao enviar resposta.')),
      );
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
        title: const Text(
          "Conversa",
          style: TextStyle(color: Colors.white), // Cor branca para o título
        ),
      ),
      drawer: DrawerMenu(role: widget.role), // Coloquei o drawer no Scaffold
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: chatMessages.asMap().entries.map((entry) {
                  final index = entry.key;
                  final message = entry.value;
                  final TextEditingController respostaController = TextEditingController();

                  return Column(
                    children: [
                      // Pergunta
                      Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft, // Align to left
                          child: Text(
                            message["textoPergunta"],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      // Resposta existente ou campo para adicionar resposta
                      if (message["resposta"].isNotEmpty) 
                        Container(
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          decoration: BoxDecoration(
                            color: AppTheme.accentColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              message["resposta"],
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        )
                      else
                        // Campo para adicionar resposta com botão enviar
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: respostaController,
                                  decoration: const InputDecoration(
                                    labelText: "Digite sua resposta",
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.send),
                                onPressed: () {
                                  String textoResposta = respostaController.text.trim();
                                  if (textoResposta.isNotEmpty) {
                                    int idPergunta = message["idPergunta"];
                                    enviarResposta(idPergunta, textoResposta, index);
                                    respostaController.clear();
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                    ],
                  );
                }).toList(),
              ),
            ),
    );
  }
}
