import 'package:app_tareas/config/theme/app_theme.dart';
import 'package:app_tareas/presentation/pantalla_acceso.dart';
import 'package:app_tareas/provider/tareas_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Función principal que inicia la aplicación Flutter
/// Esta función es el punto de entrada de la aplicación y ejecuta el widget MyApp
void main() {
  runApp(const MyApp());
}

/// Widget principal que configura la aplicación completa
/// Este widget es la raíz de la aplicación y establece la estructura base
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  /// Método build que construye la interfaz de la aplicación
  /// Retorna un MaterialApp que configura el tema y la pantalla inicial
  @override
  Widget build(BuildContext context) {
    // Utilizamos ChangeNotifierProvider para proveer el estado de la aplicación
    // a todos los widgets hijos que lo necesiten
    return ChangeNotifierProvider(
      // Creamos una instancia de TareasProvider que gestionará el estado global
      create: (context) => TareasProvider(),
      // Widget MaterialApp que define la estructura base de la aplicación
      child: MaterialApp(
        // Título de la aplicación que se muestra en el switcher de aplicaciones
        title: 'Clarity App',
        // Oculta la etiqueta de debug en la esquina superior derecha
        debugShowCheckedModeBanner: false,
        // Aplica el tema personalizado de la aplicación
        theme: AppTheme(selectedColor: 1).theme(),
        // Define la pantalla inicial que se mostrará al abrir la aplicación
        home: PantallaAcceso(),
      ),
    );
  }
}
