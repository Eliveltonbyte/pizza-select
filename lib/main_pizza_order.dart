import 'package:flutter/material.dart';
import 'pizza_order_details.dart';

void main() {
  runApp(const MainPizzaOrderApp());
}

class MainPizzaOrderApp extends StatelessWidget {
  const MainPizzaOrderApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home: const PizzaOrderDetails(),
    );
  }
}
