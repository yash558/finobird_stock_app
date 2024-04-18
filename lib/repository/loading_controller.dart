import 'package:get/get.dart';

class LoadingController extends GetxController {
  final _isLoading = true.obs;
  isLoading() => _isLoading.value;
  swap() => _isLoading.toggle();
}
