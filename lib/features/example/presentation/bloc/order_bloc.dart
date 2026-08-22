import 'package:flutter_bloc/flutter_bloc.dart';

import 'order_event.dart';
import 'order_state.dart';

/// Bloc 只处理业务状态，不依赖 BuildContext / AppLocalizations。
///
/// 这样切换语言后，不需要重新执行业务逻辑，UI 会自动使用当前 Locale
/// 将 [OrderStatus] / [OrderMessageType] 映射成对应语言。
class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc() : super(const OrderState.initial()) {
    on<CreateOrderRequested>(_onCreateOrderRequested);
    on<PayOrderRequested>(_onPayOrderRequested);
    on<CompleteOrderRequested>(_onCompleteOrderRequested);
  }

  Future<void> _onCreateOrderRequested(
    CreateOrderRequested event,
    Emitter<OrderState> emit,
  ) async {
    emit(
      state.copyWith(
        status: OrderStatus.creating,
        clearMessage: true,
      ),
    );

    await Future.delayed(const Duration(seconds: 1));

    emit(
      state.copyWith(
        status: OrderStatus.pendingPayment,
        messageType: OrderMessageType.createdPendingPayment,
      ),
    );
  }

  Future<void> _onPayOrderRequested(
    PayOrderRequested event,
    Emitter<OrderState> emit,
  ) async {
    emit(
      state.copyWith(
        status: OrderStatus.paying,
        clearMessage: true,
      ),
    );

    await Future.delayed(const Duration(seconds: 1));

    emit(
      state.copyWith(
        status: OrderStatus.paid,
        messageType: OrderMessageType.paymentSucceeded,
      ),
    );
  }

  void _onCompleteOrderRequested(
    CompleteOrderRequested event,
    Emitter<OrderState> emit,
  ) {
    emit(
      state.copyWith(
        status: OrderStatus.completed,
        messageType: OrderMessageType.completed,
      ),
    );
  }
}
