// ignore_for_file: deprecated_member_use, avoid_print

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
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

///[SAYFA AÇIKLAMASI]
/* 


İlk olarak, gerekli kütüphaneler projeye eklenir. Bu kütüphaneler, form doğrulama, animasyonlar, metin alanları vb.
 gibi farklı işlevleri gerçekleştirmek için kullanılır.

SignUpPage adında bir Stateful widget tanımlanır. Bu widget, kayıt sayfasının ana bileşenini temsil eder.

_SignUpPageState adında bir state sınıfı tanımlanır ve SignUpPage widget'ına bağlanır.
_SignUpPageState sınıfı, initState ve dispose metodlarını override ederek, sayfadaki metin alanları için gerekli 
TextEditingController nesnelerini başlatır ve temizler.

build metodu, sayfanın görüntüsünü oluşturur.

BlocProvider kullanılarak AuthenticationCubit ve ConnectivityCubit örnekleri alınır.
 Bu örnekler, ilgili BLoC'lerin durumunu dinlemek ve işlem yapmak için kullanılır.

Scaffold bileşeni kullanılarak sayfa oluşturulur. Scaffold, bir uygulama sayfasının temel yapısını sağlar.

AppBar bileşeni, sayfanın üst kısmında görünen bir uygulama çubuğunu temsil eder. Burada geri düğmesi eklenmiştir.

body özelliği, sayfanın içeriğini temsil eder. BlocConsumer widget'ı kullanılarak, AuthenticationCubit'in durumunu dinleyen 
ve buna göre işlem yapan bir blok oluşturulur.

BlocConsumer'ın listener özelliği, AuthenticationCubit'in durum değişikliklerini dinler ve duruma göre ilgili mesajları gösterir.

BlocConsumer'ın builder özelliği, AuthenticationCubit'in durumuna göre sayfanın içeriğini oluşturur.

Eğer AuthenticationCubit'in durumu AuthenticationLoadingState ise, yüklenme göstergesi (MyCircularIndicator) görüntülenir.

Eğer AuthenticationCubit'in durumu AuthenticationSuccessState değilse, kullanıcı kayıt formunu doldurabilir.

Kayıt formu, bir Form bileşeni ile sarılıdır. Bu bileşen, form doğrulamasını gerçekleştirmek için kullanılır. 
Formda, GlobalKey ile _formKey tanımlanır.

BounceInDown animasyonu ile form elemanları ekrana yüklendiğinde animasyon efekti eklenir.

Kayıt formu içinde, ad, e-posta, şifre ve doğum tarihi alanlarını girmek için MyTextfield bileşenleri kullanılır.

Eğer internet bağlantısı varsa, "Kayıt Ol" düğmesine basıldığında `_signup

Eğer internet bağlantısı varsa, "Kayıt Ol" düğmesine basıldığında _signup fonksiyonu çağrılır.

_signup fonksiyonu, formun geçerli olup olmadığını kontrol eder. Eğer form geçerliyse, kullanıcının girdiği bilgileri alır 
ve AuthenticationCubit'in signUp metodunu çağırarak kullanıcıyı kaydeder.

Kullanıcının başarıyla kaydedildiği durumda AuthenticationSuccessState durumu alınır ve kullanıcı ana sayfaya yönlendirilir.

Eğer kayıt işlemi başarısız olursa, AuthenticationFailureState durumu alınır ve hata mesajı kullanıcıya gösterilir.

ConnectivityCubit ile internet bağlantısı durumu kontrol edilir. Eğer internet bağlantısı yoksa, 
kullanıcıya bir hata mesajı gösterilir.
MyTextFormField bileşeni, form alanlarını temsil eder. Bu bileşen, gerekli doğrulama
kurallarını uygular ve hata mesajlarını gösterir.
MyButton bileşeni, kayıt olma düğmesini temsil eder. 
Bu bileşen, tıklanabilir bir düğme olup, kullanıcının kayıt işlemini başlatır.
FlatButton bileşeni, zaten bir hesabı olan kullanıcıların giriş yapmalarını sağlar.

*/

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namecontroller;
  late TextEditingController _emailcontroller;
  late TextEditingController _passwordcontroller;
  late TextEditingController _datecontroller;
  var selectedDate = DateTime(2000);
  String? zodiacSign;

  @override
  void initState() {
    super.initState();
    _namecontroller = TextEditingController();
    _emailcontroller = TextEditingController();
    _passwordcontroller = TextEditingController();
    _datecontroller = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _namecontroller.dispose();
    _emailcontroller.dispose();
    _passwordcontroller.dispose();
    _datecontroller.dispose();
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
                          'Lütfen Kayıt Ol !',
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              ?.copyWith(
                                  fontSize: 12.sp,
                                  letterSpacing: 2,
                                  fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 6.h,
                        ),
                        MyTextfield(
                          hint: 'Adınız - Soyadınız',
                          icon: Icons.person,
                          keyboardtype: TextInputType.name,
                          validator: (value) {
                            return value!.length < 3 ? 'Geçersiz isim' : null;
                          },
                          textEditingController: _namecontroller,
                        ),
                        SizedBox(
                          height: 3.h,
                        ),
                        InkWell(
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              //doğum tarihi seçme
                              //locale: const Locale('tr'),
                              context: context,
                              initialDate: selectedDate,
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                              initialEntryMode: DatePickerEntryMode.calendar,
                              initialDatePickerMode: DatePickerMode.day,
                              helpText: 'Doğum Tarihini Seçiniz',
                              cancelText: 'Kapat',
                              confirmText: 'Onayla',
                              errorFormatText: 'Enter valid date',
                              errorInvalidText: 'Enter valid date range',
                              fieldLabelText: 'Doğum Tarihini Giriniz',
                              fieldHintText: 'Month/Date/Year',
                              //selectableDayPredicate: disableDate
                            );
                            if (pickedDate != null &&
                                pickedDate != selectedDate) {
                              selectedDate = pickedDate;
                              _datecontroller = TextEditingController(
                                  text: DateFormat("dd.MM.yyyy")
                                      .format(selectedDate)
                                      .toString());
                              print(_datecontroller);
                              setState(() {});
                            }
                          },
                          child: AbsorbPointer(
                            child: MyTextfield(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Lütfen tarih girin';
                                }
                                return null;
                              },
                              hint: 'Doğum Tarihiniz',
                              icon: Icons.person,
                              keyboardtype: TextInputType.datetime,
                              textEditingController: _datecontroller,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 3.h,
                        ),
                        MyTextfield(
                          hint: 'E-Postanız',
                          icon: Icons.email,
                          keyboardtype: TextInputType.emailAddress,
                          validator: (value) {
                            return !Validators.isValidEmail(value!)
                                ? 'Lütfen geçerli e-posta girin'
                                : null;
                          },
                          textEditingController: _emailcontroller,
                        ),
                        SizedBox(
                          height: 3.h,
                        ),
                        MyTextfield(
                          hint: 'Parolanız',
                          icon: Icons.password,
                          obscure: true,
                          keyboardtype: TextInputType.text,
                          validator: (value) {
                            return value!.length < 6
                                ? "Min. 6 karakter giriniz"
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
                          title: 'Kayıt Ol',
                          func: () {
                            if (connectivitycubit.state
                                is ConnectivityOnlineState) {
                              _signupewithemailandpass(context, authcubit);
                            } else {
                              MySnackBar.error(
                                  message:
                                      'Lütfen internet bağlantınızı kontrol edin',
                                  color: Colors.red,
                                  context: context);
                            }
                          },
                        ),
                        SizedBox(
                          height: 1.5.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Hesabınız var mı ?',
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
                                Navigator.pushNamed(context, loginpage);
                              },
                              child: Text(
                                'Giriş Yapın',
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

  void _signupewithemailandpass(context, AuthenticationCubit cubit) {
    if (_formKey.currentState!.validate()) {
      cubit.register(
          fullname: _namecontroller.text,
          email: _emailcontroller.text,
          password: _passwordcontroller.text);
      var day = selectedDate.day;
      var month = selectedDate.month;

      zodiacSign = findZodiacSign(day, month);
      print('BURCUNUZ BURADA YAZIYOR : $zodiacSign');
      hivePut('burc', zodiacSign);
    }
  }

  //BURC BULMA
  String findZodiacSign(int day, int month) {
    if ((month == 1 && day >= 20) || (month == 2 && day <= 18)) {
      return 'Kova';
    } else if ((month == 2 && day >= 19) || (month == 3 && day <= 20)) {
      return 'Balık';
    } else if ((month == 3 && day >= 21) || (month == 4 && day <= 19)) {
      return 'Koç';
    } else if ((month == 4 && day >= 20) || (month == 5 && day <= 20)) {
      return 'Boğa';
    } else if ((month == 5 && day >= 21) || (month == 6 && day <= 20)) {
      return 'İkizler';
    } else if ((month == 6 && day >= 21) || (month == 7 && day <= 22)) {
      return 'Yengeç';
    } else if ((month == 7 && day >= 23) || (month == 8 && day <= 22)) {
      return 'Aslan';
    } else if ((month == 8 && day >= 23) || (month == 9 && day <= 22)) {
      return 'Başak';
    } else if ((month == 9 && day >= 23) || (month == 10 && day <= 22)) {
      return 'Terazi';
    } else if ((month == 10 && day >= 23) || (month == 11 && day <= 21)) {
      return 'Akrep';
    } else if ((month == 11 && day >= 22) || (month == 12 && day <= 21)) {
      return 'Yay';
    } else {
      return 'Oğlak';
    }
  }
}
