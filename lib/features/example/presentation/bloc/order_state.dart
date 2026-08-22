/// 示例订单状态。
enum OrderStatus {
  initial,
  creating,
  pendingPayment,
  paying,
  paid,
  completed,
  failure,
}

/// 示例业务提示语义。
///
/// Bloc 层只保存“发生了什么”，不要直接保存中文/英文文案。
/// 真正展示时由 UI 结合当前 AppLocalizations 转成对应语言。
enum OrderMessageType {
  createdPendingPayment,
  paymentSucceeded,
  completed,
}

class OrderState {
  const OrderState({required this.status, this.messageType});

  const OrderState.initial()
    : status = OrderStatus.initial,
      messageType = null;

  final OrderStatus status;
  final OrderMessageType? messageType;

  OrderState copyWith({
    OrderStatus? status,
    OrderMessageType? messageType,
    bool clearMessage = false,
  }) {
    return OrderState(
      status: status ?? this.status,
      messageType: clearMessage ? null : messageType ?? this.messageType,
    );
  }
}
