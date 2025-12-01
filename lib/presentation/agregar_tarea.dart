import 'package:flutter/material.dart';
import 'package:app_tareas/models/tarea.dart';

class AgregarTarea extends StatefulWidget {
  const AgregarTarea({super.key});

  @override
  State<AgregarTarea> createState() => _AgregarTareaState();
}

class _AgregarTareaState extends State<AgregarTarea> {
  final tituloCtrl = TextEditingController();
  final categoriaCtrl = TextEditingController();
  late TextEditingController fechaCtrl;
  bool urgente = false;

  @override
  void initState() {
    super.initState();
    fechaCtrl = TextEditingController(
      text: DateTime.now().toIso8601String().substring(0, 10),
    );
  }

  @override
  void dispose() {
    tituloCtrl.dispose();
    categoriaCtrl.dispose();
    fechaCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Agregar tarea")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: tituloCtrl,
              decoration: InputDecoration(labelText: "Título"),
            ),
            TextField(
              controller: categoriaCtrl,
              decoration: InputDecoration(labelText: "Categoría"),
            ),
            TextField(
              controller: fechaCtrl,
              readOnly: true,
              decoration: InputDecoration(labelText: "Fecha"),
              onTap: () async {
                DateTime? seleccionada = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
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
            SwitchListTile(
              title: Text("¿Urgente?"),
              value: urgente,
              onChanged: (v) => setState(() => urgente = v),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              child: Text("Guardar"),
              onPressed: () {
                if (tituloCtrl.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('El título es requerido')),
                  );
                  return;
                }

                final nueva = Tarea(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  titulo: tituloCtrl.text,
                  categoria: categoriaCtrl.text.isEmpty
                      ? "General"
                      : categoriaCtrl.text,
                  fecha: DateTime.parse(fechaCtrl.text),
                  urgente: urgente,
                );

                Navigator.pop(context, nueva);
              },
            ),
          ],
        ),
      ),
    );
  }
}
