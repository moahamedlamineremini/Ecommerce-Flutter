import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Provider accessible partout dans l'app.
/// Contient l'état de l'utilisateur Firebase courant (User?).
final authViewModelProvider =
StateNotifierProvider<AuthViewModel, User?>((ref) => AuthViewModel());

/// ViewModel pour gérer l'authentification (email/mdp + Google).
class AuthViewModel extends StateNotifier<User?> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  AuthViewModel() : super(FirebaseAuth.instance.currentUser) {
    // Écoute en temps réel les changements d'authentification
    _auth.authStateChanges().listen((user) => state = user);
  }

  /// Connexion avec email et mot de passe
  Future<String?> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null; //  succès
    } on FirebaseAuthException catch (e) {
      return _mapErrorToMessage(e);
    } catch (_) {
      return "An unexpected error occurred. Please try again.";
    }
  }

  /// Inscription avec email et mot de passe
  Future<String?> register(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return _mapErrorToMessage(e);
    } catch (_) {
      return "An unexpected error occurred. Please try again.";
    }
  }

  /// Déconnexion (Firebase + Google si nécessaire)
  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  Future<String?> signInWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        return "Google sign-in aborted";
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      return null; // ✅ pas d’erreur
    } catch (e) {
      return e.toString();
    }
  }


  String _mapErrorToMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return "Invalid email format.";
      case 'user-disabled':
        return "This account has been disabled.";
      case 'user-not-found':
        return "No account found for this email.";
      case 'wrong-password':
        return "Incorrect password. Please try again.";
      case 'email-already-in-use':
        return "This email is already registered.";
      case 'weak-password':
        return "Password is too weak. Use at least 6 characters.";
      default:
        return "Authentication failed. Please try again.";
    }
  }
}
