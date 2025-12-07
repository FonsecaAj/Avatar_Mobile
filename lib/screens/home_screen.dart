import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modulo_mobil/controllers/LoginController.dart';
import 'package:modulo_mobil/widgets/main_layout.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});


  @override
  Widget build(BuildContext context) {
    final loginController = Get.find<LoginController>();


    return MainLayout(
      title: 'Inicio',
      currentIndex: 0,
      child: Obx(() {
        final usuario = loginController.usuarioActual.value;


        if (usuario == null) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2F496E)),
            ),
          );
        }


        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Card de Bienvenida
              Card(
                elevation: 0,
                color: const Color(0xFFEDDBCE).withOpacity(0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Color(0xFFEDDBCE), width: 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 60,
                            height: 60,
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
                              size: 32,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '¡Bienvenido, ${usuario.nombre}!',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2F496E),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.email_outlined,
                                      size: 16,
                                      color: Color(0xFF5A6F8F),
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        usuario.email,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Color(0xFF5A6F8F),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                if (usuario.rolNombre != null) ...[
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.badge_outlined,
                                        size: 16,
                                        color: Color(0xFF5A6F8F),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        usuario.rolNombre!,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Color(0xFF5A6F8F),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Icon(
                            Icons.access_time,
                            size: 16,
                            color: Color(0xFF5A6F8F),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _getFormattedDateTime(),
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF5A6F8F),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),


              // Accesos Rápidos
              const Text(
                'Accesos Rápidos',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2F496E),
                ),
              ),
              const SizedBox(height: 12),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.15,
                children: [
                  _buildQuickAccessCard(
                    icon: Icons.app_registration,
                    title: 'Prematrícula',
                    color: const Color(0xFF7BA892),
                    onTap: () => Get.toNamed('/prematricula'),
                  ),
                  _buildQuickAccessCard(
                    icon: Icons.how_to_reg,
                    title: 'Matrícula',
                    color: const Color(0xFFD4A574),
                    onTap: () => Get.toNamed('/matricula'),
                  ),
                  _buildQuickAccessCard(
                    icon: Icons.book,
                    title: 'Mis Cursos',
                    color: const Color(0xFF5B8FA3),
                    onTap: () => Get.toNamed('/mis-cursos'),
                  ),
                  _buildQuickAccessCard(
                    icon: Icons.payment,
                    title: 'Pagos',
                    color: const Color(0xFFC3A38E),
                    onTap: () => Get.toNamed('/pagos'),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }


  Widget _buildQuickAccessCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2F496E),
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }


  String _getFormattedDateTime() {
    final now = DateTime.now().toUtc().subtract(const Duration(hours: 6));
    return '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }
}
