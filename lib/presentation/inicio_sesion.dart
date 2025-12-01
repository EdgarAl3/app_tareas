import 'package:app_tareas/presentation/pantalla_acceso.dart';
import 'package:app_tareas/presentation/pantalla_principal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_tareas/provider/tareas_provider.dart';

class InicioSesion extends StatefulWidget {
  const InicioSesion({super.key});

  @override
  State<InicioSesion> createState() => _InicioSesionState();
}

class _InicioSesionState extends State<InicioSesion> {
  bool passwordVisible = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    passwordVisible = true;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Valida que el email tenga un formato correcto
  /// [email]: El email a validar
  /// Retorna un mensaje de error si el formato es incorrecto, o null si es válido
  String? _validarEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Por favor, ingresa tu correo electrónico';
    }

    // Expresión regular para validar formato de email
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(email)) {
      return 'Por favor, ingresa un correo electrónico válido\nEjemplo: usuario@gmail.com';
    }

    return null;
  }

  /// Valida que la contraseña no esté vacía
  /// [password]: La contraseña a validar
  /// Retorna un mensaje de error si está vacía, o null si es válida
  String? _validarPassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Por favor, ingresa tu contraseña';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final tareasProvider = Provider.of<TareasProvider>(context);

    final estiloLetraTitulos = TextStyle(
      color: Color.fromARGB(255, 34, 165, 169),
      fontFamily: 'MomoTrustDisplay',
      fontSize: 28.0,
      fontWeight: FontWeight.bold,
    );

    final estiloLetraSubtitulos = TextStyle(
      color: Color.fromARGB(255, 34, 165, 169),
      fontFamily: 'Poppins',
      fontSize: 16,
      fontWeight: FontWeight.bold,
    );

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 245, 245, 245),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 245, 245, 245),
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PantallaAcceso()),
            );
          },
          icon: Icon(
            Icons.keyboard_return_outlined,
            color: Color.fromARGB(255, 255, 111, 97),
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(40),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text("Inicio de sesión", style: estiloLetraTitulos),
                ),
                SizedBox(height: 20),
                Text("Correo electronico", style: estiloLetraSubtitulos),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: "Ej. ejemplo@gmail.com",
                    border: OutlineInputBorder(),
                    filled: true,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: _validarEmail,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                SizedBox(height: 20),
                Text("Contraseña", style: estiloLetraSubtitulos),
                TextFormField(
                  controller: _passwordController,
                  obscureText: !passwordVisible,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    hintText: "Password",
                    suffixIcon: IconButton(
                      icon: Icon(
                        passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          passwordVisible = !passwordVisible;
                        });
                      },
                    ),
                    filled: true,
                  ),
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.done,
                  validator: _validarPassword,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                SizedBox(height: 40),
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
                    onPressed: () async {
                      // Validamos el formulario antes de proceder
                      if (_formKey.currentState!.validate()) {
                        final success = await tareasProvider.iniciarSesion(
                          _emailController.text.trim(),
                          _passwordController.text,
                        );

                        if (success) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PantallaPrincipal(),
                            ),
                            (route) => false,
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Credenciales incorrectas. Verifica tu email y contraseña',
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
                    child: Text(
                      "Iniciar sesión",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
