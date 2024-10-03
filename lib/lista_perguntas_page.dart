import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ListaPerguntasPage(),
    );
  }
}

class ListaPerguntasPage extends StatefulWidget {
  const ListaPerguntasPage({super.key});

  @override
  _ListaPerguntasPageState createState() => _ListaPerguntasPageState();
}

class _ListaPerguntasPageState extends State<ListaPerguntasPage> {
  String status = "Ativo";
  DateTime? dataCriacao;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Menu lateral
          Container(
            width: 200,
            color: Colors.blue[900],
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "HOME",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
                // Adicionar mais opções se necessário
              ],
            ),
          ),

          // Corpo da página
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título da página
                    const Text(
                      "LISTA DE PERGUNTAS",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Seção de filtros
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Campo de busca de perguntas
                          const TextField(
                            decoration: InputDecoration(
                              labelText: "Pergunta:",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Filtros adicionais
                          Row(
                            children: [
                              // Filtro de status
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  value: status,
                                  items: const [
                                    DropdownMenuItem(
                                      value: "Ativo",
                                      child: Text("Ativo"),
                                    ),
                                    DropdownMenuItem(
                                      value: "Inativo",
                                      child: Text("Inativo"),
                                    ),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      status = value!;
                                    });
                                  },
                                  decoration: const InputDecoration(
                                    labelText: "Status:",
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),

                              // Filtro de data de criação
                              Expanded(
                                child: GestureDetector(
                                  onTap: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime.now(),
                                    );
                                    if (pickedDate != null) {
                                      setState(() {
                                        dataCriacao = pickedDate;
                                      });
                                    }
                                  },
                                  child: AbsorbPointer(
                                    child: TextField(
                                      decoration: InputDecoration(
                                        labelText: dataCriacao == null
                                            ? "Data Criação"
                                            : "${dataCriacao!.day}/${dataCriacao!.month}/${dataCriacao!.year}",
                                        border: const OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          // Botão de filtrar
                          ElevatedButton(
                            onPressed: () {
                              // Ação de filtrar
                            },
                            child: const Text("FILTRAR"),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Tabela de perguntas
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('Coluna 1')),
                          DataColumn(label: Text('Coluna 2')),
                          DataColumn(label: Text('Coluna 3')),
                          DataColumn(label: Text('Coluna 4')),
                        ],
                        rows: List<DataRow>.generate(
                          5,
                              (index) => DataRow(cells: [
                            DataCell(Text('Dado ${index + 1}')),
                            DataCell(Text('Dado ${index + 1}')),
                            DataCell(Text('Dado ${index + 1}')),
                            DataCell(Text('Dado ${index + 1}')),
                          ]),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
