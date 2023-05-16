// ignore_for_file: deprecated_member_use

import 'package:animate_do/animate_do.dart';
import 'package:date_in_firebase/bloc/auth/authentication_cubit.dart';
import 'package:date_in_firebase/bloc/connectivity/connectivity_cubit.dart';
import 'package:date_in_firebase/data/hive_db.dart';
import 'package:date_in_firebase/presentation/widgets/mybutton.dart';
import 'package:date_in_firebase/presentation/widgets/myindicator.dart';
import 'package:date_in_firebase/presentation/widgets/mysnackbar.dart';
import 'package:date_in_firebase/presentation/widgets/mytextfield.dart';
import 'package:date_in_firebase/shared/constants/strings.dart';
import 'package:date_in_firebase/shared/styles/colors.dart';
import 'package:date_in_firebase/shared/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

///[SAYFA AÇIKLAMASI]
///
/*

Kullanıcıdan e-posta ve parola bilgilerini alarak giriş yapmasını sağlıyor.
Şimdi kodun adımlarını ayrıntılı olarak açıklayalım:

LoginPage sınıfı StatefulWidget'dan türetilmiştir ve giriş sayfasının durumunu yönetmek için bir 
State sınıfı olan _LoginPageState'e sahiptir.

initState metodu, giriş sayfası oluşturulduğunda çalışır. Burada, _emailcontroller ve _passwordcontroller 
adlı TextEditingController nesneleri oluşturulur ve bu nesneler giriş alanlarına bağlanır.

dispose metodu, giriş sayfası kapatıldığında çalışır ve TextEditingController nesnelerinin bellekten temizlenmesini sağlar.

build metodu, giriş sayfasının görüntüsünü oluşturur. Bu metot, BlocConsumer widget'ını kullanarak 
AuthenticationCubit ve ConnectivityCubit'tan gelen verileri dinler.

Eğer AuthenticationLoadingState durumunda ise, yani kullanıcı giriş yapılırken bekleniyorsa,
 bir yüklenme göstergesi (MyCircularIndicator) görüntülenir.

Eğer AuthenticationSuccessState durumu değilse, yani kullanıcı giriş yapmamışsa, bir form görüntülenir. 
Bu form, _formKey adlı bir anahtar kullanarak doğrulama işlemlerini gerçekleştirir.

Formun içeriği, animasyonlu (BounceInDown) bir şekilde ekrana gelir. 
Giriş alanları ve giriş yap düğmesi (MyTextfield ve MyButton) bulunur.

Kullanıcı doğrulama işlemi yapmak için giriş yap düğmesine tıkladığında, 
_authenticatewithemailandpass metodu çağrılır.

_authenticatewithemailandpass metodu, formun geçerli olup olmadığını kontrol eder 
(_formKey.currentState!.validate()). Geçerliyse, AuthenticationCubit'i kullanarak kullanıcıyı giriş yapmaya çalışır.
 
  */

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController _emailcontroller;
  late TextEditingController _passwordcontroller;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    hiveGet('burc');
    _emailcontroller = TextEditingController();
    _passwordcontroller = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();

    _emailcontroller.dispose();
    _passwordcontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AuthenticationCubit authcubit = BlocProvider.of(context);
    ConnectivityCubit connectivitycubit = BlocProvider.of(context);
    return Scaffold(
      backgroundColor: Appcolors.white,
      appBar: AppBar(
        backgroundColor: Appcolors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(
            Icons.arrow_back,
            color: Appcolors.black,
            size: 30,
          ),
        ),
      ),
      body: BlocConsumer<AuthenticationCubit, AuthenticationState>(
        listener: (context, state) {
          if (state is AuthenticationErrortate) {
            // Kullanıcı geçersiz kimlik bilgileri girdiyse hata mesajı gösteriliyor
            MySnackBar.error(
                message: state.error.toString(),
                color: Colors.red,
                context: context);
          }
        },
        builder: (context, state) {
          if (state is AuthenticationLoadingState) {
            return const MyCircularIndicator();
          }
          if (state is! AuthenticationSuccessState) {
            return SafeArea(
                child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
                child: Form(
                  key: _formKey,
                  child: BounceInDown(
                    duration: const Duration(milliseconds: 1500),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hoşgeldin !',
                          style:
                              Theme.of(context).textTheme.headline1?.copyWith(
                                    fontSize: 20.sp,
                                    letterSpacing: 2,
                                  ),
                        ),
                        SizedBox(
                          height: 1.5.h,
                        ),
                        Text(
                          'Lütfen Giriş Yap',
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              ?.copyWith(
                                  fontSize: 12.sp,
                                  letterSpacing: 2,
                                  fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        MyTextfield(
                          hint: 'E-Postanız',
                          icon: Icons.email,
                          keyboardtype: TextInputType.emailAddress,
                          validator: (value) {
                            return !Validators.isValidEmail(value!)
                                ? 'Lütfen geçerli bir e-posta girin'
                                : null;
                          },
                          textEditingController: _emailcontroller,
                        ),
                        SizedBox(
                          height: 4.h,
                        ),
                        MyTextfield(
                          hint: 'Parolanız',
                          icon: Icons.password,
                          keyboardtype: TextInputType.text,
                          obscure: true,
                          validator: (value) {
                            return value!.length < 6
                                ? "Min. 6 karakter olmalıdır"
                                : null;
                          },
                          textEditingController: _passwordcontroller,
                        ),
                        SizedBox(
                          height: 4.h,
                        ),
                        MyButton(
                          color: Colors.deepPurple,
                          width: 80.w,
                          title: 'Giriş Yap',
                          func: () {
                            if (connectivitycubit.state
                                is ConnectivityOnlineState) {
                              _authenticatewithemailandpass(context, authcubit);
                            } else {
                              MySnackBar.error(
                                  message:
                                      'Lütfen internet bağlantınızı kontrol edin!',
                                  color: Colors.red,
                                  context: context);
                            }
                          },
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Hesabınız Yok mu ?',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  ?.copyWith(
                                      fontSize: 8.sp,
                                      fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, signuppage);
                              },
                              child: Text(
                                'Kayıt Olun',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline1
                                    ?.copyWith(
                                      fontSize: 9.sp,
                                      color: Colors.deepPurple,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ));
          }
          return Container();
        },
      ),
    );
  }

  // Container _myDivider() {
  //   return Container(
  //     width: 27.w,
  //     height: 0.2.h,
  //     color: Appcolors.black,
  //   );
  // }

  void _authenticatewithemailandpass(context, AuthenticationCubit cubit) {
    if (_formKey.currentState!.validate()) {
      cubit.login(
          email: _emailcontroller.text, password: _passwordcontroller.text);
    }
  }
}
