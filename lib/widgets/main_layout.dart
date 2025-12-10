import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modulo_mobil/controllers/LoginController.dart';
import 'package:modulo_mobil/services/notification_service.dart';


class MainLayout extends StatelessWidget {
  final Widget child;
  final String title;
  final int currentIndex;


  const MainLayout({
    super.key,
    required this.child,
    required this.title,
    this.currentIndex = 0,
  });


  void _onTabTapped(int index) {
    switch (index) {
      case 0:
        if (currentIndex != 0) Get.offAllNamed('/home');
        break;
      case 1:
        if (currentIndex != 1) Get.toNamed('/mis-cursos');
        break;
      case 2:
        if (currentIndex != 2) Get.toNamed('/matricula');
        break;
      case 3:
        if (currentIndex != 3) Get.toNamed('/pagos');
        break;
      case 4:
        if (currentIndex != 4) Get.toNamed('/perfil');
        break;
    }
  }


  @override
  Widget build(BuildContext context) {
    final loginController = Get.find<LoginController>();


    return Scaffold(
      appBar: _buildAppBar(loginController),
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF2F496E),
        selectedItemColor: const Color(0xFFC3A38E),
        unselectedItemColor: Colors.white70,
        selectedFontSize: 12,
        unselectedFontSize: 11,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Mis Cursos'),
          BottomNavigationBarItem(
            icon: Icon(Icons.app_registration),
            label: 'Matrícula',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.payment), label: 'Pagos'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }


  PreferredSizeWidget _buildAppBar(LoginController loginController) {
    return AppBar(
      backgroundColor: const Color(0xFF2F496E),
      elevation: 0,
      title: Row(
        children: [
          const Icon(Icons.school, color: Color(0xFFC3A38E), size: 28),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      actions: [
        Obx(() {
          final usuario = loginController.usuarioActual.value;
          return PopupMenuButton<String>(
            offset: const Offset(0, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFFC3A38E), Color(0xFFB2927D)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFC3A38E).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.arrow_drop_down,
                    color: Colors.white70,
                    size: 20,
                  ),
                ],
              ),
            ),
            itemBuilder: (context) => [
              PopupMenuItem<String>(
                enabled: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFFC3A38E), Color(0xFFB2927D)],
                            ),
                          ),
                          child: const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            usuario?.nombre ?? 'Usuario',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Color(0xFF2F496E),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 16),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'perfil',
                child: Row(
                  children: [
                    Icon(
                      Icons.person_outline,
                      color: Color(0xFFC3A38E),
                      size: 20,
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Mi Perfil',
                      style: TextStyle(fontSize: 14, color: Color(0xFF2F496E)),
                    ),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                height: 1,
                enabled: false,
                child: Divider(height: 1),
              ),
              const PopupMenuItem<String>(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Color(0xFFC85A54), size: 20),
                    SizedBox(width: 12),
                    Text(
                      'Cerrar Sesión',
                      style: TextStyle(fontSize: 14, color: Color(0xFFC85A54)),
                    ),
                  ],
                ),
              ),
            ],
            onSelected: (value) async {
              if (value == 'perfil') {
                NotificationService.showInfo('Función próximamente');
              } else if (value == 'logout') {
                final confirmed = await NotificationService.showConfirmDialog(
                  title: 'Cerrar Sesión',
                  message: '¿Estás seguro que deseas cerrar sesión?',
                  confirmText: 'Sí, cerrar',
                  cancelText: 'Cancelar',
                );


                if (confirmed) {
                  await loginController.logout();
                  Get.offAllNamed('/login');
                  NotificationService.showSuccess(
                    'Sesión cerrada exitosamente',
                  );
                }
              }
            },
          );
        }),
      ],
    );
  }
}
