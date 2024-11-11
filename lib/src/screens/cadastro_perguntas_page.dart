import 'package:app_one/src/constants/theme.dart';
import 'package:app_one/src/widgets/drawer_menu.dart'; // Importe o DrawerMenu
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class CadastroPerguntaPage extends StatefulWidget {
  final String role;
  CadastroPerguntaPage({required this.role});

  @override
  _CadastroPerguntaPageState createState() => _CadastroPerguntaPageState();
}

class _CadastroPerguntaPageState extends State<CadastroPerguntaPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _perguntaController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> clientes = [];
  List<Map<String, dynamic>> clientesAdicionados = [];
  List<String> userClientEmails = [];

  void addCliente(Map<String, dynamic> cliente) {
    setState(() {
      clientesAdicionados.add(cliente);
      userClientEmails.add(cliente['email']);
    });
  }

  void removeCliente(String id) {
    setState(() {
      final clienteToRemove = clientesAdicionados.firstWhere(
        (cliente) => cliente['id'] == id,
        orElse: () => {},
      );
      if (clienteToRemove != null) {
        userClientEmails.remove(clienteToRemove['email']);
        clientesAdicionados.remove(clienteToRemove);
      }
    });
  }

  void searchClientes(String query) async {
    final response = await http.get(Uri.parse('http://192.168.18.4:5183/api/Cliente/all'));

    if (response.statusCode == 200) {
      final List<dynamic> allClientes = json.decode(response.body);
      setState(() {
        clientes = allClientes.where((cliente) {
          final nome = cliente['nome']?.toLowerCase() ?? '';
          return nome.contains(query.toLowerCase());
        }).cast<Map<String, dynamic>>().toList();
      });
    } else {
      print('Falhou ao pesquisar os clientes.');
    }
  }

  @override
  void dispose() {
    _perguntaController.dispose();
    _descricaoController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cadastro de Pergunta", style: TextStyle(color: AppTheme.textAppMEnu)),
        backgroundColor: AppTheme.primaryColor,
      ),
      drawer: DrawerMenu(role: widget.role),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Seção de formulário
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Campo Pergunta
                      TextFormField(
                        controller: _perguntaController,
                        decoration: const InputDecoration(
                          labelText: "Pergunta:",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Campo obrigatório';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),

                      // Campo Descrição
                      TextFormField(
                        controller: _descricaoController,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          labelText: "Descrição:",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Campo obrigatório';
                          }
                          return null;
                        },
                      ),
                       const SizedBox(height: 20),
                                         // Campo de Pesquisa
                      TextFormField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          labelText: "Buscar Cliente:",
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: () => searchClientes(_searchController.text),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Lista de Clientes Disponíveis
                      if (clientes.isNotEmpty) ...[
                        const Text("Clientes encontrados:", style: TextStyle(fontWeight: FontWeight.bold)),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: clientes.length,
                          itemBuilder: (context, index) {
                            final cliente = clientes[index];
                            return ListTile(
                              title: Text(cliente['nome']),
                              trailing: IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () => addCliente(cliente),
                              ),
                            );
                          },
                        ),
                      ],

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Lista de Clientes Adicionados
                const Text("Clientes Adicionados:", style: TextStyle(fontWeight: FontWeight.bold)),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: clientesAdicionados.length,
                  itemBuilder: (context, index) {
                    final cliente = clientesAdicionados[index];
                    return ListTile(
                      title: Text(cliente['nome']),
                      subtitle: Text("ID: ${cliente['id']}"),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => removeCliente(cliente['id']),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),

                // Botões de Ação
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red, // Cor de fundo
                      ),
                      onPressed: () {
                        Navigator.pop(context); // Fechar a tela
                      },
                      child: const Text("FECHAR"),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          // Format the date as 'YYYY-MM-DD'
                          String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

                          final perguntaData = {
                            "textoPergunta": _perguntaController.text,
                            "descricao": _descricaoController.text,
                            "data": formattedDate,
                            "userClientEmails": userClientEmails,
                          };

                          final response = await http.post(
                            Uri.parse('http://192.168.18.4:5183/api/Pergunta/adicionar'),
                            headers: {'Content-Type': 'application/json'},
                            body: jsonEncode(perguntaData),
                          );

                          if (response.statusCode == 201 || response.statusCode == 200) {
                            print('Pergunta cadastrada com sucesso');
                            // Navigate to CadastroPerguntaPage to reset the screen
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => CadastroPerguntaPage(role: widget.role)),
                            );
                          } else {
                            print('Erro ao cadastrar pergunta: ${response.body}');
                          }
                        }
                      },
                      child: const Text("CONFIRMAR"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
