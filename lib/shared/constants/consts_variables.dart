import 'package:date_in_firebase/data/models/onboarding_model.dart';
import 'package:date_in_firebase/shared/constants/assets_path.dart';
import 'package:date_in_firebase/shared/styles/colors.dart';
import 'package:flutter/material.dart';

List<OnBoardingModel> onboardinglist = const [
  OnBoardingModel(
    img: MyAssets.onboradingone,
    title: 'Planlarınızı yönetin ',
    description:
        'Bu Küçük Uygulama ile Tüm Görevlerinizi ve Görevlerinizi Tek Bir Uygulamada Düzenleyebilirsiniz.',
  ),
  OnBoardingModel(
    img: MyAssets.onboradingtwo,
    title: 'Gününüzü Planlayın ',
    description: 'Plan ekleyin, gün içinde planlarınızı hatırlatsın!',
  ),
  OnBoardingModel(
    img: MyAssets.onboradingthree,
    title: 'Hedeflerinize Ulaşın ',
    description: 'Planlarınızı Takip Edin ve Hedeflerinize Ulaşın.',
  ),
];

const List<Color> colors = [Appcolors.bleu, Appcolors.pink, Appcolors.yellow];

const List<String> profileimages = [
  MyAssets.profileicon1,
  MyAssets.profileicon2,
  MyAssets.profileicon3,
  MyAssets.profileicon4,
];

int profileimagesindex = 0;
