import 'package:flutter/material.dart';
import 'package:app_tareas/database/db_helper.dart';
import 'package:app_tareas/models/tarea.dart';
import 'package:app_tareas/models/usuario.dart';

/// Provider que gestiona el estado de la aplicación, incluyendo usuarios, tareas y autenticación
class TareasProvider extends ChangeNotifier {
  // Estructuras de datos para almacenar usuarios y tareas
  List<Map<String, dynamic>> _usuarios = [];
  List<Tarea> _tareas = [];
  Usuario? _usuarioActual;
  String _filtroActual = "Todos";

  // Getters para acceder a los datos desde fuera de la clase
  List<Map<String, dynamic>> get usuarios => _usuarios;
  List<Tarea> get tareas => _tareas;
  Usuario? get usuarioActual => _usuarioActual;
  String get filtroActual => _filtroActual;

  /// Retorna las tareas filtradas según el filtro actual aplicado
  List<Tarea> get tareasFiltradas {
    switch (_filtroActual) {
      case "Completados":
        return _tareas.where((t) => t.completada).toList();
      case "Sin completar":
        return _tareas.where((t) => !t.completada).toList();
      case "Urgentes":
        return _tareas.where((t) => t.urgente).toList();
      default: // "Todos"
        return _tareas;
    }
  }

  /// Constructor que inicializa el provider cargando los datos
  TareasProvider() {
    cargarDatos();
  }

  // ========== MÉTODOS DE CARGA DE DATOS ==========

  /// Carga todos los datos necesarios desde la base de datos
  Future<void> cargarDatos() async {
    _usuarios = await DbHelper.getUsuarios();
    if (_usuarioActual != null) {
      await _cargarTareasUsuario(_usuarioActual!.id);
    }
    notifyListeners();
  }

  /// Carga las tareas específicas de un usuario desde la base de datos
  Future<void> _cargarTareasUsuario(int idUsuario) async {
    final tareasData = await DbHelper.getTareasPorUsuario(idUsuario);
    _tareas = tareasData
        .map(
          (data) => Tarea(
            id: data['id_tarea'].toString(),
            titulo: data['titulo'],
            categoria: data['categoria'],
            fecha: DateTime.parse(data['fecha']),
            completada: data['completada'] == 1,
            urgente: data['urgente'] == 1,
          ),
        )
        .toList();
    notifyListeners();
  }

  // ========== MÉTODOS DE AUTENTICACIÓN ==========

  /// Registra un nuevo usuario en el sistema
  /// Retorna true si el registro fue exitoso, false si el usuario ya existe
  Future<bool> registrarUsuario(
    String nombreCompleto,
    String correoElectronico,
    String contrasenia,
  ) async {
    try {
      // Verificar si el usuario ya existe
      final existe = await DbHelper.existeUsuario(correoElectronico);
      if (existe) {
        return false; // Usuario ya existe
      }

      // Validar longitud de campos según diccionario de datos
      if (nombreCompleto.length > 100) {
        nombreCompleto = nombreCompleto.substring(0, 100);
      }
      if (correoElectronico.length > 150) {
        correoElectronico = correoElectronico.substring(0, 150);
      }
      if (contrasenia.length > 50) {
        contrasenia = contrasenia.substring(0, 50);
      }

      // Insertar nuevo usuario
      await DbHelper.insertarUsuario(
        nombreCompleto,
        correoElectronico,
        contrasenia,
      );
      await cargarDatos();
      return true;
    } catch (e) {
      // ignore: avoid_print
      print("Error al registrar usuario: $e");
      return false;
    }
  }

  /// Inicia sesión con las credenciales proporcionadas
  /// Retorna true si las credenciales son válidas, false en caso contrario
  Future<bool> iniciarSesion(String email, String password) async {
    try {
      final usuarioData = await DbHelper.getUsuarioPorCredenciales(
        email,
        password,
      );
      if (usuarioData != null) {
        _usuarioActual = Usuario(
          id: usuarioData['id_usuario'],
          nombre: usuarioData['nombre_completo'],
          email: usuarioData['correo_electronico'],
          password: usuarioData['contrasenia'],
        );
        await _cargarTareasUsuario(_usuarioActual!.id);
        return true;
      }
      return false;
    } catch (e) {
      // ignore: avoid_print
      print("Error al iniciar sesión: $e");
      return false;
    }
  }

