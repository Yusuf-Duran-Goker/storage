// lib/controllers/order_controller.dart

import 'package:get/get.dart';
import 'package:storage/service/order_service.dart';
import '../models/user_order_model.dart';


/// Controller to manage and provide user orders via GetX.
class OrderController extends GetxController {
  final OrderService _orderService = OrderService();

  /// Reactive list of user orders
  final RxList<UserOrder> orders = <UserOrder>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Subscribe to the orders stream
    _orderService.ordersStream().listen((orderList) {
      orders.assignAll(orderList);
    });
  }

  @override
  void onClose() {
    // No explicit dispose needed for stream subscription since GetX handles
    super.onClose();
  }
}
