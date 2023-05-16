// ignore_for_file: deprecated_member_use, no_leading_underscores_for_local_identifiers

import 'package:animate_do/animate_do.dart';
import 'package:date_in_firebase/bloc/auth/authentication_cubit.dart';
import 'package:date_in_firebase/bloc/connectivity/connectivity_cubit.dart';
import 'package:date_in_firebase/data/hive_db.dart';
import 'package:date_in_firebase/data/models/task_model.dart';
import 'package:date_in_firebase/data/repositories/firestore_crud.dart';
import 'package:date_in_firebase/presentation/widgets/mybutton.dart';
import 'package:date_in_firebase/presentation/widgets/myindicator.dart';
import 'package:date_in_firebase/presentation/widgets/mysnackbar.dart';
import 'package:date_in_firebase/presentation/widgets/mytextfield.dart';
import 'package:date_in_firebase/presentation/widgets/task_container.dart';
import 'package:date_in_firebase/shared/constants/assets_path.dart';
import 'package:date_in_firebase/shared/constants/consts_variables.dart';
import 'package:date_in_firebase/shared/constants/strings.dart';
import 'package:date_in_firebase/shared/services/notification_service.dart';
import 'package:date_in_firebase/shared/styles/colors.dart';
import 'package:date_picker_timeline_fixed/date_picker_timeline_fixed.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

