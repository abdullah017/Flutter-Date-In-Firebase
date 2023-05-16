// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
part 'connectivity_state.dart';


///[AÇIKLAMA]
/*

Bu kod, internet bağlantısının durumunu takip etmek için kullanılan bir Cubit olan ConnectivityCubit'i içerir.
İşlevleri aşağıdaki gibidir:

ConnectivityCubit sınıfı, Cubit<ConnectivityState>'den türetilir ve varsayılan olarak ConnectivityInitial durumuyla başlar.

_connectivity adında bir Connectivity nesnesi oluşturulur. Bu nesne, connectivity_plus paketinin bir parçasıdır 
ve cihazın bağlantı durumunu izlemek için kullanılır.

hasConnection adında bir nullable bool değişkeni tanımlanır.
Bu değişken, internet bağlantısı durumunu tutar.initializeConnectivity fonksiyonu, bağlantı durumunu başlatmak için kullanılır. 

İçerisinde _connectivity.onConnectivityChanged dinleyicisi tanımlanır 
ve _connectionChange fonksiyonunu çağırır. Ayrıca, mevcut bağlantı durumunu kontrol eder.

_connectionChange fonksiyonu, bağlantı durumu değiştiğinde çağrılır 
ve bağlantı durumunu kontrol etmek için _checkConnection fonksiyonunu çağırır.

_checkConnection fonksiyonu, verilen ConnectivityResult parametresine göre bağlantı durumunu kontrol eder.

Eğer bağlantı durumu ConnectivityResult.none ise, hasConnection değişkeni false olarak ayarlanır 
ve _connectionChangeController fonksiyonu çağrılarak durum güncellenir.

Eğer bağlantı durumu farklı ise, InternetAddress.lookup yöntemi kullanılarak 'google.com' adresine bir sorgu yapılır. 

Eğer sorgu sonucunda dönen değer boş değilse ve IP adresi bilgisi içeriyorsa,
hasConnection değişkeni true olarak ayarlanır ve _connectionChangeController fonksiyonu çağrılarak durum güncellenir. 

Aksi takdirde, hasConnection değişkeni null ise false olarak ayarlanır ve durum güncellenir.

Eğer bir hata oluşursa (SocketException), hasConnection değişkeni false olarak ayarlanır 
ve _connectionChangeController fonksiyonu çağrılarak durum güncellenir.

_connectionChangeController fonksiyonu, bağlantı durumuna göre uygun durumu yayınlar.

Eğer _hasConnection true ise ConnectivityOnlineState durumu yayınlanır, aksi takdirde ConnectivityOfflineState durumu yayınlanır.


 */
class ConnectivityCubit extends Cubit<ConnectivityState> {
  ConnectivityCubit() : super(ConnectivityInitial());

  final _connectivity = Connectivity();
  bool? hasConnection;

  Future<void> initializeConnectivity() async {
    _connectivity.onConnectivityChanged.listen(_connectionChange);
    _checkConnection(await _connectivity.checkConnectivity());
  }

  void _connectionChange(ConnectivityResult result) {
    _checkConnection(result);
  }

  Future<bool?> _checkConnection(ConnectivityResult result) async {
    if (result == ConnectivityResult.none) {
      hasConnection = false;
      _connectionChangeController(hasConnection!);

      return hasConnection;
    }

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        hasConnection = true;
        _connectionChangeController(hasConnection!);
      } else {
        if (hasConnection == null) {
          hasConnection = false;
          _connectionChangeController(hasConnection!);
        }
      }
    } on SocketException catch (_) {
      hasConnection = false;
      _connectionChangeController(hasConnection!);
    }

    return hasConnection;
  }

  void _connectionChangeController(bool _hasConnection) {
    if (_hasConnection) {
      emit(ConnectivityOnlineState());
    } else {
      emit(ConnectivityOfflineState());
    }
  }
}
