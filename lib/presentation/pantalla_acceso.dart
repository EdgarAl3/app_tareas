import 'package:app_tareas/presentation/inicio_sesion.dart';
import 'package:app_tareas/presentation/registro_usuario.dart';
import 'package:flutter/material.dart';

// Pantalla principal de acceso a la aplicación
// Muestra botones para registro e inicio de sesión
class PantallaAcceso extends StatelessWidget {
  const PantallaAcceso({super.key});

  @override
  Widget build(BuildContext context) {
    // Decoración del contenedor que muestra la imagen
    final boxDecoration = BoxDecoration(
      color: const Color.fromARGB(255, 245, 245, 245),
      borderRadius: BorderRadius.circular(20),
    );

    // Estilo para texto descriptivo
    final estiloLetraTextoNormal = TextStyle(
      fontFamily: 'poppins',
      fontSize: 14,
    );

    // Estilo para títulos principales
    final estiloLetraTitulos = TextStyle(
      color: Color.fromARGB(255, 34, 165, 169),
      fontFamily: 'MomoTrustDisplay',
      fontSize: 35.0,
      fontWeight: FontWeight.bold,
    );

    // Estilo para texto de botones
    final estiloLetraBotones = TextStyle(
      fontFamily: 'Poppins',
      fontSize: 16,
      fontWeight: FontWeight.bold,
    );

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 245, 245, 245),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(60),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Título principal de la pantalla
              Text("Clarity", style: estiloLetraTitulos),

              // Contenedor con la imagen del logo
              Container(
                width: 325,
                height: 300,
                decoration: boxDecoration,
                child: Image.asset(
                  "assets/imagenes/logo.jpeg",
                  fit: BoxFit.contain,
                ),
              ),

              // Texto introductorio de la aplicación
              Container(
                padding: EdgeInsets.symmetric(horizontal: 50),
                child: Text(
                  "Organiza tu vida, programa tus tareas y no olvides tus fechas importantes",
                  textAlign: TextAlign.center,
                  style: estiloLetraTextoNormal,
                ),
              ),

              const SizedBox(height: 20),

              // Texto de instrucciones para el usuario
              Container(
                padding: EdgeInsets.symmetric(horizontal: 50),
                child: Text(
                  "Para comenzar puedes registrar tu usuario o iniciar sesión si ya tienes una cuenta",
                  textAlign: TextAlign.center,
                  style: estiloLetraTextoNormal,
                ),
              ),

              const SizedBox(height: 40),

              // Botón para ir al registro de usuario
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 255, 111, 97),
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 3,
                  ),
                  onPressed: () {
                    // Navega a la pantalla de registro
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegistroUsuario(),
                      ),
                    );
                  },
                  child: Text("Registro de usuario", style: estiloLetraBotones),
                ),
              ),

              const SizedBox(height: 20),

              // Botón para ir al inicio de sesión
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 245, 245, 245),
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: BorderSide(
                        color: Color.fromARGB(255, 255, 111, 97),
                        width: 2,
                      ),
                    ),
                    elevation: 3,
                  ),
                  onPressed: () {
                    // Navega a la pantalla de inicio de sesión
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => InicioSesion()),
                    );
                  },
                  child: Text("Iniciar sesión", style: estiloLetraBotones),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
