import 'package:flutter/material.dart';
import 'package:order_it_2/components/my_receipt.dart';

class DeliveryProgressPage extends StatelessWidget {
  const DeliveryProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        // Retorna false para deshabilitar volver atrás
        return false;
      },
      child: const Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 100,
              ),
              MyReceipt()
            ],
          ),
        ),
      ),
    );
  }
}