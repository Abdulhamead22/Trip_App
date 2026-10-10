import 'package:get/get.dart';

class MainController extends GetxController {
  static const int homeIndex = 0;
  static const int tripsIndex = 1;
  static const int addIndex = 2;
  static const int moreIndex = 3;

  final RxInt currentIndex = homeIndex.obs;

  void changeTab(int index) {
    currentIndex.value = index;
  }
}
