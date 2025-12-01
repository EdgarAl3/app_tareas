// Clase para recibir y manejar los datos de los usuarios
// Actualmente no se implementa completamente ya que se está integrando con la base de datos
class Usuario {
  final int id;
  final String nombre;
  final String email;
  final String password;

  Usuario({
    required this.id,
    required this.nombre,
    required this.email,
    required this.password,
  });
}
