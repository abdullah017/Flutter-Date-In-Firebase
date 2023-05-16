// ignore_for_file: deprecated_member_use

import 'package:date_in_firebase/bloc/onboarding/onboarding_cubit.dart';
import 'package:date_in_firebase/presentation/widgets/circular_button.dart';
import 'package:date_in_firebase/presentation/widgets/custom_dots.dart';
import 'package:date_in_firebase/presentation/widgets/mybutton.dart';
import 'package:date_in_firebase/presentation/widgets/onboarding_item.dart';
import 'package:date_in_firebase/shared/constants/consts_variables.dart';
import 'package:date_in_firebase/shared/constants/strings.dart';
import 'package:date_in_firebase/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../widgets/mycustompainter.dart';

/// [SAYFA AÇIKLAMASI]

/*  

Bu kod, bir Flutter uygulamasında kullanılan "OnboardingPage" adlı bir StatefulWidget'i içerir. 
Bu sayfa, uygulamanın başlangıcında kullanıcıya tanıtım ekranlarını sunmak için tasarlanmıştır.
 Kullanıcının sayfalar arasında gezinmesini sağlar ve son sayfada geçiş yaparak veya geç butonuna tıklayarak ana sayfaya yönlendirir.

Kodun ayrıntılarına geçelim:

_OnboardingPageState sınıfı, OnboardingPage sınıfının durum yönetimini sağlar ve PageController'ı yönetir.

initState() yöntemi, sayfa oluşturulduğunda PageController'ı başlatır.

dispose() yöntemi, sayfa sonlandığında PageController'ı temizler.

build() yöntemi, sayfa yapısını oluşturur. Scaffold widget'i, sayfanın temel yapısını sağlar ve arka plan rengini belirler.

BlocConsumer widget'i, OnboardingCubit'in durumunu dinler ve buna göre arayüzü günceller.
 Bu sayede, Cubit üzerindeki değişikliklerde sayfanın yeniden oluşturulması sağlanır.

SafeArea widget'i, içeriğin güvenli bir alanda görüntülenmesini sağlar.

Stack widget'i, içerisine yerleştirilen widget'ları üst üste bindirir.

İç içe geçmiş Container ve CustomPaint widget'ları, tanıtım sayfalarının ve arka planın tasarımını sağlar.

PageView.builder widget'i, tanıtım sayfalarını yatay bir kaydırma (swipe) ile sunar. 
Her bir sayfa için OnBoardingItem widget'ı oluşturulur ve gösterilir. 
Bu widget, sayfanın resmini, başlığını ve açıklamasını içerir.

CustomDots widget'i, sayfanın altında anlık durumu gösteren noktalardan oluşan bir dizi oluşturur.

MyButton widget'i, "Geç" butonunu temsil eder. Sadece son sayfada görünmez.

CircularButton widget'i, sayfa ilerlemesini ve son sayfada ana sayfaya geçişi sağlayan daire şeklinde bir düğmeyi temsil eder.
 İlgili ikon ve işlevler bu widget içinde bulunur.

Kod, OnboardingCubit'in durumunu dinleyerek sayfadaki değişiklikleri günceller ve kullanıcının son sayfada 
ana sayfaya geçiş yapmasını sağlar. Ayrıca, geçmişi kaydetmek için cubit.savepref('seen') işlevini kullanır.

 */

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  late PageController _pageController;

  @override
  void initState() {
    _pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: BlocConsumer<OnboardingCubit, OnboardingState>(
        listener: (context, state) {},
        builder: (context, state) {
          OnboardingCubit cubit = BlocProvider.of(context);
          return SafeArea(
              child: Column(
            children: [
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  Container(
                      width: 100.w,
                      height: 95.h,
                      color: Colors.deepPurple,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    _pageController.previousPage(
                                        duration:
                                            const Duration(milliseconds: 500),
                                        curve: Curves.easeIn);

                                    cubit.curruntindext > 0
                                        ? cubit.removefromindex()
                                        : null;
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20),
                                    child: Text(
                                      'Geri',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline1
                                          ?.copyWith(
                                            fontSize: 13.sp,
                                            color: Colors.white38,
                                          ),
                                    ),
                                  ),
                                ),
                                CustomDots(myindex: cubit.curruntindext),
                                SizedBox(
                                  width: 10.w,
                                )
                              ],
                            )
                          ],
                        ),
                      )),
                  SizedBox(
                    width: 100.w,
                    height: 90.h,
                    child: CustomPaint(
                      painter: const MycustomPainter(color: Appcolors.white),
                      child: SizedBox(
                        width: 80.w,
                        height: 50.h,
                        child: PageView.builder(
                          itemCount: onboardinglist.length,
                          physics: const NeverScrollableScrollPhysics(),
                          controller: _pageController,
                          itemBuilder: ((context, index) {
                            return OnBoardingItem(
                              index: index,
                              image: onboardinglist[index]
                                  .img, //ONBORARDING GORSELLERİ. GÖRSELLER onboardinglist'TEN GELİYOR
                              title: onboardinglist[index]
                                  .title, //ONBORARDING BAŞLIKLARI. BAŞLIKLAR onboardinglist'TEN GELİYOR
                              description: onboardinglist[index]
                                  .description, //ONBORARDING AÇIKLAMALARI. AÇIKLAMALAR onboardinglist'TEN GELİYOR
                            );
                          }),
                        ),
                      ),
                    ),
                  ),
                  cubit.curruntindext != onboardinglist.length - 1
                      ? Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: MyButton(
                                //GEÇ BUTONU
                                color: Colors.deepPurple,
                                width: 19.w,
                                title: 'Geç',
                                func: () {
                                  _pageController.animateToPage(
                                      onboardinglist.length - 1,
                                      duration:
                                          const Duration(milliseconds: 500),
                                      curve: Curves.easeOut);
                                  cubit.curruntindext <
                                          onboardinglist.length - 1
                                      ? cubit.skipindex()
                                      : null;
                                }),
                          ))
                      : Container(),
                  Positioned(
                    bottom: 10.h,
                    child: CircularButton(
                      color: Appcolors.pink.withOpacity(0.6),
                      width: 30.w,
                      icon: Icons.arrow_right_alt_sharp,
                      condition:
                          cubit.curruntindext != onboardinglist.length - 1,
                      func: () {
                        // İleriye gitmek için _pageController'ı kullanır
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );

                        // Eğer mevcut sayfa son sayfa değilse, cubit üzerindeki indeksi günceller
                        if (cubit.curruntindext < onboardinglist.length - 1) {
                          cubit.changeindex();
                        }
                        // Son sayfaya gelindiğinde, ana sayfaya yönlendirme yapar ve geçmişi kaydeder
                        else {
                          Navigator.pushReplacementNamed(context, welcomepage);
                          cubit.savepref('seen');
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ));
        },
      ),
    );
  }
}
