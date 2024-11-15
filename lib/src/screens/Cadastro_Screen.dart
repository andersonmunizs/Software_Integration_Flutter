import 'package:flutter/material.dart';
import 'package:app_one/src/constants/theme.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  _CadastroScreenState createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Função para fazer a requisição de registro
  Future<void> register(BuildContext context) async {
    final nome = nomeController.text;
    final email = emailController.text;
    final senha = passwordController.text;
    const role = "Client";

    try {
      // Envia a requisição para a API de registro
      final response = await http.post(
        Uri.parse('http://192.168.18.4:5183/api/Auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nome': nome,
          'email': email,
          'senha': senha,
          'role': role,
        }),
      );

      if (response.statusCode == 200) {
        // Registro bem-sucedido
        Navigator.pushReplacementNamed(context, '/dashboard');
      } else {
        // Exibe mensagem de erro se o registro falhar
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Erro de Registro"),
            content: const Text("Falha no registro. Tente novamente."),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Erro de Conexão"),
          content: const Text("Não foi possível conectar à API. Verifique sua conexão."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    nomeController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppTheme.primaryColor,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Container com logo local
              SizedBox(
                height: 100,
                width: 300,
                child: Image.asset('lib/src/assets/Rota-Oeste-Logo-600x257.png'),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Container(
                  width: 350,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppTheme.textAppMEnu,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        controller: nomeController,
                        decoration: const InputDecoration(
                          labelText: "Nome",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          labelText: "Email",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: passwordController,
                        decoration: const InputDecoration(
                          labelText: "Senha",
                          border: OutlineInputBorder(),
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () => register(context),
                        child: const Text(
                          "Cadastrar",
                          style: TextStyle(fontSize: 16, color: AppTheme.backgroundColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
