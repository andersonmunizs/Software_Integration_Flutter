import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Add this import
import 'dart:convert'; // Add this import
import '../widgets/drawer_menu.dart';
import 'package:app_one/src/constants/theme.dart';
import 'package:app_one/src/screens/cadastro_perguntas_page.dart'; // Adjust the path as necessary

class PerguntaScreen extends StatefulWidget {
  final String role;
  PerguntaScreen({required this.role});

  @override
  _PerguntaScreenState createState() => _PerguntaScreenState();
}

class _PerguntaScreenState extends State<PerguntaScreen> {
  final TextEditingController perguntaController = TextEditingController();
  List<Map<String, dynamic>> perguntas = [];
  List<Map<String, dynamic>> filteredPerguntas = [];
  String status = "Todos";
  DateTime? dataCriacao;

  @override
  void initState() {
    super.initState();
    fetchPerguntas(); // Replace initializing with API call
  }

  Future<void> fetchPerguntas() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.18.4:5183/api/Pergunta'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          perguntas = data.map((item) {
            return {
              "idPergunta": item["idPergunta"],
              "pergunta": item["textoPergunta"],
              "cliente": item["clienteNomes"].isNotEmpty ? item["clienteNomes"].join(', ') : 'Nenhum',
              "dataCriacao": DateTime.parse(item["data"]),
              "status": item["clienteEmails"].isNotEmpty ? "Ativo" : "Inativo",
            };
          }).toList();
          filterPerguntas();
        });
      } else {
        print('Erro ao buscar perguntas: ${response.statusCode}');
      }
    } catch (e) {
      print('Exceção ao buscar perguntas: $e');
    }
  }

  void filterPerguntas() {
    setState(() {
      String query = perguntaController.text.toLowerCase();
      filteredPerguntas = perguntas.where((pergunta) {
        final matchesQuery = pergunta["pergunta"].toLowerCase().contains(query);
        final matchesStatus = status == "Todos" || pergunta["status"] == status;
        final matchesDate = dataCriacao == null || 
                            (pergunta["dataCriacao"].year == dataCriacao!.year && 
                             pergunta["dataCriacao"].month == dataCriacao!.month &&
                             pergunta["dataCriacao"].day == dataCriacao!.day);
        return matchesQuery && matchesStatus && matchesDate;
      }).toList();
    });
  }

  void navigateToCadastroPerguntas(Map<String, dynamic> pergunta) {
    // Navega para a rota /cadastroperguntas com os dados da pergunta
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CadastroPerguntaPage(role: widget.role),
        settings: RouteSettings(arguments: pergunta),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consultar Perguntas", style: TextStyle(color: AppTheme.textAppMEnu)),
      ),
      drawer: DrawerMenu(role: widget.role),
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
                setState(() {
                  dataCriacao = pickedDate;
                  filterPerguntas();
                });
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
              child: Container(
                // width: double.infinity, // Garante que o container ocupe toda a largura
                // height: double.infinity, // Garante que o container ocupe toda a altura
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: 20,
                    headingRowColor: MaterialStateProperty.all(AppTheme.primaryColor),
                    headingTextStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    columns: const [
                      DataColumn(label: Text("Pergunta")),
                      DataColumn(label: Text("Cliente Vinculado")),
                      DataColumn(label: Text("Data de Criação")),
                      DataColumn(label: Text("Status")),
                      DataColumn(label: Text("Ações")),
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
                          DataCell(
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.search),
                                  color: AppTheme.primaryColor,
                                  onPressed: () {
                                    navigateToCadastroPerguntas(pergunta);
                                  },
                                  tooltip: "Visualizar",
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  color: AppTheme.vermelo,
                                  onPressed: () {
                                    // Adicione sua lógica de exclusão aqui
                                  },
                                  tooltip: "Deletar",
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
