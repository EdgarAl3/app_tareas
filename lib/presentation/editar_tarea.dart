import 'package:flutter/material.dart';
import 'package:app_tareas/models/tarea.dart';
import 'package:provider/provider.dart';
import 'package:app_tareas/provider/tareas_provider.dart';

/// Pantalla para editar una tarea existente
/// Recibe la tarea seleccionada desde la pantalla anterior
class EditarTarea extends StatefulWidget {
  final Tarea tarea;

  const EditarTarea({super.key, required this.tarea});

  @override
  State<EditarTarea> createState() => _EditarTareaState();
}

class _EditarTareaState extends State<EditarTarea> {
  // Controladores para cargar y modificar los valores de la tarea
  late TextEditingController tituloCtrl;
  late TextEditingController categoriaCtrl;
  late TextEditingController fechaCtrl;
  bool urgente = false;

  @override
  void initState() {
    super.initState();
    // Se inicializan los campos con los datos actuales de la tarea
    tituloCtrl = TextEditingController(text: widget.tarea.titulo);
    categoriaCtrl = TextEditingController(text: widget.tarea.categoria);
    fechaCtrl = TextEditingController(
      text: widget.tarea.fecha.toIso8601String().substring(0, 10),
    );
    urgente = widget.tarea.urgente;
  }

  @override
  void dispose() {
    // Se liberan los controladores cuando el widget se destruye
    tituloCtrl.dispose();
    categoriaCtrl.dispose();
    fechaCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Obtenemos el provider de tareas para guardar los cambios
    final tareasProvider = Provider.of<TareasProvider>(context, listen: false);

    return Scaffold(
      // Barra superior con el título de la pantalla
      appBar: AppBar(title: Text("Editar tarea")),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Campo para editar el título
            TextField(
              controller: tituloCtrl,
              decoration: InputDecoration(labelText: "Título"),
            ),

            // Campo para editar la categoría
            TextField(
              controller: categoriaCtrl,
              decoration: InputDecoration(labelText: "Categoría"),
            ),

            // Campo de fecha para editar la fecha de la tarea
            // Es de solo lectura para obligar a usar el selector de fecha
            TextField(
              controller: fechaCtrl,
              readOnly: true,
              decoration: InputDecoration(labelText: "Fecha"),
              onTap: () async {
                // Se abre el selector de fecha con la fecha actual de la tarea como predeterminada
                DateTime? seleccionada = await showDatePicker(
                  context: context,
                  initialDate: widget.tarea.fecha,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );

                // Si se elige una fecha el campo se actualiza
                if (seleccionada != null) {
                  setState(() {
                    fechaCtrl.text = seleccionada.toIso8601String().substring(
                      0,
                      10,
                    );
                  });
                }
              },
            ),

            // Interruptor para marcar si la tarea es urgente
            SwitchListTile(
              title: Text("¿Urgente?"),
              value: urgente,
              onChanged: (v) => setState(() => urgente = v),
            ),

            const SizedBox(height: 15),

            // Botón que guarda los cambios realizados en la tarea
            ElevatedButton(
              child: Text("Guardar cambios"),
              onPressed: () async {
                // Validamos que el título no esté vacío
                if (tituloCtrl.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('El título es requerido')),
                  );
                  return;
                }

                try {
                  // Guardamos los cambios en la base de datos usando el provider
                  await tareasProvider.editarTarea(
                    widget.tarea.id,
                    tituloCtrl.text,
                    categoriaCtrl.text.isEmpty ? "General" : categoriaCtrl.text,
                    DateTime.parse(fechaCtrl.text),
                    widget
                        .tarea
                        .completada, // Mantenemos el estado de completada
                    urgente,
                  );

                  // Regresamos un valor verdadero para indicar que se hicieron cambios
                  Navigator.pop(context, true);
                } catch (e) {
                  // Mostramos un mensaje de error si falla la actualización
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error al guardar los cambios: $e')),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
