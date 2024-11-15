import 'package:flutter/material.dart';
import 'package:app_one/src/constants/theme.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:app_one/src/screens/chat_screen.dart';
import 'package:app_one/src/screens/dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Função para fazer a requisição de login
  Future<void> login(BuildContext context) async {
    final email = emailController.text;
    final senha = passwordController.text;

    try {
      // Envia a requisição para a API de login
      final response = await http.post(
        Uri.parse('http://192.168.18.4:5183/api/Auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'senha': senha,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final role = data['role'][0];

        if (role == 'Client') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(role: role, email: email), // Ensure both parameters are passed
            ),
          );
        } else if (role == 'Admin') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => DashboardScreen(role: role)),
          );
        } else {
          // Role desconhecida
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Erro"),
              content: const Text("Tipo de usuário desconhecido."),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("OK"),
                ),
              ],
            ),
          );
        }
      } else {
        // Exibe mensagem de erro se o login falhar
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Erro de Login"),
            content: const Text("Email ou senha incorretos. Tente novamente."),
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
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            // Ação ao clicar em "Esqueci minha senha"
                          },
                          child: const Text(
                            "Esqueci minha senha",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () => login(context),
                        child: const Text(
                          "Entrar",
                          style: TextStyle(fontSize: 16, color: AppTheme.backgroundColor),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/cadastrocliente');
                        },
                        child: const Text(
                          "Cadastrar - se",
                          style: TextStyle(color: Colors.blue),
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
