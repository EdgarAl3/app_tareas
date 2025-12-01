import 'package:app_tareas/models/tarea.dart';
import 'package:app_tareas/presentation/agregar_tarea.dart';
import 'package:app_tareas/presentation/editar_tarea.dart';
import 'package:app_tareas/presentation/pantalla_acceso.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_tareas/provider/tareas_provider.dart';

/// Pantalla principal de la aplicación donde se muestran y gestionan las tareas
/// Esta pantalla permite ver, filtrar, editar y eliminar tareas del usuario
class PantallaPrincipal extends StatefulWidget {
  const PantallaPrincipal({super.key});

  @override
  State<PantallaPrincipal> createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal> {
  /// Convierte una fecha DateTime en un formato legible y amigable para el usuario
  /// [fecha]: La fecha que se desea formatear
  /// Retorna un string con la fecha formateada en español
  String formatearFecha(DateTime fecha) {
    const meses = [
      "Enero",
      "Febrero",
      "Marzo",
      "Abril",
      "Mayo",
      "Junio",
      "Julio",
      "Agosto",
      "Septiembre",
      "Octubre",
      "Noviembre",
      "Diciembre",
    ];

    final dia = fecha.day;
    final mes = meses[fecha.month - 1];
    final anio = fecha.year;
    final hora = fecha.hour.toString().padLeft(2, '0');
    final minutos = fecha.minute.toString().padLeft(2, '0');

    return "$dia $mes $anio $hora:$minutos";
  }

  @override
  Widget build(BuildContext context) {
    // Obtenemos el provider de tareas para acceder a los datos y métodos
    final tareasProvider = Provider.of<TareasProvider>(context);
    // Obtenemos las tareas filtradas según el filtro actual
    final tareas = tareasProvider.tareasFiltradas;

    // Estilos de texto reutilizables para mantener consistencia en la UI
    final estiloLetraTextoNormal = const TextStyle(
      color: Color.fromARGB(255, 255, 111, 97),
      fontFamily: 'poppins',
      fontSize: 14,
    );

    final estiloLetraTitulos = const TextStyle(
      color: Color.fromARGB(255, 34, 165, 169),
      fontFamily: 'MomoTrustDisplay',
      fontSize: 25,
      fontWeight: FontWeight.bold,
    );

    final estiloLetraBotones = const TextStyle(
      fontFamily: 'Poppins',
      fontSize: 16,
      fontWeight: FontWeight.bold,
    );

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 245, 245),

      // Barra de aplicación superior
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 245, 245, 245),
        // Botón de logout en la esquina superior izquierda
        leading: IconButton(
          onPressed: () {
            // Mostramos diálogo de confirmación antes de cerrar sesión
            _mostrarDialogoCerrarSesion(context, tareasProvider);
          },
          icon: Icon(Icons.logout, color: Color.fromARGB(255, 255, 111, 97)),
        ),
        // Título centrado de la pantalla
        title: Text('Gestionar tareas', style: estiloLetraTitulos),
        centerTitle: true,
      ),

      // Cuerpo principal de la pantalla
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(30),
          child: Column(
            children: [
              // --- BOTONES DE FILTRO ---
              // Fila con botones para filtrar las tareas por estado
              Row(
                children: [
                  // Botón para mostrar todas las tareas
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: tareasProvider.filtroActual == "Todos"
                            ? const Color.fromARGB(255, 255, 111, 97)
                            : Colors.white,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          side: const BorderSide(
                            color: Color.fromARGB(255, 255, 111, 97),
                            width: 2,
                          ),
                        ),
                      ),
                      onPressed: () => tareasProvider.cambiarFiltro("Todos"),
                      child: Text("Todos", style: estiloLetraBotones),
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Botón para mostrar solo las tareas completadas
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            tareasProvider.filtroActual == "Completados"
                            ? const Color.fromARGB(255, 255, 111, 97)
                            : Colors.white,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          side: const BorderSide(
                            color: Color.fromARGB(255, 255, 111, 97),
                            width: 2,
                          ),
                        ),
                      ),
                      onPressed: () =>
                          tareasProvider.cambiarFiltro("Completados"),
                      child: Text("Completados", style: estiloLetraBotones),
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Botón para mostrar solo las tareas pendientes
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            tareasProvider.filtroActual == "Sin completar"
                            ? const Color.fromARGB(255, 255, 111, 97)
                            : Colors.white,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          side: const BorderSide(
                            color: Color.fromARGB(255, 255, 111, 97),
                            width: 2,
                          ),
                        ),
                      ),
                      onPressed: () =>
                          tareasProvider.cambiarFiltro("Sin completar"),
                      child: Text("Sin completar", style: estiloLetraBotones),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // --- SECCIÓN DE MÁS FILTROS ---
              // Fila decorativa que muestra la opción de más filtros
              Row(
                children: [
                  const Icon(
                    Icons.filter_list_alt,
                    color: Color.fromARGB(255, 255, 111, 97),
                    size: 30,
                  ),
                  const SizedBox(width: 20),
                  Text('Más filtros', style: estiloLetraTextoNormal),
                  const Spacer(),
                  // Icono decorativo (sin funcionalidad implementada)
                  IconButton(
                    color: const Color.fromARGB(255, 255, 111, 97),
                    onPressed: () {},
                    icon: const Icon(Icons.arrow_right_outlined),
                    iconSize: 40,
                  ),
                ],
              ),

              const SizedBox(height: 10),
              // Línea divisoria para separar secciones
              Container(height: 2, color: Colors.black),
              const SizedBox(height: 20),

              // --- LISTA DE TAREAS ---
              // Área expandible que contiene la lista de tareas
              Expanded(
                child: tareas.isEmpty
                    ? Center(
                        child: Text("No hay tareas", style: estiloLetraTitulos),
                      )
                    : ListView.builder(
                        itemCount: tareas.length,
                        itemBuilder: (_, i) {
                          final t = tareas[i];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 15),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE1F7FA),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                // Checkbox para marcar la tarea como completada o pendiente
                                Checkbox(
                                  value: t.completada,
                                  activeColor: const Color.fromARGB(
                                    255,
                                    255,
                                    111,
                                    97,
                                  ),
                                  onChanged: (v) {
                                    tareasProvider.marcarTareaCompletada(
                                      t.id,
                                      v!,
                                    );
                                  },
                                ),
                                const SizedBox(width: 10),

                                // Información de la tarea
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Etiqueta de categoría con color condicional
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 4,
                                          horizontal: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          color: t.urgente
                                              ? const Color.fromARGB(
                                                  255,
                                                  255,
                                                  111,
                                                  97,
                                                )
                                              : const Color.fromARGB(
                                                  255,
                                                  34,
                                                  165,
                                                  169,
                                                ),
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                        child: Text(
                                          t.categoria,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),

                                      // Título de la tarea
                                      Text(
                                        t.titulo,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 4),

                                      // Fecha formateada de la tarea
                                      Text(
                                        formatearFecha(t.fecha),
                                        style: const TextStyle(
                                          color: Colors.black54,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Botones de acción para cada tarea
                                Column(
                                  children: [
                                    // Botón para editar la tarea
                                    IconButton(
                                      icon: Icon(
                                        Icons.edit,
                                        color: Color.fromARGB(
                                          255,
                                          255,
                                          111,
                                          97,
                                        ),
                                      ),
                                      onPressed: () async {
                                        // Navegamos a la pantalla de edición
                                        final editada = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                EditarTarea(tarea: t),
                                          ),
                                        );
                                        // Si se guardaron cambios, recargamos los datos
                                        if (editada == true) {
                                          await tareasProvider.cargarDatos();
                                        }
                                      },
                                    ),
                                    // Botón para eliminar la tarea
                                    IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        color: Color.fromARGB(
                                          255,
                                          255,
                                          111,
                                          97,
                                        ),
                                      ),
                                      onPressed: () {
                                        _mostrarDialogoEliminar(
                                          context,
                                          tareasProvider,
                                          t,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),

      // Barra inferior con botón para agregar nuevas tareas
      bottomNavigationBar: Container(
        height: 70,
        padding: EdgeInsets.symmetric(horizontal: 110, vertical: 15),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 255, 111, 97),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 5,
          ),
          onPressed: () async {
            final tareasProvider = Provider.of<TareasProvider>(
              context,
              listen: false,
            );
            // Navegamos a la pantalla de agregar tarea
            final nueva = await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AgregarTarea()),
            );
            // Si se creó una nueva tarea, la agregamos a la base de datos
            if (nueva != null) {
              await tareasProvider.agregarTarea(
                nueva.titulo,
                nueva.categoria,
                nueva.fecha,
                nueva.urgente,
              );
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_circle_outlined),
              SizedBox(width: 10),
              Text(
                "Agregar Tarea",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Muestra un diálogo de confirmación antes de cerrar sesión
  /// [context]: Contexto de la aplicación
  /// [provider]: Provider de tareas para realizar el cierre de sesión
  void _mostrarDialogoCerrarSesion(
    BuildContext context,
    TareasProvider provider,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Cerrar Sesión"),
          content: Text("¿Estás seguro de que quieres cerrar sesión?"),
          actions: [
            // Botón para cancelar el cierre de sesión
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancelar"),
            ),
            // Botón para confirmar el cierre de sesión
            TextButton(
              onPressed: () async {
                // Cerramos sesión en el provider
                provider.cerrarSesion();
                // Cerramos el diálogo
                Navigator.of(context).pop();
                // Redirigimos a la pantalla de acceso
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => PantallaAcceso()),
                  (route) => false,
                );
              },
              child: Text("Cerrar Sesión", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  /// Muestra un diálogo de confirmación antes de eliminar una tarea
  /// [context]: Contexto de la aplicación
  /// [provider]: Provider de tareas para realizar la eliminación
  /// [tarea]: Tarea que se desea eliminar
  void _mostrarDialogoEliminar(
    BuildContext context,
    TareasProvider provider,
    Tarea tarea,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Eliminar Tarea"),
          content: Text(
            "¿Estás seguro de que quieres eliminar la tarea '${tarea.titulo}'?",
          ),
          actions: [
            // Botón para cancelar la eliminación
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancelar"),
            ),
            // Botón para confirmar la eliminación
            TextButton(
              onPressed: () async {
                await provider.eliminarTarea(tarea.id);
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
              },
              child: Text("Eliminar", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
