// ignore_for_file: deprecated_member_use, no_leading_underscores_for_local_identifiers

import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:date_in_firebase/data/hive_db.dart';
import 'package:date_in_firebase/data/models/task_model.dart';
import 'package:date_in_firebase/data/repositories/firestore_crud.dart';
import 'package:date_in_firebase/presentation/widgets/mybutton.dart';
import 'package:date_in_firebase/presentation/widgets/mytextfield.dart';
import 'package:date_in_firebase/shared/constants/consts_variables.dart';
import 'package:date_in_firebase/shared/styles/colors.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../shared/services/notification_service.dart';

///[SAYFA AÇIKLAMASI]
/* 

Kullanıcıların görev eklemelerine izin verir İşte kodun ayrıntıları:

Kod, gerekli bağımlılıkları ve paketleri içe aktaran import ifadeleriyle başlar.

AddTaskScreen sınıfı tanımlanır, StatefulWidget'i genişleterek eklemek için bir ekranı temsil eder.

_AddTaskScreenState sınıfı, AddTaskScreen için bir durum olarak tanımlanır.

_AddTaskScreenState sınıfı içinde, isEditMote, currentdate, _starthour, endhour, _selectedReminder 
ve _selectedcolor gibi çeşitli değişkenler bildirilir. Bu değişkenler, eklenen görevin durumunu yönetmek için kullanılır.

initState yöntemi, ekranın durumunu başlatmak ve metin alanları için denetleyicileri ayarlamak için geçersiz kılınır.

dispose yöntemi, ekran artık kullanılmadığında denetleyicileri kaldırmak için geçersiz kılınır.

build yöntemi, Flutter widget'larını kullanarak ekranın kullanıcı arayüzünü oluşturmak için geçersiz kılınır.

_buildform yöntemi, başlık, not, tarih ve saat gibi görev ayrıntıları için çeşitli giriş alanlarını 
içeren bir form widget'ı oluşturur.

_buildform yöntemi içinde, MyTextfield widget'ının birkaç örneği bulunur. 
Bu özel bir widget gibi görünüyor ve bir simgeyle birlikte metin girişi alanını temsil eder.

Görev için bir hatırlatma zamanı seçmek için DropdownButtonFormField widget'ı kullanılır.

_showdatepicker yöntemi, kullanıcı tarih alanına tıkladığında bir tarih seçiciyi göstermek için tanımlanır.

generateWeatherComment ve generateHoroscopeComment yöntemleri, mevcut ay ve burç işaretine dayalı rastgele yorumlar oluşturur.

*/

class AddTaskScreen extends StatefulWidget {
  final TaskModel? task;

  const AddTaskScreen({
    this.task,
    Key? key,
  }) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  get isEditMote => widget.task != null;

  late TextEditingController _titlecontroller;
  late TextEditingController _notecontroller;
  late DateTime currentdate;
  static var _starthour = TimeOfDay.now();

  var endhour = TimeOfDay.now();

  final _formKey = GlobalKey<FormState>();
  late int _selectedReminder;
  late int _selectedcolor;

  String generateWeatherComment() {
    final Random _random = Random();
    DateTime now = DateTime.now();
    int month = now.month;

    String _getRandomComment(List<String> comments) {
      final int randomIndex = _random.nextInt(comments.length);
      return comments[randomIndex];
    }

    if (month >= 6 && month <= 8) {
      return _getRandomComment([
        'Bugün hava sıcak! Plaj keyfi yapabilirsin.',
        'Hava harika! Bir piknik yapmanın tam zamanı.',
        'Sıcak bir yaz günü! Serinlemek için bir dondurma yiyebilirsin.',
      ]);
    } else if (month >= 9 && month <= 11) {
      return _getRandomComment([
        'Hava hala güzel! Bir doğa yürüyüşü yapabilirsin.',
        'Sonbahar havası var. Parkta vakit geçirmek için güzel bir gün.',
        'Hafif esintiyle serin bir gün. Açık havada kahve içebilirsin.',
      ]);
    } else if (month >= 12 || month <= 2) {
      return _getRandomComment([
        'Hava soğuk! Kalın giyinmeyi unutma.',
        'Kar yağışı var! Kar topu oynayabilirsin.',
        'Sıcak bir içecek alıp evde keyif yapabilirsin.',
      ]);
    } else {
      return _getRandomComment([
        'Hava güzel! Dışarıda aktiviteler yapabilirsin.',
        'Hava değişken. Yanına bir şemsiye almak iyi olabilir.',
        'Bugün hava ılıman. Yürüyüşe çıkabilirsin.',
      ]);
    }
  }

