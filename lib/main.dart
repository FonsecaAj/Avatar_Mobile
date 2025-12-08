import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modulo_mobil/controllers/LoginController.dart';
import 'package:modulo_mobil/screens/login_screen.dart';
import 'package:modulo_mobil/screens/home_screen.dart';
import 'package:modulo_mobil/screens/prematricula_screen.dart';
import 'package:modulo_mobil/screens/matricula_screen.dart';
import 'package:modulo_mobil/screens/mis_cursos_screen.dart';
import 'package:modulo_mobil/screens/pagos_screen.dart';
import 'package:modulo_mobil/screens/pagos_menu_screen.dart';
import 'package:modulo_mobil/screens/facturas_screen.dart';


void main() {
  // Registrar LoginController de forma global y permanente
  Get.put(LoginController(), permanent: true);
  
  runApp(const MainApp());
}


class MainApp extends StatelessWidget {
  const MainApp({super.key});


  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Login USR5',
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
     getPages: [
        GetPage(name: '/login', page: () => const LoginScreen()),
        GetPage(name: '/home', page: () => const HomeScreen()),
        GetPage(name: '/prematricula', page: () => const PrematriculaScreen()),
        GetPage(name: '/matricula', page: () => const MatriculaScreen()),
        GetPage(name: '/mis-cursos', page: () => const MisCursosScreen()),

        // Nuevo menú de pagos
        GetPage(name: '/pagos', page: () => const PagosMenuScreen()),

        // Facturas
        GetPage(name: '/facturas', page: () => const FacturasScreen()),

        // Pagos realizados (placeholder)
        GetPage(name: '/pagos-realizados', page: () => const PagosScreen()),
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
    );
  }
}
