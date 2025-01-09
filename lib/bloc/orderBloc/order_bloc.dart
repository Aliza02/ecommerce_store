import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_store/bloc/orderBloc/order_events.dart';
import 'package:ecommerce_store/bloc/orderBloc/order_states.dart';
import 'package:ecommerce_store/models/order.model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderBloc extends Bloc<OrderEvents, OrdersStates> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  OrderBloc() : super(LoadingState()) {
    on<GetAllOrders>((event, emit) async {
      List<Orders> allorders = await getAllOrders();
      emit(AllOrdersLoaded(allorders));
    });
  }

  Future<List<Orders>> getAllOrders() async {
    List<Orders> orders = [];
    QuerySnapshot snap = await FirebaseFirestore.instance
        .collection(auth.currentUser!.uid)
        .get();
    for (int i = 0; i < snap.docs.length; i++) {
      orders.add(Orders.fromMap(snap.docs[i].data() as Map<String, dynamic>));
    }

    return orders;
  }
}
