import 'package:flutter/material.dart';
import 'package:app_one/src/constants/theme.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Função para fazer a requisição de login
  Future<void> login(BuildContext context) async {
    final email = emailController.text;
    final password = passwordController.text;
    var codeNumber = 200; // so para passar da requisição


    try {
      // descomentar depois e subistituir
     // Envia a requisição para a API
      // final response = await http.post(
      //   Uri.parse('https://suaapi.com/login'), // Substitua pelo URL da sua API
      //   headers: {'Content-Type': 'application/json'},
      //   body: jsonEncode({
      //     'email': email,
      //     'password': password,
      //   }),
      // );
    
      
      // Verifica a resposta da API // descomentar depois e substituir
     // if (response.statusCode == 200) {
      if (codeNumber == 200) {
      
        //final data = jsonDecode(response.body);
        //final success = data['success']; // Suponha que a resposta tem um campo 'success'

       // if (success || codeNumber == 200) {  // descomentar depois e substituir
         if (codeNumber == 200) {
          // Login bem-sucedido
          Navigator.pushReplacementNamed(context, '/dashboard');
        } else {
          // Exibe mensagem de erro se o login falhar
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("Erro de Login"),
              content: Text("Email ou senha incorretos. Tente novamente."),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("OK"),
                ),
              ],
            ),
          );
        }
      } else {
        throw Exception("Erro de servidor");
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Erro de Conexão"),
          content: Text("Não foi possível conectar à API. Verifique sua conexão."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("OK"),
            ),
          ],
        ),
      );
    }
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
              Container(
                height: 100,
                width: 300,
                child: Image.asset('lib/src/assets/Rota-Oeste-Logo-600x257.png'),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Container(
                  width: 350,
                  padding: EdgeInsets.all(24),
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
                        decoration: InputDecoration(
                          labelText: "Email",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 16),
                      TextField(
                        controller: passwordController,
                        decoration: InputDecoration(
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
                          child: Text(
                            "Esqueci minha senha",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () => login(context),
                        child: Text(
                          "Entrar",
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