  String generateHoroscopeComment(String burc) {
    final Random _random = Random();

    String _getRandomComment(List<String> comments) {
      final int randomIndex = _random.nextInt(comments.length);
      return comments[randomIndex];
    }

    String comment = '';

    switch (burc) {
      case 'Koç':
        comment = _getRandomComment([
          'Bugün enerjik olacaksın! Hedeflerine odaklan ve başarıya ulaş.',
          'Daha cesur adımlar atmanın tam zamanı! Fırsatları değerlendir.',
          'Yeni başlangıçlar için harika bir gün! İsteklerini gerçekleştir.',
        ]);
        break;
      case 'Boğa':
        comment = _getRandomComment([
          'Sabırlı olman gereken bir gün! İç huzurunu koru ve sakin kal.',
          'Maddi konularda dikkatli olman gerekebilir. Harcamalarını kontrol et.',
          'İstikrarlı ve güvenli adımlar atmaya devam et. Başarı seninle.',
        ]);
        break;
      case 'İkizler':
        comment = _getRandomComment([
          'Bugün iletişim becerilerini kullan! Yeni ilişkiler kurabilirsin.',
          'Değişim zamanı! Yeni fikirleri değerlendir ve kendini geliştir.',
          'Mantıklı kararlar verme zamanı geldi. Düşünerek hareket et.',
        ]);
        break;
      case 'Yengeç':
        comment = _getRandomComment([
          'Aile ve ev konularında destek ara. Sevdiklerinle zaman geçir.',
          'Hissiyatını dengede tut. İç dünyana yönel ve kendini şımart.',
          'Duygusal bağlantılarını güçlendir. Empati yapman gereken bir dönem.',
        ]);
        break;
      case 'Aslan':
        comment = _getRandomComment([
          'Özgüvenini yansıt! Liderlik yeteneklerini ortaya koy.',
          'Yaratıcılığını kullanarak parlamaya devam et. Sahneye çık.',
          'Eğlenceye zaman ayır. Kendini mutlu hissedeceğin aktiviteler yap.',
        ]);
        break;
      case 'Başak':
        comment = _getRandomComment([
          'Detaylara dikkat et! Planlı ve düzenli olman gereken bir dönem.',
          'Sağlığına özen göster. Kendine iyi bak ve stresi azalt.',
          'Analitik yeteneklerini kullanarak sorunları çözmeye odaklan.',
        ]);
        break;
      case 'Terazi':
        comment = _getRandomComment([
          'Bugün dengeyi koruman gereken bir gün! Adaletli kararlar ver.',
          'İlişkilerine odaklanman gereken bir dönem. Uyumlu ve adil ol.',
          'Estetik zevkini kullanarak güzellikleri keşfet.',
        ]);
        break;
      case 'Akrep':
        comment = _getRandomComment([
          'Duygusal derinliğin artıyor. İç dünyana yolculuk yap.',
          'Gizemli ve çekici tarafını ortaya çıkar. Etrafındakileri etkile.',
          'Kendine güvenin tam. Hedeflerine odaklan ve başarıyı yakala.',
        ]);
        break;
      case 'Yay':
        comment = _getRandomComment([
          'Macera dolu bir gün! Yeni deneyimlere açık ol ve keşfet.',
          'Büyüme ve öğrenme zamanı. Bilgi ve bilgelik arayışında ol.',
          'Umut ve iyimserlikle dolu ol. Olumlu düşünceye odaklan.',
        ]);
        break;
      case 'Oğlak':
        comment = _getRandomComment([
          'Hedeflerine doğru emin adımlarla ilerle. Azimli ol.',
          'Pratiklik ve disiplin seninle. Planlı olmanın önemini hatırla.',
          'Sorumluluklarını yerine getir. Başarıya giden yolda ilerle.',
        ]);
        break;
      case 'Kova':
        comment = _getRandomComment([
          'Farklılıkları kucakla. Yaratıcı ve özgün fikirlerinle parla.',
          'Toplumsal konulara ilgi duy. Sosyal bir aktiviteye katıl.',
          'Bağımsızlığına değer ver. Kendi yolunu çizmeye devam et.',
        ]);
        break;
      case 'Balık':
        comment = _getRandomComment([
          'Duygusal bağlantılara önem ver. Sevgi dolu ilişkilere odaklan.',
          'Hayal gücünü kullanarak yaratıcı projeler üret.',
          'Ruhani deneyimlerin artıyor. İçsel yolculuğuna devam et.',
        ]);
        break;
      default:
        comment = 'Burcunuz için yorum bulunamadı.';
    }

    return comment;
  }

