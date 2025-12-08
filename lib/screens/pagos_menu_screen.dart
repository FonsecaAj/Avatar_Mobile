import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modulo_mobil/widgets/main_layout.dart';

class PagosMenuScreen extends StatelessWidget {
  const PagosMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: "Pagos",
      currentIndex: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 18),
              ),
              onPressed: () => Get.toNamed('/facturas'),
              icon: const Icon(Icons.receipt_long, size: 26),
              label: const Text(
                "Facturas",
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 18),
              ),
              onPressed: () => Get.toNamed('/pagos-realizados'),
              icon: const Icon(Icons.payments, size: 26),
              label: const Text(
                "Pagos Realizados",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
