import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_viewmodel.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});
  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool isRegister = false;

  @override
  Widget build(BuildContext context) {
    final auth = ref.read(authViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text(isRegister ? 'Register' : 'Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: 'Email')),
            TextField(controller: passCtrl, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () async {
                if (isRegister) {
                  await auth.register(emailCtrl.text.trim(), passCtrl.text.trim());
                } else {
                  await auth.signIn(emailCtrl.text.trim(), passCtrl.text.trim());
                }
              },
              child: Text(isRegister ? 'Create account' : 'Sign in'),
            ),
            TextButton(
              onPressed: () => setState(() => isRegister = !isRegister),
              child: Text(isRegister ? 'I have an account' : 'No account? Register'),
            ),
          ],
        ),
      ),
    );
  }
}
