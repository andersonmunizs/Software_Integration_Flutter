import 'package:flutter/material.dart';
import '../widgets/drawer_menu.dart';

class PerguntaScreen extends StatefulWidget {
  @override
  _PerguntaScreenState createState() => _PerguntaScreenState();
}

class _PerguntaScreenState extends State<PerguntaScreen> {
  final TextEditingController perguntaController = TextEditingController();
  List<Map<String, dynamic>> perguntas = [
    {
      "pergunta": "Qual é a sua cor favorita?",
      "cliente": "João Silva",
      "dataCriacao": DateTime(2024, 10, 1),
      "status": "Ativo"
    },
    {
      "pergunta": "Onde você mora?",
      "cliente": "Maria Souza",
      "dataCriacao": DateTime(2024, 9, 25),
      "status": "Inativo"
    },
    {
      "pergunta": "Qual é o seu hobby?",
      "cliente": "Carlos Pereira",
      "dataCriacao": DateTime(2024, 10, 15),
      "status": "Ativo"
    },
  ];
  
  List<Map<String, dynamic>> filteredPerguntas = [];
  String status = "Todos";
  DateTime? dataCriacao;

  @override
  void initState() {
    super.initState();
    filteredPerguntas = List.from(perguntas);
  }

  void filterPerguntas() {
    setState(() {
      String query = perguntaController.text.toLowerCase();
      filteredPerguntas = perguntas.where((pergunta) {
        final matchesQuery = pergunta["pergunta"].toLowerCase().contains(query);
        final matchesStatus = status == "Todos" || pergunta["status"] == status;
        final matchesDate = dataCriacao == null || pergunta["dataCriacao"] == dataCriacao;
        return matchesQuery && matchesStatus && matchesDate;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Consultar Perguntas")),
      drawer: DrawerMenu(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Campo de busca
            TextField(
              controller: perguntaController,
              decoration: InputDecoration(
                labelText: "Buscar Pergunta",
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: filterPerguntas,
                ),
              ),
              onChanged: (value) => filterPerguntas(),
            ),
            const SizedBox(height: 10),

            // Filtro de status
            DropdownButtonFormField<String>(
              value: status,
              items: const [
                DropdownMenuItem(value: "Todos", child: Text("Todos")),
                DropdownMenuItem(value: "Ativo", child: Text("Ativo")),
                DropdownMenuItem(value: "Inativo", child: Text("Inativo")),
              ],
              onChanged: (value) {
                setState(() {
                  status = value!;
                  filterPerguntas();
                });
              },
              decoration: const InputDecoration(
                labelText: "Status",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),

            // Filtro de data de criação
            GestureDetector(
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
                    filterPerguntas();
                  });
                }
              },
              child: AbsorbPointer(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: dataCriacao == null
                        ? "Data de Criação"
                        : "${dataCriacao!.day}/${dataCriacao!.month}/${dataCriacao!.year}",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Tabela de dados com DataTable estilizada
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 20,
                  dataRowHeight: 60,
                  headingRowColor: MaterialStateProperty.all(Colors.blueAccent),
                  headingTextStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  columns: const [
                    DataColumn(label: Text("Pergunta")),
                    DataColumn(label: Text("Cliente Vinculado")),
                    DataColumn(label: Text("Data de Criação")),
                    DataColumn(label: Text("Status")),
                  ],
                  rows: filteredPerguntas.map((pergunta) {
                    return DataRow(
                      cells: [
                        DataCell(Text(
                          pergunta["pergunta"],
                          style: TextStyle(fontSize: 16),
                        )),
                        DataCell(Text(
                          pergunta["cliente"],
                          style: TextStyle(fontSize: 16),
                        )),
                        DataCell(Text(
                          "${pergunta["dataCriacao"].day}/${pergunta["dataCriacao"].month}/${pergunta["dataCriacao"].year}",
                          style: TextStyle(fontSize: 16),
                        )),
                        DataCell(
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: pergunta["status"] == "Ativo"
                                  ? Colors.green[200]
                                  : Colors.red[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              pergunta["status"],
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