  List<DropdownMenuItem<int>> menuItems = const [
    DropdownMenuItem(
        value: 5,
        child: Text(
          "5 Dk. Önce Hatırlat",
        )),
    DropdownMenuItem(
        value: 10,
        child: Text(
          "10 Dk. Önce Hatırlat",
        )),
    DropdownMenuItem(
        value: 15,
        child: Text(
          "15 Dk. Önce Hatırlat",
        )),
    DropdownMenuItem(
        value: 20,
        child: Text(
          "20 Dk. Önce Hatırlat",
        )),
  ];

  @override
  void initState() {
    super.initState();

    _titlecontroller =
        TextEditingController(text: isEditMote ? widget.task!.title : '');
    _notecontroller =
        TextEditingController(text: isEditMote ? widget.task!.note : '');

    currentdate =
        isEditMote ? DateTime.parse(widget.task!.date) : DateTime.now();
    endhour = TimeOfDay(
      hour: _starthour.hour + 1,
      minute: _starthour.minute,
    );
    _selectedReminder = isEditMote ? widget.task!.reminder : 5;
    _selectedcolor = isEditMote ? widget.task!.colorindex : 0;
  }

  @override
  void dispose() {
    super.dispose();
    _titlecontroller.dispose();
    _notecontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: _buildform(context),
          ),
        ),
      ),
    );
  }

  Form _buildform(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 1.h,
          ),
          _buildAppBar(context),
          SizedBox(
            height: 3.h,
          ),
          Text(
            'Başlık',
            style: Theme.of(context)
                .textTheme
                .headline1!
                .copyWith(fontSize: 14.sp),
          ),
          SizedBox(
            height: 1.h,
          ),
          MyTextfield(
            hint: 'Başlık Girin',
            icon: Icons.title,
            showicon: false,
            validator: (value) {
              return value!.isEmpty ? "Lütfen başlık girin" : null;
            },
            textEditingController: _titlecontroller,
          ),
          SizedBox(
            height: 2.h,
          ),
          Text(
            'Notunuz',
            style: Theme.of(context)
                .textTheme
                .headline1!
                .copyWith(fontSize: 14.sp),
          ),
          SizedBox(
            height: 1.h,
          ),
          MyTextfield(
            hint: 'Notunuz',
            icon: Icons.ac_unit,
            showicon: false,
            maxlenght: 40,
            validator: (value) {
              return value!.isEmpty ? "Lütfen Notunuzu Girin" : null;
            },
            textEditingController: _notecontroller,
          ),
          Text(
            'Tarih',
            style: Theme.of(context)
                .textTheme
                .headline1!
                .copyWith(fontSize: 14.sp),
          ),
          SizedBox(
            height: 1.h,
          ),
          MyTextfield(
            hint: DateFormat('dd/MM/yyyy').format(currentdate),
            icon: Icons.calendar_today,
            readonly: true,
            showicon: false,
            validator: (value) {
              return null;
            },
            ontap: () {
              _showdatepicker();
            },
            textEditingController: TextEditingController(),
          ),
          SizedBox(
            height: 2.h,
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Başlangıç Saati',
                      style: Theme.of(context)
                          .textTheme
                          .headline1!
                          .copyWith(fontSize: 14.sp),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    MyTextfield(
                      hint: DateFormat('HH:mm a').format(DateTime(
                          0, 0, 0, _starthour.hour, _starthour.minute)),
                      icon: Icons.watch_outlined,
                      showicon: false,
                      readonly: true,
                      validator: (value) {
                        return null;
                      },
                      ontap: () {
                        Navigator.push(
                            context,
                            showPicker(
                              value: Time(
                                  hour: endhour.hour,
                                  minute: endhour.minute), // Time kullanılıyor
                              is24HrFormat: true,
                              accentColor: Colors.deepPurple,
                              onChange: (TimeOfDay newvalue) {
                                setState(() {
                                  _starthour = newvalue;
                                  endhour = TimeOfDay(
                                    hour: _starthour.hour < 22
                                        ? _starthour.hour + 1
                                        : _starthour.hour,
                                    minute: _starthour.minute,
                                  );
                                });
                              },
                            ));
                      },
                      textEditingController: TextEditingController(),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 4.w,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bitiş Tarihi',
                      style: Theme.of(context)
                          .textTheme
                          .headline1!
                          .copyWith(fontSize: 14.sp),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    MyTextfield(
                      hint: DateFormat('HH:mm a').format(
                          DateTime(0, 0, 0, endhour.hour, endhour.minute)),
                      icon: Icons.watch,
                      showicon: false,
                      readonly: true,
                      validator: (value) {
                        return null;
                      },
                      ontap: () {
                        Navigator.push(
                            context,
                            showPicker(
                              value: Time(
                                  hour: endhour.hour,
                                  minute: endhour.minute), // Time kullanılıyor
                              is24HrFormat: true,
                              minHour: _starthour.hour.toDouble() - 1,
                              accentColor: Colors.deepPurple,
                              onChange: (TimeOfDay newvalue) {
                                setState(() {
                                  endhour = newvalue;
                                });
                              },
                            ));
                      },
                      textEditingController: TextEditingController(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 2.h,
          ),
          Text(
            'Hatırlatıcı',
            style: Theme.of(context)
                .textTheme
                .headline1!
                .copyWith(fontSize: 14.sp),
          ),
          SizedBox(
            height: 1.h,
          ),
          _buildDropdownButton(context),
          SizedBox(
            height: 2.h,
          ),
          Text(
            'Renk',
            style: Theme.of(context)
                .textTheme
                .headline1!
                .copyWith(fontSize: 14.sp),
          ),
          SizedBox(
            height: 1.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Wrap(
                children: List<Widget>.generate(
                    3,
                    (index) => Padding(
                          padding: EdgeInsets.only(right: 2.w),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _selectedcolor = index;
                              });
                            },
                            child: CircleAvatar(
                                backgroundColor: colors[index],
                                child: _selectedcolor == index
                                    ? const Icon(
                                        Icons.done,
                                        color: Appcolors.white,
                                      )
                                    : null),
                          ),
                        )),
              ),
              MyButton(
                color: isEditMote ? Colors.green : Colors.deepPurple,
                width: 40.w,
                title: isEditMote ? "Güncelle" : 'Oluştur',
                func: () {
                  _addtask();
                },
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Text(
                  'Hava Durumu:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: Text(
                    generateWeatherComment(),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Text(
                  'Burç Yorumu:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: Text(
                    generateHoroscopeComment(hiveGet('burc')),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  _addtask() {
    if (_formKey.currentState!.validate()) {
      TaskModel task = TaskModel(
        title: _titlecontroller.text,
        note: _notecontroller.text,
        date: DateFormat('yyyy-MM-dd').format(currentdate),
        starttime: _starthour.format(context),
        endtime: endhour.format(context),
        reminder: _selectedReminder,
        colorindex: _selectedcolor,
        id: '',
      );
      isEditMote
          ? FireStoreCrud().updateTask(
              docid: widget.task!.id,
              title: _titlecontroller.text,
              note: _notecontroller.text,
              date: DateFormat('yyyy-MM-dd').format(currentdate),
              starttime: _starthour,
              endtime: endhour.format(context),
              reminder: _selectedReminder,
              colorindex: _selectedcolor,
            )
          : FireStoreCrud().addTask(task: task);

      NotificationsHandler.createScheduledNotification(
        date: currentdate.day,
        hour: _starthour.hour,
        minute: _starthour.minute - _selectedReminder,
        title: '${Emojis.time_watch} It Is Time For Your Task!!!',
        body: _titlecontroller.text,
      );

      NotificationsHandler.createScheduledNotification(
        date: currentdate.day,
        hour: endhour.hour,
        minute: endhour.minute - _selectedReminder,
        title: '${Emojis.time_watch} Your task ends now!!!',
        body: _titlecontroller.text,
      );

      Navigator.pop(context);
    }
  }

  DropdownButtonFormField<int> _buildDropdownButton(BuildContext context) {
    return DropdownButtonFormField(
      value: _selectedReminder,
      items: menuItems,
      style: Theme.of(context)
          .textTheme
          .headline1!
          .copyWith(fontSize: 9.sp, color: Colors.deepPurple),
      icon: Icon(
        Icons.arrow_drop_down,
        color: Colors.deepPurple,
        size: 25.sp,
      ),
      decoration: InputDecoration(
        fillColor: Colors.grey.shade200,
        filled: true,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: Colors.grey.shade200,
              width: 0,
            )),
        contentPadding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
      ),
      onChanged: (int? val) {
        setState(() {
          _selectedReminder = val!;
        });
      },
    );
  }

  _showdatepicker() async {
    var selecteddate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2200),
      currentDate: DateTime.now(),
    );
    setState(() {
      selecteddate != null ? currentdate = selecteddate : null;
    });
  }

  Row _buildAppBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.chevron_left,
            size: 30.sp,
          ),
        ),
        Text(
          isEditMote ? 'Güncelle' : 'Ekle',
          style: Theme.of(context).textTheme.headline1,
        ),
        const SizedBox()
      ],
    );
  }
}
