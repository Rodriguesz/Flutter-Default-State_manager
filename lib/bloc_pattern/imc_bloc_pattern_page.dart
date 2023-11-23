import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_default_state_manager/bloc_pattern/imc_bloc_pattern_controller.dart';
import 'package:flutter_default_state_manager/bloc_pattern/imc_state.dart';
import 'package:intl/intl.dart';

import '../widgets/imc_gauge.dart';

//? O bloc pattern utiliza streams para fazer a atualização dos estados

class ImcBlocPatternPage extends StatefulWidget {
  const ImcBlocPatternPage({super.key});

  @override
  State<ImcBlocPatternPage> createState() => _ImcBlocPatternPageState();
}

class _ImcBlocPatternPageState extends State<ImcBlocPatternPage> {
  final controller = ImcBlocPatternController();
  final pesoController = TextEditingController();
  final alturaController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    pesoController.dispose();
    alturaController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Imc Bloc Pattern'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              /// Stream que renderiza o ponteiro
              StreamBuilder<ImcState>(
                stream: controller.imcOut,
                builder: (context, snapshot) {
                  var imc = snapshot.data?.imc ?? 0;
                  return ImcGauge(imc: imc);
                },
              ),
              const SizedBox(
                height: 20,
              ),
              StreamBuilder<ImcState>(
                stream: controller.imcOut,
                builder: (context, snapshot) {
                  final dataValue = snapshot.data;

                  if (snapshot.data is ImcStateLoading) {
                    const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot is ImcStateError) {
                    return Text(dataValue.message);
                  }
                },
              ),
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

                      controller.calcularImc(peso: peso, altura: altura);
                      // _calcularIMC(peso: peso, altura: altura);
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
