// ignore_for_file: deprecated_member_use, unused_local_variable

import 'package:animate_do/animate_do.dart';
import 'package:date_in_firebase/bloc/auth/authentication_cubit.dart';
import 'package:date_in_firebase/bloc/connectivity/connectivity_cubit.dart';
import 'package:date_in_firebase/presentation/widgets/mybutton.dart';
import 'package:date_in_firebase/presentation/widgets/myindicator.dart';
import 'package:date_in_firebase/shared/constants/assets_path.dart';
import 'package:date_in_firebase/shared/constants/strings.dart';
import 'package:date_in_firebase/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

/// [SAYFA AÇIKLAMASI]
/* 
  
  AuthenticationCubit authcubit = BlocProvider.of(context); ve ConnectivityCubit connectivitycubit = BlocProvider.of(context); 
  satırları, kimlik doğrulama (authentication) ve bağlantı durumu (connectivity) ile ilgili AuthenticationCubit ve ConnectivityCubit 
  nesnelerini almak için kullanılır. 
  Bu nesneler, kullanıcının kimlik doğrulama durumunu ve internet bağlantı durumunu yöneten Cubit'lerdir.

Scaffold widget'i, sayfanın temel yapısını sağlar ve arka plan rengini belirler.

BlocConsumer widget'i, Cubit'in durumunu dinleyerek ve buna göre arayüzünü güncelleyerek çalışır.
 Dinleyici fonksiyonu (listener) tarafından kullanıcı kimlik doğrulamasının başarılı olduğu durumda 
 ana sayfaya yönlendirme işlemi gerçekleştirilir.

AuthenticationLoadingState durumunda, yani kimlik doğrulama işlemi devam ederken, 
yükleniyor göstergesi (MyCircularIndicator) görüntülenir.

 Eğer kimlik doğrulama başarılı değilse (AuthenticationSuccessState değilse),
 hoş geldin sayfası gösterilir. 
 Bu durumda, sayfa üzerinde bir resim (Image.asset), 
 başlık ve alt başlık metinleri (Text), "Giriş Yap" ve "Kayıt Ol" düğmeleri (MyButton) bulunur. 
 Bu düğmelere tıklanarak ilgili sayfalara yönlendirme yapılır.
  */

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthenticationCubit authcubit = BlocProvider.of(context);
    ConnectivityCubit connectivitycubit = BlocProvider.of(context);
    return Scaffold(
      backgroundColor: Appcolors.white,
      body: BlocConsumer<AuthenticationCubit, AuthenticationState>(
        listener: (context, state) {
          if (state is AuthenticationSuccessState) {
            Navigator.pushReplacementNamed(context, homepage);
          }
        },
        builder: (context, state) {
          if (state is AuthenticationLoadingState) {
            return const MyCircularIndicator();
          }

          if (state is! AuthenticationSuccessState) {
            return SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    BounceInDown(
                      duration: const Duration(milliseconds: 1500),
                      child: Image.asset(
                        MyAssets.welcomesketch, //welcome resmi
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
                    Text(
                      'Merhaba !',  //welcome başlık
                      style: Theme.of(context)
                          .textTheme
                          .headline1
                          ?.copyWith(letterSpacing: 3),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Text(
                      'Date-In Uygulamasına Hoşgeldin !',  //welcome başlık
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.subtitle1?.copyWith(
                            letterSpacing: 3,
                            fontSize: 10.sp,
                            wordSpacing: 2,
                          ),
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
                    MyButton( 
                      color: Colors.deepPurple,
                      width: 80.w,
                      title: 'Giriş Yap',   //GİRİŞ BUTONU
                      func: () {
                        Navigator.pushNamed(context, loginpage);
                      },
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    MyButton(
                      color: Colors.deepPurple,
                      width: 80.w,
                      title: 'Kayıt Ol',  //KAYIT OL BUTONU
                      func: () {
                        Navigator.pushNamed(context, signuppage);
                      },
                    ),
                 
                  ],
                ),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }

}
