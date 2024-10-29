
import 'package:app_one/src/constants/theme.dart';
import 'package:flutter/material.dart';

class DrawerMenu extends StatelessWidget {
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
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Dashboard'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/dashboard');
            },
          ),
          ListTile(
            leading: Icon(Icons.question_answer),
            title: Text('Perguntas'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/perguntas');
            },
          ),
          ListTile(
            leading: Icon(Icons.chat),
            title: Text('Conversa'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/chat');
            },
          ),
          ListTile(
            leading: Icon(Icons.chat),
            title: Text('Cadastro perguntas'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/cadastroperguntas');
            },
          ),
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
