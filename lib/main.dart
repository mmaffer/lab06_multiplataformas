import 'dart:ui';
import 'package:flutter/material.dart';
import 'calculadora_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora',
      debugShowCheckedModeBanner: false,
      home: const CalculadoraScreen(),
    );
  }
}

class CalculadoraScreen extends StatefulWidget {
  const CalculadoraScreen({super.key});

  @override
  State<CalculadoraScreen> createState() => _CalculadoraScreenState();
}

class _CalculadoraScreenState extends State<CalculadoraScreen> {
  final CalculadoraController _ctrl = CalculadoraController();

  static const Color _bgTop = Color(0xFF0D0D1A);
  static const Color _bgBottom = Color(0xFF1A0D2E);
  static const Color _btnNumero = Color(0xFF1E1B3A);
  static const Color _btnFuncion = Color(0xFF2D2B55);
  static const Color _opColor1 = Color(0xFF7B2FBE);
  static const Color _opColor2 = Color(0xFF9D4EDD);
  static const Color _opActivo = Color(0xFFC77DFF);
  static const Color _textGris = Color(0xFF8888AA);

  void _actualizar(VoidCallback accion) {
    setState(() => accion());
  }

  Widget _botonNumero(String texto, VoidCallback accion) {
    return _BotonCalc(
      texto: texto,
      accion: accion,
      fondo: _btnNumero,
      colorTexto: Colors.white,
    );
  }

  Widget _botonFuncion(String texto, VoidCallback accion) {
    return _BotonCalc(
      texto: texto,
      accion: accion,
      fondo: _btnFuncion,
      colorTexto: _opActivo,
    );
  }

  Widget _botonOperador(String texto, VoidCallback accion) {
    final bool activo = _ctrl.operadorActivo == texto;
    return _BotonCalc(
      texto: texto,
      accion: accion,
      gradiente: activo
          ? const LinearGradient(colors: [Colors.white, Color(0xFFE0C3FC)])
          : const LinearGradient(colors: [_opColor1, _opColor2]),
      colorTexto: activo ? _opColor1 : Colors.white,
      sombra: activo ? _opActivo.withValues(alpha: 0.6) : _opColor1.withValues(alpha: 0.4),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [_bgTop, _bgBottom, Color(0xFF0F1923)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 12),
              const Text(
                'Calculadora',
                style: TextStyle(
                  color: _textGris,
                  fontSize: 16,
                  letterSpacing: 2,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Expanded(child: _pantallaDisplay()),
              _teclado(),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pantallaDisplay() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: _opColor1.withValues(alpha: 0.35),
              blurRadius: 40,
              spreadRadius: -4,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: _opColor2.withValues(alpha: 0.15),
              blurRadius: 80,
              spreadRadius: 0,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF2A1F4E).withValues(alpha: 0.85),
                    const Color(0xFF0D0D1A).withValues(alpha: 0.90),
                  ],
                ),
                border: Border.all(
                  color: _opColor2.withValues(alpha: 0.30),
                  width: 1.2,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Línea decorativa superior con gradiente
                  Container(
                    height: 3,
                    margin: const EdgeInsets.symmetric(horizontal: 40),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      gradient: const LinearGradient(
                        colors: [_opColor1, _opActivo, _opColor2],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Operador activo badge
                  if (_ctrl.operadorActivo.isNotEmpty)
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        margin: const EdgeInsets.only(right: 24),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: const LinearGradient(
                            colors: [_opColor1, _opColor2],
                          ),
                        ),
                        child: Text(
                          _ctrl.operadorActivo,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  const Spacer(),
                  // Expresión
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      _ctrl.expresion.isEmpty ? ' ' : _ctrl.expresion,
                      style: TextStyle(
                        color: _opActivo.withValues(alpha: 0.7),
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 1.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Número principal
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerRight,
                      child: ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Colors.white, Color(0xFFE0C3FC), Color(0xFFC77DFF)],
                        ).createShader(bounds),
                        child: Text(
                          _ctrl.display,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 82,
                            fontWeight: FontWeight.w200,
                            letterSpacing: -3,
                            height: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _teclado() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(children: [
            _botonFuncion('AC', () => _actualizar(_ctrl.limpiar)),
            _botonFuncion('+/-', () => _actualizar(_ctrl.cambiarSigno)),
            _botonFuncion('%', () => _actualizar(_ctrl.porcentaje)),
            _botonOperador('÷', () => _actualizar(() => _ctrl.presionarOperador('÷'))),
          ]),
          Row(children: [
            _botonNumero('7', () => _actualizar(() => _ctrl.presionarNumero('7'))),
            _botonNumero('8', () => _actualizar(() => _ctrl.presionarNumero('8'))),
            _botonNumero('9', () => _actualizar(() => _ctrl.presionarNumero('9'))),
            _botonOperador('×', () => _actualizar(() => _ctrl.presionarOperador('×'))),
          ]),
          Row(children: [
            _botonNumero('4', () => _actualizar(() => _ctrl.presionarNumero('4'))),
            _botonNumero('5', () => _actualizar(() => _ctrl.presionarNumero('5'))),
            _botonNumero('6', () => _actualizar(() => _ctrl.presionarNumero('6'))),
            _botonOperador('-', () => _actualizar(() => _ctrl.presionarOperador('-'))),
          ]),
          Row(children: [
            _botonNumero('1', () => _actualizar(() => _ctrl.presionarNumero('1'))),
            _botonNumero('2', () => _actualizar(() => _ctrl.presionarNumero('2'))),
            _botonNumero('3', () => _actualizar(() => _ctrl.presionarNumero('3'))),
            _botonOperador('+', () => _actualizar(() => _ctrl.presionarOperador('+'))),
          ]),
          Row(children: [
            _botonNumero('⌫', () => _actualizar(_ctrl.borrarUltimo)),
            _botonNumero('0', () => _actualizar(() => _ctrl.presionarNumero('0'))),
            _botonNumero('.', () => _actualizar(_ctrl.presionarPunto)),
            _botonOperador('=', () => _actualizar(_ctrl.calcularResultado)),
          ]),
        ],
      ),
    );
  }
}

class _BotonCalc extends StatefulWidget {
  final String texto;
  final VoidCallback accion;
  final Color? fondo;
  final LinearGradient? gradiente;
  final Color colorTexto;
  final Color? sombra;

  const _BotonCalc({
    required this.texto,
    required this.accion,
    this.fondo,
    this.gradiente,
    required this.colorTexto,
    this.sombra,
  });

  @override
  State<_BotonCalc> createState() => _BotonCalcState();
}

class _BotonCalcState extends State<_BotonCalc>
    with SingleTickerProviderStateMixin {
  late AnimationController _anim;
  late Animation<double> _escala;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
    );
    _escala = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _anim, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  void _onTapDown(_) => _anim.forward();
  void _onTapUp(_) => _anim.reverse();
  void _onTapCancel() => _anim.reverse();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: GestureDetector(
          onTapDown: _onTapDown,
          onTapUp: _onTapUp,
          onTapCancel: _onTapCancel,
          onTap: widget.accion,
          child: ScaleTransition(
            scale: _escala,
            child: Container(
              height: 72,
              decoration: BoxDecoration(
                color: widget.gradiente == null ? widget.fondo : null,
                gradient: widget.gradiente,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: widget.sombra ??
                        Colors.black.withValues(alpha: 0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.06),
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  widget.texto,
                  style: TextStyle(
                    color: widget.colorTexto,
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
