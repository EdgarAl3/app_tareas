import 'package:app_tareas/presentation/inicio_sesion.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_tareas/provider/tareas_provider.dart';

class RegistroUsuario extends StatefulWidget {
  const RegistroUsuario({super.key});

  @override
  State<RegistroUsuario> createState() => _RegistroUsuarioState();
}

class _RegistroUsuarioState extends State<RegistroUsuario> {
  bool passwordVisible = false;
  bool passwordVisibleConfirmar = false;
  final _nombreController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    passwordVisible = true;
    passwordVisibleConfirmar = true;
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
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
            Navigator.pop(context);
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text("Registro de usuario", style: estiloLetraTitulos),
              ),
              SizedBox(height: 20),
              Text("Nombre de usuario", style: estiloLetraSubtitulos),
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(
                  labelText: "Ej. Sofia Rivera",
                  border: OutlineInputBorder(),
                  filled: true,
                ),
              ),
              SizedBox(height: 20),
              Text("Correo electronico", style: estiloLetraSubtitulos),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "Ej. ejemplo@gmail.com",
                  border: OutlineInputBorder(),
                  filled: true,
                ),
              ),
              SizedBox(height: 20),
              Text("Contraseña", style: estiloLetraSubtitulos),
              TextField(
                controller: _passwordController,
                obscureText: !passwordVisible,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  hintText: "Password",
                  suffixIcon: IconButton(
                    icon: Icon(
                      passwordVisible ? Icons.visibility : Icons.visibility_off,
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
              ),
              SizedBox(height: 20),
              Text("Confirmar contraseña", style: estiloLetraSubtitulos),
              TextField(
                controller: _confirmPasswordController,
                obscureText: !passwordVisibleConfirmar,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  hintText: "Password",
                  suffixIcon: IconButton(
                    icon: Icon(
                      passwordVisibleConfirmar
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        passwordVisibleConfirmar = !passwordVisibleConfirmar;
                      });
                    },
                  ),
                  filled: true,
                ),
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
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
                    if (_nombreController.text.isEmpty ||
                        _emailController.text.isEmpty ||
                        _passwordController.text.isEmpty ||
                        _confirmPasswordController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Por favor, complete todos los campos'),
                        ),
                      );
                      return;
                    }

                    if (_passwordController.text !=
                        _confirmPasswordController.text) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Las contraseñas no coinciden')),
                      );
                      return;
                    }

                    final success = await tareasProvider.registrarUsuario(
                      _nombreController.text,
                      _emailController.text,
                      _passwordController.text,
                    );

                    if (success) {
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Usuario registrado exitosamente'),
                        ),
                      );
                      Navigator.pushAndRemoveUntil(
                        // ignore: use_build_context_synchronously
                        context,
                        MaterialPageRoute(builder: (context) => InicioSesion()),
                        (route) => false,
                      );
                    } else {
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'El correo electrónico ya está registrado',
                          ),
                        ),
                      );
                    }
                  },
                  child: Text(
                    "Registro de usuario",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => InicioSesion()),
                    );
                  },
                  child: Text(
                    "Ya tengo una cuenta",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.black,
                      decorationThickness: 3,
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