///[SAYFA AÇIKLAMASI]
/*


kullanıcının profilini güncellemesi, çıkış yapması, tarih seçimi yapması, 
Görevleri görüntülemesi ve yeni görevler eklemesi bulunmaktadır.
Bu kod, Flutter kullanarak bir uygulamanın ana sayfasını oluşturan MyHomePage sınıfını içeriyor.
 Bu sınıf, StatefulWidget sınıfından türetilmiş ve State nesnesi olan _MyHomePageState sınıfını döndüren
  createState yöntemini uyguluyor.

_MyHomePageState sınıfı, State<MyHomePage> sınıfından türetilmiş ve MyHomePage sınıfının durumunu yönetiyor. 
currentdate adında bir statik değişken tanımlıyor ve bu değişkeni kullanarak geçerli tarihi saklıyor.

Aynı zamanda _usercontroller adında bir TextEditingController nesnesi oluşturuyor 
ve başlangıç değeri olarak FirebaseAuth.instance.currentUser!.displayName değerini kullanıyor.
Bu denetleyici, bir metin alanının içeriğini kontrol etmek için kullanılıyor.

Sınıfın initState yöntemi, super.initState() yöntemini çağırarak ilk durumu başlatıyor. 
Ardından hiveGet('burc') ve NotificationsHandler.requestpermission(context) işlevlerini çağırıyor. 
Bu işlevler, depolama yöntemi Hive'dan verileri getirmek ve bildirim iznini istemek için kullanılıyor.

dispose yöntemi, super.dispose() yöntemini çağırarak gereksiz kaynakları temizliyor.

build yöntemi, BuildContext ve State nesnesini parametre olarak alıyor ve ana sayfa görünümünü oluşturuyor. 
Bu yöntemde, blok yapısını kullanarak bir dizi BlocListener ve BlocBuilder bileşeni bulunuyor. 
Bu bileşenler, uygulama durumunu dinliyor ve duruma göre gerçekleştirilecek işlemleri belirliyor.

Ana dönüş değeri, BlocBuilder içindeki bir SafeArea bileşenidir. 
Bu bileşen, güvenli bir alanda içeriği düzenlemek için kullanılır.
 İçeriğinde bir sütun bulunur ve bu sütun, sayfa içeriğini dikey olarak düzenler.

Sütunun içinde, kullanıcı bilgilerini gösteren bir Row bulunur. 
Kullanıcıya bağlı olarak profil resmi, kullanıcı adı ve ayarlar simgesi görüntülenir.

Ardından tarih bilgisini gösteren bir Row ve "Plan Ekle" düğmesi bulunur.

Daha sonra, _buildDatePicker yöntemi çağırılarak tarih seçici bileşen oluşturulur.

Son olarak, görevleri listeleyen bir StreamBuilder bileşeni bulunur. 
Bu bileşen, bir veri akışını dinleyerek görevleri getirir ve ekranda listeler. 
Veri akışı hata verirse veya bağlantı beklenme durumunda ise ilgili durumu gösteren bileşenler görüntülenir.


_showBottomSheet yöntemi, alt sayfayı göstermek için bir showModalBottomSheet iletişim kutusu oluşturur.
 Bu yöntem, kullanıcı profiliyle ilgili ayarları düzenlemek veya çıkış yapmak için kullanılır.

İletişim kutusu içinde, profil resmi seçimi, kullanıcı adı güncelleme ve çıkış yapma gibi işlevleri 
gerçekleştirmek için gerekli bileşenler bulunur. Profil resmi seçimi için Wrap ve InkWell bileşenleri kullanılır. 
Kullanıcı adı güncelleme için MyTextField ve profil güncelleme düğmesi bulunur. Çıkış yapma için de bir düğme bulunur.

Alt sayfa oluşturulurken StatefulBuilder kullanılır, böylece alt sayfadaki bileşenlerin 
durumu güncellenirken sayfanın yeniden oluşturulmasını sağlar.

_updatelogo yöntemi, profil resmi seçildiğinde seçilen resmin dizinini 
günceller ve sayfayı yeniden oluşturur.

_nodatawidget yöntemi, hiçbir görev olmadığında görüntülenecek bir widget döndürür.
Bu durumda, bir resim ve bir metin içeren bir Center bileşeni oluşturur.

_buildDatePicker yöntemi, tarih seçici bileşeni oluşturur. Bu bileşen,
 DatePicker paketinden alınmıştır ve geçerli tarihi gösterir. Tarih seçildiğinde, 
 onDateChange işlevi çağrılır ve yeni tarihle birlikte sayfa yeniden oluşturulur.

 Bu kod parçası, Flutter uygulamalarında kullanılan bir ana sayfa bileşenini oluşturur.
 Bileşen, kullanıcının profil bilgilerini, görevleri listeleyen bir bölümü ve bazı ayarları 
 düzenlemek için bir alt sayfayı içerir.
  */

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static var currentdate = DateTime.now();

  final TextEditingController _usercontroller = TextEditingController(
      text: FirebaseAuth.instance.currentUser!.displayName);

  @override
  void initState() {
    super.initState();
    hiveGet('burc');
    NotificationsHandler.requestpermission(context);
  }

  @override
  void dispose() {
    super.dispose();

    _usercontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AuthenticationCubit authenticationCubit = BlocProvider.of(context);
    ConnectivityCubit connectivitycubit = BlocProvider.of(context);
    final user = FirebaseAuth.instance.currentUser;
    String username = user!.isAnonymous ? 'Anonymous' : 'User';

    return Scaffold(
        body: MultiBlocListener(
            listeners: [
          BlocListener<ConnectivityCubit, ConnectivityState>(
              listener: (context, state) {
            if (state is ConnectivityOnlineState) {
              MySnackBar.error(
                  message: 'İnnternete bağlanıldı',
                  color: Colors.green,
                  context: context);
            } else {
              MySnackBar.error(
                  message: 'İnternet bağlantınızı lütfen kontrol edin!',
                  color: Colors.red,
                  context: context);
            }
          }),
          BlocListener<AuthenticationCubit, AuthenticationState>(
            listener: (context, state) {
              if (state is UnAuthenticationState) {
                Navigator.pushNamedAndRemoveUntil(
                    context, welcomepage, (route) => false);
              }
            },
          )
        ],
            child: BlocBuilder<AuthenticationCubit, AuthenticationState>(
              builder: (context, state) {
                if (state is AuthenticationLoadingState) {
                  return const MyCircularIndicator();
                }

                return SafeArea(
                    child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              // NotificationsHandler.createNotification();
                            },
                            child: SizedBox(
                              height: 8.h,
                              child: Image.asset(
                                profileimages[profileimagesindex],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 3.w,
                          ),
                          Expanded(
                            child: Text(
                              user.displayName != null
                                  ? 'Merhaba ${user.displayName}'
                                  : ' Merhaba $username',
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline1!
                                  .copyWith(fontSize: 15.sp),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              _showBottomSheet(context, authenticationCubit);
                            },
                            child: Icon(
                              Icons.settings,
                              size: 25.sp,
                              color: Appcolors.black,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 3.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            DateFormat('MMMM, dd').format(currentdate),
                            style: Theme.of(context)
                                .textTheme
                                .headline1!
                                .copyWith(fontSize: 17.sp),
                          ),
                          const Spacer(),
                          MyButton(
                            color: Colors.deepPurple,
                            width: 40.w,
                            title: '+ Plan Ekle',
                            func: () {
                              Navigator.pushNamed(
                                context,
                                addtaskpage,
                              );
                            },
                          )
                        ],
                      ),
                      SizedBox(
                        height: 3.h,
                      ),
                      _buildDatePicker(context, connectivitycubit),
                      SizedBox(
                        height: 4.h,
                      ),
                      Expanded(
                          child: StreamBuilder(
                        stream: FireStoreCrud().getTasks(
                          mydate: DateFormat('yyyy-MM-dd').format(currentdate),
                        ),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<TaskModel>> snapshot) {
                          if (snapshot.hasError) {
                            return _nodatawidget();
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const MyCircularIndicator();
                          }

                          return snapshot.data!.isNotEmpty
                              ? ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    var task = snapshot.data![index];
                                    Widget _taskcontainer = TaskContainer(
                                      id: task.id,
                                      color: colors[task.colorindex],
                                      title: task.title,
                                      starttime: task.starttime,
                                      endtime: task.endtime,
                                      note: task.note,
                                    );
                                    return InkWell(
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, addtaskpage,
                                              arguments: task);
                                        },
                                        child: index % 2 == 0
                                            ? BounceInLeft(
                                                duration: const Duration(
                                                    milliseconds: 1000),
                                                child: _taskcontainer)
                                            : BounceInRight(
                                                duration: const Duration(
                                                    milliseconds: 1000),
                                                child: _taskcontainer));
                                  },
                                )
                              : _nodatawidget();
                        },
                      )),
                    ],
                  ),
                ));
              },
            )));
  }

  Future<dynamic> _showBottomSheet(
      BuildContext context, AuthenticationCubit authenticationCubit) {
    var user = FirebaseAuth.instance.currentUser!.isAnonymous;
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (context) {
        return SingleChildScrollView(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: StatefulBuilder(
            builder: ((context, setModalState) {
              return Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    (user)
                        ? Container()
                        : Wrap(
                            children: List<Widget>.generate(
                              4,
                              (index) => Padding(
                                padding: EdgeInsets.only(right: 2.w),
                                child: InkWell(
                                  onTap: () async {
                                    _updatelogo(index, setModalState);

                                    final prefs =
                                        await SharedPreferences.getInstance();
                                    await prefs.setInt('plogo', index);
                                  },
                                  child: Container(
                                      height: 8.h,
                                      width: 8.h,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  profileimages[index]),
                                              fit: BoxFit.cover)),
                                      child: profileimagesindex == index
                                          ? Icon(
                                              Icons.done,
                                              color: Colors.deepPurple,
                                              size: 8.h,
                                            )
                                          : null),
                                ),
                              ),
                            ),
                          ),
                    SizedBox(
                      height: 3.h,
                    ),
                    (user)
                        ? Container()
                        : MyTextfield(
                            hint: '',
                            icon: Icons.person,
                            validator: (value) {
                              return null;
                            },
                            textEditingController: _usercontroller),
                    SizedBox(
                      height: 3.h,
                    ),
                    (user)
                        ? Container()
                        : BlocBuilder<AuthenticationCubit, AuthenticationState>(
                            builder: (context, state) {
                              if (state is UpdateProfileLoadingState) {
                                return const MyCircularIndicator();
                              }

                              return MyButton(
                                color: Colors.green,
                                width: 80.w,
                                title: "Profili Güncelle",
                                func: () {
                                  if (_usercontroller.text == '') {
                                    MySnackBar.error(
                                        message: 'Ad boş geçilemez',
                                        color: Colors.red,
                                        context: context);
                                  } else {
                                    authenticationCubit.updateUserInfo(
                                        _usercontroller.text, context);
                                    setState(() {});
                                  }
                                },
                              );
                            },
                          ),
                    SizedBox(
                      height: 3.h,
                    ),
                    MyButton(
                      color: Colors.red,
                      width: 80.w,
                      title: "Çıkış Yap",
                      func: () {
                        authenticationCubit.signout();
                      },
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                  ],
                ),
              );
            }),
          ),
        );
      },
    );
  }

  void _updatelogo(int index, void Function(void Function()) setstate) {
    setstate(() {
      profileimagesindex = index;
    });
    setState(() {
      profileimagesindex = index;
    });
  }

  Widget _nodatawidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            MyAssets.clipboard,
            height: 30.h,
          ),
          SizedBox(height: 3.h),
          Text(
            'Herhangi bir plan bulunamadı',
            style: Theme.of(context)
                .textTheme
                .headline1!
                .copyWith(fontSize: 16.sp),
          ),
        ],
      ),
    );
  }

  SizedBox _buildDatePicker(
      BuildContext context, ConnectivityCubit connectivityCubit) {
    return SizedBox(
      height: 15.h,
      child: DatePicker(
        DateTime.now(),
        locale: 'tr_TR',
        width: 20.w,
        initialSelectedDate: DateTime.now(),
        dateTextStyle:
            Theme.of(context).textTheme.headline1!.copyWith(fontSize: 18.sp),
        dayTextStyle: Theme.of(context)
            .textTheme
            .subtitle1!
            .copyWith(fontSize: 10.sp, color: Appcolors.black),
        monthTextStyle: Theme.of(context)
            .textTheme
            .subtitle1!
            .copyWith(fontSize: 10.sp, color: Appcolors.black),
        selectionColor: Colors.deepPurple,
        onDateChange: (DateTime newdate) {
          setState(() {
            currentdate = newdate;
          });
          if (connectivityCubit.state is ConnectivityOnlineState) {
          } else {
            MySnackBar.error(
                message: 'Please Check Your Internet Conection',
                color: Colors.red,
                context: context);
          }
        },
      ),
    );
  }
}
