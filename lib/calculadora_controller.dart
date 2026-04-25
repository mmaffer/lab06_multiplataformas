class CalculadoraController {
  String display = '0';
  String expresion = '';
  double _operando1 = 0;
  String _operador = '';
  bool _nuevoNumero = true;

  String get operadorActivo => _operador;

  void presionarNumero(String numero) {
    if (_nuevoNumero) {
      display = numero;
      _nuevoNumero = false;
    } else {
      display = display == '0' ? numero : display + numero;
    }
  }

  void presionarPunto() {
    if (_nuevoNumero) {
      display = '0.';
      _nuevoNumero = false;
    } else if (!display.contains('.')) {
      display += '.';
    }
  }

  void presionarOperador(String op) {
    _operando1 = double.parse(display);
    _operador = op;
    expresion = '$display $op';
    _nuevoNumero = true;
  }

  void calcularResultado() {
    if (_operador.isEmpty) return;
    final double operando2 = double.parse(display);
    double resultado = 0;
    switch (_operador) {
      case '+':
        resultado = _operando1 + operando2;
        break;
      case '-':
        resultado = _operando1 - operando2;
        break;
      case '×':
        resultado = _operando1 * operando2;
        break;
      case '÷':
        resultado = operando2 != 0 ? _operando1 / operando2 : double.nan;
        break;
    }
    expresion = '$expresion $display =';
    display = resultado.isNaN
        ? 'Error'
        : (resultado % 1 == 0
            ? resultado.toInt().toString()
            : resultado.toString());
    _operador = '';
    _nuevoNumero = true;
  }

  void limpiar() {
    display = '0';
    expresion = '';
    _operando1 = 0;
    _operador = '';
    _nuevoNumero = true;
  }

  void borrarUltimo() {
    if (display.length > 1) {
      display = display.substring(0, display.length - 1);
    } else {
      display = '0';
      _nuevoNumero = true;
    }
  }

  void cambiarSigno() {
    if (display != '0') {
      final val = double.parse(display) * -1;
      display = val % 1 == 0 ? val.toInt().toString() : val.toString();
    }
  }

  void porcentaje() {
    final val = double.parse(display) / 100;
    display = val % 1 == 0 ? val.toInt().toString() : val.toString();
  }
}
