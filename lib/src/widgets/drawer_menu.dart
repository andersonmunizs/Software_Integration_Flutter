import 'package:app_one/src/constants/theme.dart';
import 'package:flutter/material.dart';
import 'package:app_one/src/screens/chat_screen.dart'; // Add this import
import 'package:app_one/src/screens/dashboard_screen.dart'; // Add this import
import 'package:app_one/src/screens/pergunta_screen.dart'; // Add this import
import 'package:app_one/src/screens/cadastro_perguntas_page.dart'; // Corrected import

class DrawerMenu extends StatelessWidget {
  final String role;

  DrawerMenu({required this.role});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          if (role == 'Admin') ...[
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Dashboard'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => DashboardScreen(role: role)),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.question_answer),
              title: Text('Perguntas'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => PerguntaScreen(role: role)),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.chat),
              title: Text('Cadastrar Perguntas'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => CadastroPerguntaPage(role: role)),
                );
              },
            ),
          ],
          if (role == 'Client') ...[
            ListTile(
              leading: Icon(Icons.chat),
              title: Text('Chat'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ChatScreen(role: role)),
                );
              },
            ),
          ],
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
    );
  }
}
