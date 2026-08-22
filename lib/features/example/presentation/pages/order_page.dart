import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/globalization/extensions/localization_context_x.dart';
import '../../../../core/globalization/generated/app_localizations.dart';
import '../bloc/order_bloc.dart';
import '../bloc/order_event.dart';
import '../bloc/order_state.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => OrderBloc(), child: const _OrderView());
  }
}

class _OrderView extends StatelessWidget {
  const _OrderView();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.orderFlowTitle)),
      body: Center(
        child: BlocBuilder<OrderBloc, OrderState>(
          builder: (context, state) {
            final statusText = _statusText(l10n, state.status);
            final messageText = _messageText(l10n, state.messageType);

            return Text(
              messageText.isEmpty
                  ? '${l10n.orderStatusLabel}: $statusText'
                  : '${l10n.orderStatusLabel}: $statusText\n$messageText',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20),
            );
          },
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    context.read<OrderBloc>().add(const CreateOrderRequested());
                  },
                  child: Text(l10n.orderCreate),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    context.read<OrderBloc>().add(const PayOrderRequested());
                  },
                  child: Text(l10n.orderPay),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 将业务状态转换为当前语言文案。
  String _statusText(AppLocalizations l10n, OrderStatus status) {
    return switch (status) {
      OrderStatus.initial => l10n.orderStatusInitial,
      OrderStatus.creating => l10n.orderStatusCreating,
      OrderStatus.pendingPayment => l10n.orderStatusPendingPayment,
      OrderStatus.paying => l10n.orderStatusPaying,
      OrderStatus.paid => l10n.orderStatusPaid,
      OrderStatus.completed => l10n.orderStatusCompleted,
      OrderStatus.failure => l10n.orderStatusFailure,
    };
  }

  /// 将业务提示语义转换为当前语言文案。
  String _messageText(
    AppLocalizations l10n,
    OrderMessageType? messageType,
  ) {
    return switch (messageType) {
      OrderMessageType.createdPendingPayment =>
        l10n.orderMessageCreatedPendingPayment,
      OrderMessageType.paymentSucceeded => l10n.orderMessagePaymentSucceeded,
      OrderMessageType.completed => l10n.orderMessageCompleted,
      null => '',
    };
  }
}
