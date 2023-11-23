import 'dart:async';
import 'dart:math';

import 'package:flutter_default_state_manager/bloc_pattern/imc_state.dart';

class ImcBlocPatternController {
  ///uma stream controller do tipo ImcState
  final _imcStreamController = StreamController<ImcState>.broadcast()..add(ImcState(imc: 0));

  ///Porta de saida dos dados da stream
  Stream<ImcState> get imcOut => _imcStreamController.stream;
  Future<void> calcularImc({required double peso, required double altura}) async {
    try {
      ///O add é um "atalho" para enviar os dados para a controller
      ///Assim, não sendo necessário o uso do Sink
      _imcStreamController.add(ImcStateLoading());
      await Future.delayed(const Duration(seconds: 1));
      final imc = peso / pow(altura, 2);
      _imcStreamController.add(ImcState(imc: imc));
    } on Exception catch (e) {
      _imcStreamController.add(ImcStateError(message: 'Erro ao calcular IMC'));
    }
  }

  ///Função que fecha a Stream (assim como todo controller deve ser fechado)
  void dispose() {
    _imcStreamController.close();
  }
}
