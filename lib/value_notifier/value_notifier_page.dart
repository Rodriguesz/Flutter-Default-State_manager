// ignore_for_file: body_might_complete_normally_nullable

//? Diferente do SetState, o ValueNotifier rebuilda apenas a parte a tela que ele está envolvido

import 'dart:math';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_default_state_manager/widgets/imc_gauge.dart';
import 'package:intl/intl.dart';

class ValueNotifierPage extends StatefulWidget {
  const ValueNotifierPage({super.key});

  @override
  State<ValueNotifierPage> createState() => _ValueNotifierPageState();
}

class _ValueNotifierPageState extends State<ValueNotifierPage> {
  final pesoController = TextEditingController();
  final alturaController = TextEditingController();
  var imc = ValueNotifier(0.0);
  final formKey = GlobalKey<FormState>();

  Future<void> _calcularIMC({required double peso, required double altura}) async {
    imc.value = 0;

    ///pra dar tempo de voltar o ponteiro pro 0 antes de subir de novo
    await Future.delayed(const Duration(seconds: 1));

    /// pow é uma função para calcular exponenciação
    imc.value = peso / pow(altura, 2);
  }

  @override
  void dispose() {
    pesoController.dispose();
    alturaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Imc value notifier'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              ValueListenableBuilder<double>(
                  valueListenable: imc,
                  builder: (_, imcValue, __) {
                    return ImcGauge(imc: imcValue);
                  }),
              const SizedBox(height: 20),
              TextFormField(
                  controller: pesoController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Peso'),
                  inputFormatters: [
                    CurrencyTextInputFormatter(
                      /// Muda o formfield para se adaptar aos padrões do pt br
                      locale: 'pt_BR',

                      /// Vazio para remover o simbulo do cifrão que vem por padrão
                      symbol: '',

                      /// Casas depois da virgula
                      decimalDigits: 2,

                      /// Desliga o ponto das casas acima de 1000
                      turnOffGrouping: true,
                    )
                  ],
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Peso Obrigatório';
                    }
                  }),
              TextFormField(
                  controller: alturaController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Altura'),
                  inputFormatters: [
                    CurrencyTextInputFormatter(
                      /// Muda o formfield para se adaptar aos padrões do pt br
                      locale: 'pt_BR',

                      /// Vazio para remover o simbulo do cifrão que vem por padrão
                      symbol: '',

                      /// Casas depois da virgula
                      decimalDigits: 2,

                      /// Desliga o ponto das casas acima de 1000
                      turnOffGrouping: true,
                    )
                  ],
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Altura Obrigatória';
                    }
                  }),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    var formValid = formKey.currentState?.validate() ?? false;

                    if (formValid) {
                      /// função para transformar o numero que vai vir em pt br
                      /// biblioteca intl
                      var formatter =
                          NumberFormat.simpleCurrency(locale: 'pt_BR', decimalDigits: 2);

                      double peso = formatter.parse(pesoController.text) as double;
                      double altura = formatter.parse(alturaController.text) as double;

                      _calcularIMC(peso: peso, altura: altura);
                    }
                  },
                  child: const Text('Calcular IMC'))
            ]),
          ),
        ),
      ),
    );
  }
}
