// Clase para representar los objetos de tareas y almacenarlos en una lista
class Tarea {
  final String id;
  String titulo;
  String categoria;
  DateTime fecha;
  bool completada;
  bool urgente;

  Tarea({
    required this.id,
    required this.titulo,
    required this.categoria,
    required this.fecha,
    this.completada = false,
    this.urgente = false,
  });
}
