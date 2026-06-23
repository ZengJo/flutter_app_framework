import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    return Scaffold(
      appBar: AppBar(title: const Text('Bloc Order Flow')),
      body: Center(
        child: BlocBuilder<OrderBloc, OrderState>(
          builder: (context, state) {
            return Text(
              'Status: ${state.status.name}\n${state.message ?? ''}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20),
            );
          },
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  context.read<OrderBloc>().add(const CreateOrderRequested());
                },
                child: const Text('创建订单'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  context.read<OrderBloc>().add(const PayOrderRequested());
                },
                child: const Text('支付'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
