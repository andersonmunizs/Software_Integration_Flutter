import 'package:app_one/src/constants/theme.dart';
import 'package:app_one/src/widgets/drawer_menu.dart'; // Importe o DrawerMenu
import 'package:flutter/material.dart';

class CadastroPerguntaPage extends StatefulWidget {
  const CadastroPerguntaPage({Key? key}) : super(key: key);

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

  void addCliente(Map<String, dynamic> cliente) {
    setState(() {
      clientesAdicionados.add(cliente);
    });
  }

  void removeCliente(int id) {
    setState(() {
      clientesAdicionados.removeWhere((cliente) => cliente['id'] == id);
    });
  }

  void searchClientes(String query) {
    // Simulação de busca de clientes
    final allClientes = [
      {"id": 1, "nome": "Cliente 1"},
      {"id": 2, "nome": "Cliente 2"},
      {"id": 3, "nome": "Cliente 3"},
      {"id": 4, "nome": "Cliente 4"},
    ];

    setState(() {
      clientes = allClientes
          .where((cliente) =>
              (cliente['nome'] as String?)?.toLowerCase().contains(query.toLowerCase()) ?? false)
          .toList();
    });
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
      drawer: DrawerMenu(), // Usando o DrawerMenu aqui
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
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.visibility, color: Colors.blue),
                            onPressed: () {
                              // Lógica para visualizar detalhes do cliente
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.orange),
                            onPressed: () {
                              // Lógica para editar o cliente
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => removeCliente(cliente['id']),
                          ),
                        ],
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
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Ação do botão confirmar
                          // Aqui você pode processar os dados
                          print("Pergunta: ${_perguntaController.text}");
                          print("Descrição: ${_descricaoController.text}");
                          print("Clientes Adicionados: $clientesAdicionados");
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
