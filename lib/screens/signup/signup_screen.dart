import 'package:flutter/material.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.transparent,
                backgroundImage:
                    AssetImage('assets/images/logo.png'), //logo aqui
              ),
              const SizedBox(height: 16),
              const Text(
                'Criar Conta',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Insira seu email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  hintText: 'Insira sua senha',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Repita a Senha',
                  hintText: 'Repita a Senha',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  //conta aqui
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 100, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text('CRIAR CONTA'),
              ),
              const SizedBox(height: 32),
              const Text.rich(
                TextSpan(
                  text: 'Veja ',
                  children: [
                    TextSpan(
                      text: 'Termos de uso',
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                      //funcionalidade de navegação para termos de uso
                    ),
                    TextSpan(text: ' e '),
                    TextSpan(
                      text: 'Política de Privacidade',
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                      //política de privacidade
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
