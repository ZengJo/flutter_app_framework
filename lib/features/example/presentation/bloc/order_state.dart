enum OrderStatus {
  initial,
  creating,
  pendingPayment,
  paying,
  paid,
  completed,
  failure,
}

class OrderState {
  final OrderStatus status;
  final String? message;

  const OrderState({required this.status, this.message});

  const OrderState.initial() : status = OrderStatus.initial, message = null;

  OrderState copyWith({OrderStatus? status, String? message}) {
    return OrderState(
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }
}
