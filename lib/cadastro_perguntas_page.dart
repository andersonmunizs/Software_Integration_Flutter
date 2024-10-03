import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: CadastroPerguntaPage(),
    );
  }
}

class CadastroPerguntaPage extends StatefulWidget {
  const CadastroPerguntaPage({super.key});

  @override
  _CadastroPerguntaPageState createState() => _CadastroPerguntaPageState();
}

class _CadastroPerguntaPageState extends State<CadastroPerguntaPage> {
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
                      "CADASTRO DE PERGUNTA",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

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
                          // Filtros de status e data de criação
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

                              // Data de criação
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

                          // Campo Pergunta
                          const TextField(
                            decoration: InputDecoration(
                              labelText: "Pergunta:",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Campo Descrição
                          const TextField(
                            maxLines: 5,
                            decoration: InputDecoration(
                              labelText: "Descrição:",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],
                      ),
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
                            // Ação do botão fechar
                          },
                          child: const Text("FECHAR"),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          onPressed: () {
                            // Ação do botão confirmar
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
        ],
      ),
    );
  }
}
