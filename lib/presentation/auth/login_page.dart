import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_viewmodel.dart';
import '../catalog/catalog_page.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool isRegister = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final auth = ref.read(authViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(isRegister ? 'Register' : 'Login'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Email
            TextField(
              controller: emailCtrl,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            // Password
            TextField(
              controller: passCtrl,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),

            // Login/Register button
            ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () async {
                setState(() => isLoading = true);
                final error = isRegister
                    ? await auth.register(
                    emailCtrl.text.trim(), passCtrl.text.trim())
                    : await auth.signIn(
                    emailCtrl.text.trim(), passCtrl.text.trim());
                setState(() => isLoading = false);

                if (error == null) {


                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(isRegister
                          ? "Account created successfully!"
                          : "Login successful!"),
                    ),
                  );
                } else {
                  // ❌ Erreur
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(error)),
                  );
                }
              },
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(isRegister ? 'Create account' : 'Sign in'),
            ),
            const SizedBox(height: 12),

            // Switch login/register
            TextButton(
              onPressed: () => setState(() => isRegister = !isRegister),
              child: Text(isRegister
                  ? 'I already have an account'
                  : 'No account? Register here'),
            ),
            const SizedBox(height: 20),

            // Divider
            Row(
              children: const [
                Expanded(child: Divider(thickness: 1)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text("OR"),
                ),
                Expanded(child: Divider(thickness: 1)),
              ],
            ),
            const SizedBox(height: 20),

            // Google Sign-In button
            ElevatedButton.icon(
              onPressed: () async {
                setState(() => isLoading = true);
                final error = await auth.signInWithGoogle();
                setState(() => isLoading = false);

                if (error == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Signed in with Google ✅")),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(error)),
                  );
                }
              },
              icon: Image.asset(
                'assets/google_logo.webp',
                height: 24,
              ),
              label: const Text("Continue with Google"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
