import 'package:flutter/material.dart';
import 'src/constants/theme.dart';
import 'src/screens/Cadastro_Screen.dart';
import 'src/screens/cadastro_perguntas_page.dart';
import 'src/screens/chat_screen.dart';
import 'src/screens/pergunta_screen.dart';
import 'src/screens/dashboard_screen.dart';
import 'src/screens/login_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplicativo de Perguntas e Respostas',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
      routes: {
        // Removed '/chat' and '/dashboard' from routes
        // '/perguntas': (context) => PerguntaScreen(),
        // '/cadastroperguntas': (context) => CadastroPerguntaPage(),
        '/cadastrocliente': (context) => CadastroScreen(),
      },
    );
  }
}
