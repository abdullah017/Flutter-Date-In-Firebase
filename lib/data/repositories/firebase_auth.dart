import 'package:date_in_firebase/data/repositories/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthRepo implements UserRepository {
  final _firebaseAuth = FirebaseAuth.instance;

  FirebaseAuthRepo();

  @override
  Future<void> login({required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw 'Girilen bilgilere ait kullanıcı bulunumadı!';
      } else if (e.code == 'wrong-password') {
        throw 'E-Postanızı ya da Parolanızı yanlış girdiniz.';
      }
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<void> register(
      {required String fullname,
      required String email,
      required String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw 'Girilen parola çok zayıf.';
      } else if (e.code == 'email-already-in-use') {
        throw 'Bu E-Posta adresi zaten kayıtlı.';
      } else {
        throw 'Lütfen E-Posta adresini kontrol ediniz.';
      }
    } catch (e) {
      throw Exception('oops,Something wrong happend!');
    }
  }

  // Future<void> googleSignIn() async {
  //   try {
  //     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  //     final GoogleSignInAuthentication? googleAuth =
  //         await googleUser?.authentication;

  //     final credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth?.accessToken,
  //       idToken: googleAuth?.idToken,
  //     );

  //     await _firebaseAuth.signInWithCredential(credential);
  //   } catch (e) {
  //     throw Exception(e);
  //   }
  // }

  @override
  logout() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> signinanonym() async {
    try {
      await _firebaseAuth.signInAnonymously();
    } on FirebaseAuthException catch (e) {
      throw Exception(e.toString());
    }
  }
}
