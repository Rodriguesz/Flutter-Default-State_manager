// ignore_for_file: body_might_complete_normally_nullable

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_default_state_manager/change_notifier/imc_change_notifier_controller.dart';
import 'package:flutter_default_state_manager/widgets/imc_gauge.dart';
import 'package:intl/intl.dart';

class ImcChangeNotifierPage extends StatefulWidget {
  const ImcChangeNotifierPage({super.key});

  @override
  State<ImcChangeNotifierPage> createState() => _ImcChangeNotifierPageState();
}

class _ImcChangeNotifierPageState extends State<ImcChangeNotifierPage> {
  final controller = ImcChangeNotifierController();
  final pesoController = TextEditingController();
  final alturaController = TextEditingController();
  final formKey = GlobalKey<FormState>();

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
        title: const Text('Imc Change notifier'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              AnimatedBuilder(
                  animation: controller,
                  builder: (context, child) {
                    return ImcGauge(imc: controller.imc);
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

                      controller.calcularIMC(peso: peso, altura: altura);
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
