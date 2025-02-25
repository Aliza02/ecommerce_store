enum PaymentStatus { initial, loading, success, error }

abstract class PaymentEvent {}

class ProcessPayment extends PaymentEvent {
  ProcessPayment();
}
