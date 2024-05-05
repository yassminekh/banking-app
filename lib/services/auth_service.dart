import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(

    clientId: 'AIzaSyB9YrfelDGlH5gVM1oIjPJbdfpQzTK-IcQ.apps.googleusercontent.com',
  );
  // Méthode pour obtenir l'utilisateur actuellement connecté
  User? get currentUser => _auth.currentUser;
  // Méthode pour déconnecter l'utilisateur actuel
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  Future<bool> registerWithEmailAndPassword(
      String name, String email, String password) async {
    try {
      // Vérifiez d'abord si le formulaire est valide
      if (name.isEmpty || email.isEmpty || password.isEmpty) {
        // Si l'un des champs est vide, retournez false
        return false;
      }

      // Vérifiez si l'adresse e-mail est déjà utilisée par un autre compte
      var user = await _auth.fetchSignInMethodsForEmail(email);
      if (user.isNotEmpty) {
        // Si l'adresse e-mail est déjà utilisée, affichez un message d'erreur et retournez false
        print('Email address is already in use by another account');
        return false;
      }

      // Créez un nouvel utilisateur avec l'e-mail et le mot de passe
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? firebaseUser = result.user;

      // Mettez à jour le nom d'utilisateur
      if (firebaseUser != null) {
        await firebaseUser.updateDisplayName(name);
        // Si tout se passe bien, retournez true
        return true;
      } else {
        // Si la création de l'utilisateur échoue, retournez false
        return false;
      }
    } catch (e) {
      // Gérez les erreurs ici
      print('Error registering user: $e');
      return false;
    }
  }

  // Connexion avec email et mot de passe
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        // L'utilisateur est connecté avec Google, vous pouvez effectuer d'autres actions ici
        // Par exemple, vous pouvez appeler une autre méthode pour traiter l'authentification avec Firebase
        await handleGoogleSignIn(googleUser);
      }
    } catch (error) {
      print('Error signing in with Google: $error');
    }
  }

// Méthode pour traiter l'authentification avec Firebase après la connexion avec Google
  Future<void> handleGoogleSignIn(GoogleSignInAccount googleUser) async {
    try {
      // Récupérer les informations d'authentification Google
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Créer une AuthCredential avec les informations d'authentification Google
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Authentifier l'utilisateur avec Firebase en utilisant l'AuthCredential
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // Récupérer l'utilisateur authentifié
      final User? user = userCredential.user;

      if (user != null) {
        // L'utilisateur est authentifié avec succès
        print('User signed in with Google: ${user.displayName}');
      } else {
        // La connexion avec Google a réussi, mais l'authentification avec Firebase a échoué
        print('Authentication with Firebase failed');
      }
    } catch (error) {
      print('Error handling Google sign-in: $error');
    }
  }
}
