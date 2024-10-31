import 'package:app_one/src/screens/Cadastro_Screen.dart';
import 'package:app_one/src/screens/cadastro_perguntas_page.dart';
import 'package:flutter/material.dart';
import 'src/constants/theme.dart';
import 'src/screens/chat_screen.dart';
import 'src/screens/pergunta_screen.dart';
import 'src/screens/dashboard_screen.dart';
import 'src/screens/login_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplicativo de Perguntas e Respostas',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
      routes: {
        '/chat': (context) => ChatScreen(),
        '/perguntas': (context) => PerguntaScreen(),
        '/dashboard': (context) => DashboardScreen(),
        '/cadastroperguntas': (context) => CadastroPerguntaPage(),
        '/cadastrocliente': (context) => CadastroScreen(),

      },
    );
  }
}
