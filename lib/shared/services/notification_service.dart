// ignore_for_file: avoid_print

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:date_in_firebase/shared/styles/colors.dart';
import 'package:flutter/material.dart';

import '../utilities.dart';

///[AÇIKLAMA]
///
/* 

Bu kod, awesome_notifications paketini kullanarak bildirimleri yönetmek için NotificationsHandler sınıfını içerir.
 İşlevleri aşağıdaki gibidir:

requestpermission fonksiyonu, bildirim izni talebinde bulunur. 
AwesomeNotifications().isNotificationAllowed() yöntemi kullanılarak bildirimlere izin verilip verilmediği kontrol edilir.
 Eğer izin verilmemişse, showDialog ile bir iletişim kutusu görüntülenir. 
 Bu iletişim kutusu, kullanıcıdan bildirim izni talep eder. 
 Kullanıcı izin vermediğinde İzin verme seçeneğiyle iletişim kutusu kapatılır. 
 Kullanıcı izin verdiğinde İzin ver seçeneğiyle bildirim izni talep edilir ve iletişim kutusu kapatılır.
createNotification fonksiyonu, anlık bir bildirim oluşturur. 
AwesomeNotifications().createNotification() yöntemi kullanılarak bildirim içeriği ve görüntüleme ayarları belirlenir.
 Bu örnekte, bildirimde bir başlık, bir gövde metni, varsayılan bir düzen ve belirli bir arka plan ve renk kullanılmıştır.
createScheduledNotification fonksiyonu, zamanlanmış bir bildirim oluşturur. 
AwesomeNotifications().createNotification() yöntemi kullanılarak bildirim içeriği ve görüntüleme ayarları belirlenir. 
Ayrıca, NotificationCalendar kullanılarak bildirimin ne zaman gösterileceği planlanır. 
Bu örnekte, bildirimde belirli bir tarih, saat ve dakika kullanılmıştır.
*/

class NotificationsHandler {
  static void requestpermission(context) {
    print('---------- requestpermission -----');
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Bildirimlere İzin Ver'),
            content: const Text('Uygulamamız size bildirim göndermek istiyor'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'İzin verme',
                  style: TextStyle(color: Colors.grey, fontSize: 18),
                ),
              ),
              TextButton(
                onPressed: () => AwesomeNotifications()
                    .requestPermissionToSendNotifications()
                    .then((_) => Navigator.pop(context)),
                child: const Text(
                  'İzin ver',
                  style: TextStyle(
                    color: Colors.teal,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      }
    });
  }

  static Future<void> createNotification() async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: createUniqueId(),
        channelKey: 'basic_channel',
        title: '${Emojis.time_watch} Planınızın hatırlatma saati',
        body: 'Planınızı şimdi kontrol edin !!',
        notificationLayout: NotificationLayout.Default,
        backgroundColor: Colors.amber,
        color: Appcolors.purple,
      ),
    );
  }

  static Future<void> createScheduledNotification({
    required int date,
    required int hour,
    required int minute,
    required String title,
    required String body,
  }) async {
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: createUniqueId(),
          channelKey: 'basic_channel',
          title: title,
          body: body,
          notificationLayout: NotificationLayout.Default,
          backgroundColor: Colors.amber,
          color: Appcolors.purple,
        ),
        schedule: NotificationCalendar(
          timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier(),
          day: date,
          hour: hour,
          minute: minute,
          second: 0,
          millisecond: 0,
        ));
  }
}
