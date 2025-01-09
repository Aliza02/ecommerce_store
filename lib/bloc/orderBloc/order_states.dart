import 'package:ecommerce_store/models/order.model.dart';

abstract class OrdersStates {}

class LoadingState extends OrdersStates {}

class AllOrdersLoaded extends OrdersStates {
  final List<Orders> orders;

  AllOrdersLoaded(this.orders);
}
