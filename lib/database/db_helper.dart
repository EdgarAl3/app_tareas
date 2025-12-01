// ignore_for_file: depend_on_referenced_packages
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/// Clase helper para gestionar la base de datos SQLite de la aplicación
/// Proporciona métodos para realizar operaciones CRUD sobre usuarios y tareas
class DbHelper {
  // Instancia singleton de la base de datos
  static Database? _db;
  // Nombre del archivo de la base de datos
  static final String _dbName = "app_tareas.db";

  /// Obtiene la instancia de la base de datos, creándola si no existe
  /// Retorna la instancia de Database lista para usar
  static Future<Database> getDB() async {
    // Si la base de datos ya está inicializada, la retornamos directamente
    if (_db != null) return _db!;
    // Si no existe, la inicializamos
    _db = await _initDB();
    return _db!;
  }

  /// Inicializa la base de datos creando el archivo y las tablas necesarias
  /// Retorna una instancia de Database configurada
  static Future<Database> _initDB() async {
    // Obtenemos la ruta donde se almacenarán las bases de datos en el dispositivo
    final dbPath = await getDatabasesPath();
    // Combinamos la ruta con el nombre del archivo de la base de datos
    final path = join(dbPath, _dbName);

    // Abrimos o creamos la base de datos con la versión especificada
    return await openDatabase(path, version: 1, onCreate: _onCreateDB);
  }

  /// Crea las tablas necesarias en la base de datos cuando se inicializa por primera vez
  /// [db]: Instancia de la base de datos donde se crearán las tablas
  /// [version]: Número de versión de la base de datos
  static Future<void> _onCreateDB(Database db, int version) async {
    // Creamos la tabla de usuarios con sus campos según el diccionario de datos
    await db.execute('''
    CREATE TABLE Usuario(
      id_usuario INTEGER PRIMARY KEY AUTOINCREMENT,
      nombre_completo VARCHAR(100) NOT NULL,
      correo_electronico VARCHAR(150) NOT NULL UNIQUE,
      contrasenia VARCHAR(50) NOT NULL
    )
    ''');

    // Creamos la tabla de tareas con sus campos y la relación con la tabla de usuarios
    await db.execute('''
    CREATE TABLE Tarea(
      id_tarea INTEGER PRIMARY KEY AUTOINCREMENT,
      titulo VARCHAR(100) NOT NULL,
      categoria VARCHAR(100) NOT NULL,
      fecha DATETIME NOT NULL,
      completada INTEGER DEFAULT 0,
      urgente INTEGER DEFAULT 0,
      id_cliente INTEGER NOT NULL,
      FOREIGN KEY(id_cliente) REFERENCES Usuario(id_usuario) ON DELETE CASCADE
    )
    ''');
  }

  // ========== MÉTODOS PARA USUARIOS ==========

  /// Inserta un nuevo usuario en la base de datos
  /// [nombreCompleto]: Nombre completo del usuario
  /// [correoElectronico]: Correo electrónico único del usuario
  /// [contrasenia]: Contraseña del usuario
  /// Retorna el ID del usuario insertado
  static Future<int> insertarUsuario(
    String nombreCompleto,
    String correoElectronico,
    String contrasenia,
  ) async {
    final db = await getDB();
    return await db.insert("Usuario", {
      "nombre_completo": nombreCompleto,
      "correo_electronico": correoElectronico,
      "contrasenia": contrasenia,
    });
  }

  /// Obtiene todos los usuarios registrados en la base de datos
  /// Retorna una lista de mapas con la información de cada usuario
  static Future<List<Map<String, dynamic>>> getUsuarios() async {
    final db = await getDB();
    return db.query("Usuario");
  }

  /// Busca un usuario por sus credenciales de email y contraseña
  /// [email]: Correo electrónico del usuario
  /// [password]: Contraseña del usuario
  /// Retorna los datos del usuario si las credenciales son correctas, o null si no existe
  static Future<Map<String, dynamic>?> getUsuarioPorCredenciales(
    String email,
    String password,
  ) async {
    final db = await getDB();
    final result = await db.query(
      "Usuario",
      where: "correo_electronico = ? AND contrasenia = ?",
      whereArgs: [email, password],
    );
    return result.isNotEmpty ? result.first : null;
  }

  /// Verifica si ya existe un usuario registrado con el email proporcionado
  /// [email]: Correo electrónico a verificar
  /// Retorna true si el usuario existe, false en caso contrario
  static Future<bool> existeUsuario(String email) async {
    final db = await getDB();
    final result = await db.query(
      "Usuario",
      where: "correo_electronico = ?",
      whereArgs: [email],
    );
    return result.isNotEmpty;
  }

  /// Actualiza la información de un usuario existente
  /// [id]: ID del usuario a actualizar
  /// [nombreCompleto]: Nuevo nombre completo del usuario
  /// [correoElectronico]: Nuevo correo electrónico del usuario
  static Future<void> actualizarUsuario(
    int id,
    String nombreCompleto,
    String correoElectronico,
  ) async {
    final db = await getDB();
    await db.update(
      "Usuario",
      {
        "nombre_completo": nombreCompleto,
        "correo_electronico": correoElectronico,
      },
      where: "id_usuario = ?",
      whereArgs: [id],
    );
  }

