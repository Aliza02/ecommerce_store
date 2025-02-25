import 'package:ecommerce_store/api/api.dart';
import 'package:ecommerce_store/bloc/paymentBloc/event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cart/cart.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentStatus> {
  FlutterCart flutterCart = FlutterCart();
  double get totalAmount => flutterCart.total;
  PaymentBloc() : super(PaymentStatus.initial) {
    on<ProcessPayment>(
      (event, emit) async {
        emit(PaymentStatus.loading);
        bool status = await makePayment((totalAmount.round() * 100).toString());
        if (status) {
          emit(PaymentStatus.success);
        } else {
          emit(PaymentStatus.error);
        }
      },
    );
  }
}
