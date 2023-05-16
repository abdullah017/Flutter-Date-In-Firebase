import 'package:bloc/bloc.dart';
import 'package:date_in_firebase/data/repositories/firebase_auth.dart';
import 'package:date_in_firebase/presentation/widgets/mysnackbar.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

part 'authentication_state.dart';

///[AÇIKLAMA]
/* 


İlk olarak, gerekli paketleri ve bağımlılıkları içe aktaran import ifadeleri yer alır.

AuthenticationCubit sınıfı, Cubit<AuthenticationState> sınıfını genişleterek tanımlanır.

Bu sınıf, kimlik doğrulama durumunu yönetir.

AuthenticationCubit sınıfı, AuthenticationInitial() durumuyla başlatılır.

FirebaseAuthRepo sınıfından bir örnek olan firebaseauthrepo değişkeni tanımlanır.

login metodu, kullanıcının e-posta ve şifreyle giriş yapmasını sağlar. Bu metod çağrıldığında, 
önce AuthenticationLoadingState() durumu yayınlanır. Ardından, firebaseauthrepo.login metodu kullanılarak 
giriş işlemi gerçekleştirilir. Başarılı olduğunda, kullanıcı adı kontrol edilerek boşsa "User" olarak ayarlanır. 

Son olarak, AuthenticationSuccessState() durumu yayınlanır. Hata oluştuğunda,
 AuthenticationErrortate ve UnAuthenticationState durumları yayınlanır.

register metodu, kullanıcının yeni bir hesap oluşturmasını sağlar. 

Benzer şekilde, önce AuthenticationLoadingState() durumu yayınlanır. Ardından, firebaseauthrepo.register metodu kullanılarak

kayıt işlemi gerçekleştirilir. Başarılı olduğunda, kullanıcı adı güncellenir ve AuthenticationSuccessState() durumu yayınlanır.

 Hata oluştuğunda, AuthenticationErrortate ve UnAuthenticationState durumları yayınlanır.

signout metodu, kullanıcının oturumu kapatmasını sağlar. firebaseauthrepo.logout() metodu çağrılarak oturum kapatma işlemi 
gerçekleştirilir ve UnAuthenticationState durumu yayınlanır.

updateUserInfo metodu, kullanıcının profil bilgisini güncellemesini sağlar. İlk olarak, UpdateProfileLoadingState() 
durumu yayınlanır. Ardından, kullanıcının adı güncellenir ve UpdateProfileSuccessState() durumu yayınlanır. 

Bu durumda, count değişkeni kullanılarak güncelleme işlemini iki kez tıklama gerektirir.

İlk tıklamada Navigator.pop(context) çağrısı yapılırken, ikinci tıklamada hata mesajı gösterilir. 
Hata durumunda ise UpdateProfileErrorState() durumu yayınlanır ve hata mesajı görüntülenir.

*/

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit() : super(AuthenticationInitial());

  FirebaseAuthRepo firebaseauthrepo = FirebaseAuthRepo();

  ///[AÇIKLAMA]
/* 
  
İşlem başladığında, AuthenticationLoadingState() durumunu yayınlayarak kullanıcıya bir yükleme göstergesi gösterilir.

firebaseauthrepo.login metodu, belirtilen e-posta ve şifreyle giriş yapmayı dener.

Giriş işlemi başarılı olduğunda, Firebase tarafından otomatik olarak oturum açmış kullanıcının bilgilerine erişilir.

Kullanıcının adı boş ise "User" olarak güncellenir.

Giriş işlemi başarılı olduğunda, AuthenticationSuccessState() durumunu yayınlayarak kullanıcıya girişin tamamlandığı bildirilir.

Hata oluştuğunda, catchError bloğu çalışır.

Hata durumunu AuthenticationErrortate(e.toString()) durumu olarak yayınlayarak kullanıcıya hata mesajı gösterilir.

Ardından, oturumu kapatma durumunu (UnAuthenticationState()) yayınlayarak kullanıcının oturumunu kapatır.
  
*/

  login({required String email, required String password}) {
    // Kimlik doğrulama işlemi başladığında Loading durumunu yayınla
    emit(AuthenticationLoadingState());

    // firebaseauthrepo.login metodu ile giriş işlemini gerçekleştir
    firebaseauthrepo.login(email: email, password: password).then((value) {
      final user = FirebaseAuth.instance.currentUser;
      // Kullanıcının adı boş ise "User" olarak güncelle
      user!.displayName == '' ? user.updateDisplayName('User') : null;

      // Giriş işlemi başarılı olduğunda Success durumunu yayınla
      emit(AuthenticationSuccessState());
    }).catchError((e) {
      // Hata oluştuğunda hata durumunu ve oturumu kapatma durumunu yayınla
      emit(AuthenticationErrortate(e.toString()));
      emit(UnAuthenticationState());
    });
  }

  ///[AÇIKLAMA]