  /// Elimina un usuario de la base de datos
  /// [id]: ID del usuario a eliminar
  static Future<void> eliminarUsuario(int id) async {
    final db = await getDB();
    await db.delete("Usuario", where: "id_usuario = ?", whereArgs: [id]);
  }

  // ========== MÉTODOS PARA TAREAS ==========

  /// Inserta una nueva tarea en la base de datos
  /// [titulo]: Título de la tarea
  /// [categoria]: Categoría de la tarea
  /// [fecha]: Fecha de la tarea en formato String
  /// [urgente]: Indicador si la tarea es urgente (1) o no (0)
  /// [idCliente]: ID del usuario al que pertenece la tarea
  /// Retorna el ID de la tarea insertada
  static Future<int> insertarTarea(
    String titulo,
    String categoria,
    String fecha,
    int urgente,
    int idCliente,
  ) async {
    final db = await getDB();
    return await db.insert("Tarea", {
      "titulo": titulo,
      "categoria": categoria,
      "fecha": fecha,
      "urgente": urgente,
      "id_cliente": idCliente,
    });
  }

  /// Obtiene todas las tareas de un usuario específico
  /// [idCliente]: ID del usuario cuyas tareas se quieren obtener
  /// Retorna una lista de tareas ordenadas por fecha descendente
  static Future<List<Map<String, dynamic>>> getTareasPorUsuario(
    int idCliente,
  ) async {
    final db = await getDB();
    return db.query(
      "Tarea",
      where: "id_cliente = ?",
      whereArgs: [idCliente],
      orderBy: "fecha DESC",
    );
  }

  /// Obtiene las tareas de un usuario filtradas por estado
  /// [idCliente]: ID del usuario cuyas tareas se quieren obtener
  /// [filtro]: Tipo de filtro a aplicar ("Completados", "Sin completar", "Urgentes", "Todos")
  /// Retorna una lista de tareas filtradas y ordenadas por fecha descendente
  static Future<List<Map<String, dynamic>>> getTareasFiltradas(
    int idCliente,
    String filtro,
  ) async {
    final db = await getDB();

    switch (filtro) {
      case "Completados":
        return db.query(
          "Tarea",
          where: "id_cliente = ? AND completada = 1",
          whereArgs: [idCliente],
          orderBy: "fecha DESC",
        );
      case "Sin completar":
        return db.query(
          "Tarea",
          where: "id_cliente = ? AND completada = 0",
          whereArgs: [idCliente],
          orderBy: "fecha DESC",
        );
      case "Urgentes":
        return db.query(
          "Tarea",
          where: "id_cliente = ? AND urgente = 1",
          whereArgs: [idCliente],
          orderBy: "fecha DESC",
        );
      default: // "Todos"
        return getTareasPorUsuario(idCliente);
    }
  }

  /// Actualiza la información de una tarea existente
  /// [id]: ID de la tarea a actualizar
  /// [titulo]: Nuevo título de la tarea
  /// [categoria]: Nueva categoría de la tarea
  /// [fecha]: Nueva fecha de la tarea
  /// [completada]: Estado de completado (1) o no completado (0)
  /// [urgente]: Indicador si la tarea es urgente (1) o no (0)
  static Future<void> actualizarTarea(
    int id,
    String titulo,
    String categoria,
    String fecha,
    int completada,
    int urgente,
  ) async {
    final db = await getDB();
    await db.update(
      "Tarea",
      {
        "titulo": titulo,
        "categoria": categoria,
        "fecha": fecha,
        "completada": completada,
        "urgente": urgente,
      },
      where: "id_tarea = ?",
      whereArgs: [id],
    );
  }

  /// Marca una tarea como completada o no completada
  /// [id]: ID de la tarea a actualizar
  /// [completada]: Estado a establecer (1 para completada, 0 para no completada)
  static Future<void> marcarTareaCompletada(int id, int completada) async {
    final db = await getDB();
    await db.update(
      "Tarea",
      {"completada": completada},
      where: "id_tarea = ?",
      whereArgs: [id],
    );
  }

  /// Elimina una tarea específica de la base de datos
  /// [id]: ID de la tarea a eliminar
  static Future<void> eliminarTarea(int id) async {
    final db = await getDB();
    await db.delete("Tarea", where: "id_tarea = ?", whereArgs: [id]);
  }

  /// Elimina todas las tareas completadas de un usuario
  /// [idCliente]: ID del usuario cuyas tareas completadas se eliminarán
  static Future<void> eliminarTareasCompletadas(int idCliente) async {
    final db = await getDB();
    await db.delete(
      "Tarea",
      where: "id_cliente = ? AND completada = 1",
      whereArgs: [idCliente],
    );
  }

  /// Obtiene todas las tareas con información adicional del usuario
  /// Realiza un JOIN entre las tablas Tarea y Usuario
  /// Retorna una lista con la información combinada de tareas y usuarios
  static Future<List<Map<String, dynamic>>> getTareasConUsuario() async {
    final db = await getDB();
    return db.rawQuery('''
    SELECT 
      t.id_tarea,
      t.titulo,
      t.categoria,
      t.fecha,
      t.completada,
      t.urgente,
      t.id_cliente,
      u.nombre_completo,
      u.correo_electronico
    FROM Tarea t
    INNER JOIN Usuario u ON t.id_cliente = u.id_usuario
    ORDER BY t.fecha DESC
    ''');
  }
}
