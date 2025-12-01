import 'package:flutter/material.dart';

//un color personalizado que se puede tener para el tema
const Color _customColor = Color.fromARGB(255, 136, 25, 169);
//lista de colores de los temas que se puede tener para el tema
const List<Color> _colorThemes = [
  _customColor,
  Colors.blue,
  Colors.teal,
  Colors.green,
  Colors.yellow,
  Colors.orange,
  Colors.pink,
];

//Se crea la clase para pasar un color al theme del main
class AppTheme {
  final int selectedColor;
  //Un mensaje de error que dice que el color  selecionado tiene que estar entre 0 y 6
  AppTheme({this.selectedColor = 0})
    : assert(
        selectedColor >= 0 && selectedColor <= _colorThemes.length - 1,
        'Colors must be between 0 and ${_colorThemes.length}',
      );
  //Se aplica el tema seleccionado
  ThemeData theme() {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: _colorThemes[selectedColor],
      brightness: Brightness.light,
    );
  }
}
