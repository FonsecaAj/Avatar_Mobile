import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modulo_mobil/controllers/LoginController.dart';
import 'package:modulo_mobil/services/notification_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  bool recordarme = false;
  bool obscurePassword = true;

  late final LoginController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(LoginController());
  }

  @override
  void dispose() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    super.dispose();
  }

  String? _validarEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'El email es requerido';
    }

    final dominio = controller.dominioPermitido.value;

    if (!value.endsWith('@$dominio')) {
      return 'Debe ser un correo @$dominio';
    }

    return null;
  }

  String? _validarPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'La contraseña es requerida';
    }
    return null;
  }

  Future<void> _handleLogin() async {
    if (!formKey.currentState!.validate()) return;

    final success = await controller.login(
      email: emailCtrl.text.trim(),
      password: passwordCtrl.text,
      recordarme: recordarme,
    );

    if (!mounted) return;

    if (success) {
      Get.offAllNamed('/home');
      NotificationService.showSuccess('Inicio de sesión exitoso');
    } else {
      NotificationService.showError(
        controller.error.value ?? 'Usuario y/o contraseña incorrectos',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF4A5F7F), Color(0xFF3D4E66)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Obx(() {
              return AbsorbPointer(
                absorbing: controller.isLoading.value,
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(24.0),
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 400),
                        decoration: BoxDecoration(
                          color: const Color(0xFF354A61),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 40,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(
                                top: 48,
                                bottom: 32,
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    width: 80,
                                    height: 80,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xFFC3A38E),
                                    ),
                                    child: const Icon(
                                      Icons.school,
                                      size: 40,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'Sistema Avatar',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Universidad CUC',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white.withOpacity(0.8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(16),
                                  bottomRight: Radius.circular(16),
                                ),
                              ),
                              padding: const EdgeInsets.all(32.0),
                              child: Form(
                                key: formKey,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    const Row(
                                      children: [
                                        Icon(
                                          Icons.email,
                                          size: 18,
                                          color: Color(0xFFC3A38E),
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Correo Electrónico',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF666666),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Obx(() {
                                      final dominio =
                                          controller.dominioPermitido.value;
                                      return TextFormField(
                                        controller: emailCtrl,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        validator: _validarEmail,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          color: Color(0xFF333333),
                                        ),
                                        decoration: InputDecoration(
                                          hintText: 'usuario@$dominio',
                                          hintStyle: const TextStyle(
                                            color: Color(0xFFBBBBBB),
                                            fontSize: 14,
                                          ),
                                          prefixIcon: const Icon(
                                            Icons.person,
                                            color: Color(0xFFC3A38E),
                                            size: 20,
                                          ),
                                          filled: true,
                                          fillColor: Colors.white,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                horizontal: 16,
                                                vertical: 12,
                                              ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            borderSide: const BorderSide(
                                              color: Color(0xFFDDDDDD),
                                              width: 1,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            borderSide: const BorderSide(
                                              color: Color(0xFFDDDDDD),
                                              width: 1,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            borderSide: const BorderSide(
                                              color: Color(0xFFC3A38E),
                                              width: 1,
                                            ),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            borderSide: const BorderSide(
                                              color: Colors.red,
                                              width: 1,
                                            ),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                borderSide: const BorderSide(
                                                  color: Colors.red,
                                                  width: 1,
                                                ),
                                              ),
                                        ),
                                      );
                                    }),
                                    const SizedBox(height: 20),
                                    const Row(
                                      children: [
                                        Icon(
                                          Icons.lock,
                                          size: 18,
                                          color: Color(0xFFC3A38E),
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Contraseña',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF666666),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    TextFormField(
                                      controller: passwordCtrl,
                                      obscureText: obscurePassword,
                                      validator: _validarPassword,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        letterSpacing: 1.5,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: '••••••••',
                                        hintStyle: const TextStyle(
                                          color: Color(0xFFBBBBBB),
                                          letterSpacing: 1.5,
                                        ),
                                        prefixIcon: const Icon(
                                          Icons.vpn_key,
                                          color: Color(0xFFC3A38E),
                                          size: 20,
                                        ),
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            obscurePassword
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                            color: const Color(0xFF999999),
                                            size: 20,
                                          ),
                                          onPressed: () {
                                            setState(
                                              () => obscurePassword =
                                                  !obscurePassword,
                                            );
                                          },
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 12,
                                            ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          borderSide: const BorderSide(
                                            color: Color(0xFFDDDDDD),
                                            width: 1,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          borderSide: const BorderSide(
                                            color: Color(0xFFDDDDDD),
                                            width: 1,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          borderSide: const BorderSide(
                                            color: Color(0xFFC3A38E),
                                            width: 1,
                                          ),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          borderSide: const BorderSide(
                                            color: Colors.red,
                                            width: 1,
                                          ),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          borderSide: const BorderSide(
                                            color: Colors.red,
                                            width: 1,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 18,
                                          height: 18,
                                          child: Checkbox(
                                            value: recordarme,
                                            onChanged: (value) {
                                              setState(
                                                () =>
                                                    recordarme = value ?? false,
                                              );
                                            },
                                            activeColor: const Color(
                                              0xFFC3A38E,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        const Text(
                                          'Recordar mi sesión',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Color(0xFF666666),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 24),
                                    ElevatedButton(
                                      onPressed: _handleLogin,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFFC3A38E,
                                        ),
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 14,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        elevation: 0,
                                      ),
                                      child: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.login, size: 18),
                                          SizedBox(width: 8),
                                          Text(
                                            'Iniciar Sesión',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    Text(
                                      '© ${DateTime.now().year} Universidad CUC. Todos los derechos reservados.',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: Color(0xFF999999),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (controller.isLoading.value)
                      const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xFFC3A38E),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