/* 
İşlem başladığında, AuthenticationLoadingState() durumunu yayınlayarak kullanıcıya bir yükleme göstergesi gösterilir.

firebaseauthrepo.register metodu, kullanıcının belirtilen ad, e-posta ve şifreyle kaydolmasını dener.

Kayıt işlemi başarılı olduğunda, AuthenticationSuccessState() durumunu yayınlayarak kullanıcıya kaydın tamamlandığı bildirilir.

Kayıt işlemi başarılı olduğunda, Firebase tarafından otomatik olarak oturum açmış kullanıcının bilgilerine erişilir.

Kullanıcının adı, belirtilen tam ad ile güncellenir.

Hata oluştuğunda, catchError bloğu çalışır. 

Hata durumunu AuthenticationErrortate(e.toString()) durumu olarak yayınlayarak kullanıcıya hata mesajı gösterilir.

Ardından, oturumu kapatma durumunu (UnAuthenticationState()) yayınlayarak kullanıcının oturumunu kapatır.
*/
  register(
      {required String fullname,
      required String email,
      required String password}) {
    // Kayıt işlemi başladığında Loading durumunu yayınla
    emit(AuthenticationLoadingState());

    // firebaseauthrepo.register metodu ile kullanıcı kaydını gerçekleştir
    firebaseauthrepo
        .register(fullname: fullname, email: email, password: password)
        .then((value) {
      // Kayıt işlemi başarılı olduğunda Success durumunu yayınla
      emit(AuthenticationSuccessState());

      final user = FirebaseAuth.instance.currentUser;
      // Kullanıcının adını güncelle
      user!.updateDisplayName(fullname);
    }).catchError((e) {
      // Hata oluştuğunda hata durumunu ve oturumu kapatma durumunu yayınla
      emit(AuthenticationErrortate(e.toString()));
      emit(UnAuthenticationState());
    });
  }

  signout() async {
    await firebaseauthrepo.logout();
    emit(UnAuthenticationState());
  }

  var count = 0;

  void updateUserInfo(String txt, BuildContext context) {
    // count değişkeni 2'ye eşit veya daha büyükse, sıfırla; aksi halde null (yani değişiklik yapma)
    count >= 2 ? count = 0 : null;

    // Profil güncelleme işlemi başladığında Loading durumunu yayınla
    emit(UpdateProfileLoadingState());

    // Güncel kullanıcı bilgilerine eriş
    var user = FirebaseAuth.instance.currentUser;

    // Kullanıcının görünen adını txt parametresiyle güncelle
    user!.updateDisplayName(txt).then((value) {
      // Güncelleme işlemi başarılı olduğunda Success durumunu yayınla
      count++;
      Future.delayed(const Duration(seconds: 2));
      emit(UpdateProfileSuccessState());

      // İsim güncellemesi için iki kez tıklanması gerektiğini kullanıcıya bildir
      count == 2
          ? Navigator.pop(context) // İki kez tıklanıldıysa, bu sayfayı kapat
          : MySnackBar.error(
              message: 'Please Click Another Time !!',
              color: Colors.indigo,
              context: context);
    }).catchError((e) {
      // Hata durumunda Error durumunu yayınla
      emit(UpdateProfileErrorState());

      // Hata mesajını ve rengini belirterek kullanıcıya Snackbar göster
      MySnackBar.error(
          message: 'Lütfen internet bağlantınızı kontrol edin',
          color: Colors.red,
          context: context);
    });
  }
}
