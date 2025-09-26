import 'package:flutter_test/flutter_test.dart';
import 'package:ecommerce_app/presentation/auth/auth_viewmodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FakeUser implements User {
  @override
  String? get email => 'test@test.com';

  @override
  String get uid => 'fake-uid';

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeUserCredential implements UserCredential {
  @override
  User? get user => FakeUser();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeFirebaseAuth implements FirebaseAuth {
  bool signInCalled = false;
  bool registerCalled = false;
  bool signOutCalled = false;
  bool shouldFailSignIn = false;
  bool shouldFailRegister = false;
  User? _currentUser;

  @override
  Future<UserCredential> signInWithEmailAndPassword({required String email, required String password}) async {
    signInCalled = true;
    if (shouldFailSignIn) {
      throw FirebaseAuthException(code: 'wrong-password', message: 'Incorrect password');
    }
    _currentUser = FakeUser();
    return FakeUserCredential();
  }

  @override
  Future<UserCredential> createUserWithEmailAndPassword({required String email, required String password}) async {
    registerCalled = true;
    if (shouldFailRegister) {
      throw FirebaseAuthException(code: 'weak-password', message: 'Password is too weak');
    }
    _currentUser = FakeUser();
    return FakeUserCredential();
  }

  @override
  Future<void> signOut() async {
    signOutCalled = true;
    _currentUser = null;
  }

  @override
  User? get currentUser => _currentUser;

  @override
  Stream<User?> authStateChanges() => Stream.value(_currentUser);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeGoogleSignInAccount implements GoogleSignInAccount {
  @override
  String get email => 'test@gmail.com';

  @override
  String get id => 'fake-google-id';

  @override
  String get displayName => 'Test User';

  @override
  Future<GoogleSignInAuthentication> get authentication async => FakeGoogleSignInAuthentication();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeGoogleSignInAuthentication implements GoogleSignInAuthentication {
  @override
  String? get accessToken => 'fake-access-token';

  @override
  String? get idToken => 'fake-id-token';

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeGoogleSignIn implements GoogleSignIn {
  bool signOutCalled = false;
  bool shouldFailSignIn = false;
  GoogleSignInAccount? _currentUser;

  @override
  Future<GoogleSignInAccount?> signIn() async {
    if (shouldFailSignIn) {
      throw Exception('Google sign in failed');
    }
    _currentUser = FakeGoogleSignInAccount();
    return _currentUser;
  }

  @override
  Future<GoogleSignInAccount?> signOut() async {
    signOutCalled = true;
    _currentUser = null;
    return null;
  }

  @override
  GoogleSignInAccount? get currentUser => _currentUser;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('AuthViewModel', () {
    late FakeFirebaseAuth fakeAuth;
    late FakeGoogleSignIn fakeGoogle;
    late AuthViewModel viewModel;

    setUp(() {
      fakeAuth = FakeFirebaseAuth();
      fakeGoogle = FakeGoogleSignIn();
      viewModel = AuthViewModel(auth: fakeAuth, googleSignIn: fakeGoogle);
    });

    test('signIn succès', () async {
      fakeAuth.shouldFailSignIn = false;
      final result = await viewModel.signIn('test@test.com', 'good');
      expect(result, isNull);
      expect(fakeAuth.signInCalled, true);
    });

    test('signIn échec', () async {
      fakeAuth.shouldFailSignIn = true;
      final result = await viewModel.signIn('test@test.com', 'bad');
      expect(result, 'Incorrect password. Please try again.');
      expect(fakeAuth.signInCalled, true);
    });

    test('register succès', () async {
      fakeAuth.shouldFailRegister = false;
      final result = await viewModel.register('test@test.com', 'goodpass');
      expect(result, isNull);
      expect(fakeAuth.registerCalled, true);
    });

    test('register échec', () async {
      fakeAuth.shouldFailRegister = true;
      final result = await viewModel.register('test@test.com', 'short');
      expect(result, 'Password is too weak. Use at least 6 characters.');
      expect(fakeAuth.registerCalled, true);
    });

    test('signOut appelle les deux services', () async {
      await viewModel.signOut();
      expect(fakeAuth.signOutCalled, true);
      expect(fakeGoogle.signOutCalled, true);
    });
  });
}