  /// Cierra la sesión del usuario actual y limpia los datos
  void cerrarSesion() {
    _usuarioActual = null;
    _tareas.clear();
    notifyListeners();
  }

  // ========== MÉTODOS PARA TAREAS ==========

  /// Agrega una nueva tarea para el usuario actual
  Future<void> agregarTarea(
    String titulo,
    String categoria,
    DateTime fecha,
    bool urgente,
  ) async {
    if (_usuarioActual == null) return;

    // Validar longitud según diccionario de datos
    if (titulo.length > 100) {
      titulo = titulo.substring(0, 100);
    }
    if (categoria.length > 100) {
      categoria = categoria.substring(0, 100);
    }

    await DbHelper.insertarTarea(
      titulo,
      categoria,
      fecha.toIso8601String(),
      urgente ? 1 : 0,
      _usuarioActual!.id,
    );
    await _cargarTareasUsuario(_usuarioActual!.id);
  }

  /// Edita una tarea existente con los nuevos datos proporcionados
  Future<void> editarTarea(
    String id,
    String titulo,
    String categoria,
    DateTime fecha,
    bool completada,
    bool urgente,
  ) async {
    try {
      // Validar longitud según diccionario de datos
      if (titulo.length > 100) {
        titulo = titulo.substring(0, 100);
      }
      if (categoria.length > 100) {
        categoria = categoria.substring(0, 100);
      }

      await DbHelper.actualizarTarea(
        int.parse(id),
        titulo,
        categoria,
        fecha.toIso8601String(),
        completada ? 1 : 0,
        urgente ? 1 : 0,
      );

      // Forzar la recarga de datos después de editar
      if (_usuarioActual != null) {
        await _cargarTareasUsuario(_usuarioActual!.id);
      }
      notifyListeners();
    } catch (e) {
      // ignore: avoid_print
      print("Error al editar tarea: $e");
      // ignore: use_rethrow_when_possible
      throw e;
    }
  }

  /// Marca una tarea como completada o no completada
  Future<void> marcarTareaCompletada(String id, bool completada) async {
    await DbHelper.marcarTareaCompletada(int.parse(id), completada ? 1 : 0);
    if (_usuarioActual != null) {
      await _cargarTareasUsuario(_usuarioActual!.id);
    }
  }

  /// Elimina una tarea específica
  Future<void> eliminarTarea(String id) async {
    await DbHelper.eliminarTarea(int.parse(id));
    if (_usuarioActual != null) {
      await _cargarTareasUsuario(_usuarioActual!.id);
    }
  }

  /// Elimina todas las tareas completadas del usuario actual
  Future<void> eliminarTareasCompletadas() async {
    if (_usuarioActual == null) return;

    await DbHelper.eliminarTareasCompletadas(_usuarioActual!.id);
    await _cargarTareasUsuario(_usuarioActual!.id);
  }

  // ========== MÉTODOS DE FILTRADO ==========

  /// Cambia el filtro actual para las tareas
  void cambiarFiltro(String nuevoFiltro) {
    _filtroActual = nuevoFiltro;
    notifyListeners();
  }

  // ========== MÉTODOS PARA USUARIOS ==========

  /// Actualiza la información de un usuario existente
  Future<void> actualizarUsuario(
    int id,
    String nombreCompleto,
    String correoElectronico,
  ) async {
    // Validar longitud según diccionario de datos
    if (nombreCompleto.length > 100) {
      nombreCompleto = nombreCompleto.substring(0, 100);
    }
    if (correoElectronico.length > 150) {
      correoElectronico = correoElectronico.substring(0, 150);
    }

    await DbHelper.actualizarUsuario(id, nombreCompleto, correoElectronico);
    await cargarDatos();
  }

  /// Elimina un usuario del sistema
  Future<void> eliminarUsuario(int id) async {
    await DbHelper.eliminarUsuario(id);
    await cargarDatos();
    if (_usuarioActual?.id == id) {
      cerrarSesion();
    }
  }

  /// Obtiene una tarea específica por su ID
  Tarea? obtenerTareaPorId(String id) {
    try {
      return _tareas.firstWhere((tarea) => tarea.id == id);
    } catch (e) {
      return null;
    }
  }
}
