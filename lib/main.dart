import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modulo_mobil/screens/login_screen.dart';
import 'package:modulo_mobil/screens/home_screen.dart';
import 'package:modulo_mobil/screens/prematricula_screen.dart';
import 'package:modulo_mobil/screens/matricula_screen.dart';
import 'package:modulo_mobil/screens/mis_cursos_screen.dart';
import 'package:modulo_mobil/screens/pagos_screen.dart';


void main() {
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
        GetPage(name: '/pagos', page: () => const PagosScreen()),
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
    );
  }
}
