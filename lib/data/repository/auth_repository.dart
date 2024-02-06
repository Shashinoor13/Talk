import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:talk/data/model/user_model.dart';

class AuthRepository {
  final _firebaseAuth = FirebaseAuth.instance;
  final _firebaseStorage = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
      'https://www.googleapis.com/auth/userinfo.profile',
    ],
  );
  final user = FirebaseAuth.instance.authStateChanges();

  //check if already signed in
  Future<bool> isSignedIn() async {
    final currentUser = _firebaseAuth.currentUser;
    return currentUser != null;
  }

  Future<UserCredential> signIn(
      {required String email, required String password}) async {
    try {
      final user = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        throw Exception('Wrong password provided for that user.');
      } else if (e.code == 'invalid-credential') {
        throw Exception('Invalid credential');
      } else {
        throw Exception(e.toString());
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    try {
      late GoogleSignInAccount? currentUser;
      await _googleSignIn.signIn().then((value) => currentUser = value);
      final GoogleSignInAuthentication googleAuth =
          await currentUser!.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final user = await _firebaseAuth.signInWithCredential(credential);
      try {
        createAccountForUser(user);
      } catch (e) {
        throw Exception(e.toString());
      }
      return user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.toString());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<UserCredential> signUp(
      {required String email, required String password}) async {
    try {
      final user = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      try {
        createAccountForUser(user);
      } catch (e) {
        throw Exception(e.toString());
      }
      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw Exception('The password is too weak.');
      } else if (e.code == 'email-already-in-use') {
        throw Exception('An account already exists for this email.');
      } else if (e.code == 'invalid-email') {
        throw Exception('Invalid email');
      } else {
        throw Exception(e.toString());
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<UserModel> createAccountForUser(UserCredential userCredential) async {
    final user = userCredential.user;
    // final token = await user!.getIdToken();
    final UserModel newUser = UserModel(
      uid: user!.uid,
      email: user.email!,
      name: user.displayName ?? user.email!.split('@').first,
      profileUrl: user.photoURL ?? '',
      // token: token!,
    );

    await _firebaseStorage
        .collection('users')
        .doc(user.uid)
        .set(newUser.toMap());
    return newUser;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
  }
}
