import 'package:flutter_bloc/flutter_bloc.dart';

import 'order_event.dart';
import 'order_state.dart';

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
    emit(state.copyWith(status: OrderStatus.creating));

    await Future.delayed(const Duration(seconds: 1));

    emit(
      state.copyWith(
        status: OrderStatus.pendingPayment,
        message: '订单创建成功，等待支付',
      ),
    );
  }

  Future<void> _onPayOrderRequested(
    PayOrderRequested event,
    Emitter<OrderState> emit,
  ) async {
    emit(state.copyWith(status: OrderStatus.paying));

    await Future.delayed(const Duration(seconds: 1));

    emit(state.copyWith(status: OrderStatus.paid, message: '支付成功'));
  }

  void _onCompleteOrderRequested(
    CompleteOrderRequested event,
    Emitter<OrderState> emit,
  ) {
    emit(state.copyWith(status: OrderStatus.completed, message: '订单已完成'));
  }
}
