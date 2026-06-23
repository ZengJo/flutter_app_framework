abstract class OrderEvent {
  const OrderEvent();
}

class CreateOrderRequested extends OrderEvent {
  const CreateOrderRequested();
}

class PayOrderRequested extends OrderEvent {
  const PayOrderRequested();
}

class CompleteOrderRequested extends OrderEvent {
  const CompleteOrderRequested();
}
