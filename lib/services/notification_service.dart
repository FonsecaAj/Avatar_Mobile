import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationService {
  static void showSuccess(String message) {
    Get.snackbar(
      'Éxito',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF7BA892),
      colorText: Colors.white,
      icon: const Icon(Icons.check_circle, color: Colors.white),
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      duration: const Duration(seconds: 3),
    );
  }

  static void showError(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFFC85A54),
      colorText: Colors.white,
      icon: const Icon(Icons.error, color: Colors.white),
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      duration: const Duration(seconds: 3),
    );
  }

  static void showWarning(String message) {
    Get.snackbar(
      'Advertencia',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFFD4A574),
      colorText: Colors.white,
      icon: const Icon(Icons.warning, color: Colors.white),
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      duration: const Duration(seconds: 3),
    );
  }

  static void showInfo(String message) {
    Get.snackbar(
      'Información',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF5B8FA3),
      colorText: Colors.white,
      icon: const Icon(Icons.info, color: Colors.white),
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      duration: const Duration(seconds: 3),
    );
  }

  static Future<bool> showConfirmDialog({
    required String title,
    required String message,
    String confirmText = 'Confirmar',
    String cancelText = 'Cancelar',
  }) async {
    final result = await Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2F496E),
          ),
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(
              cancelText,
              style: const TextStyle(color: Color(0xFF666666)),
            ),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFC3A38E),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(confirmText),
          ),
        ],
      ),
      barrierDismissible: false,
    );
    return result ?? false;
  }
}
