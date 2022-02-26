import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

class Tarjetas extends StatefulWidget {
  Tarjetas({Key? key}) : super(key: key);

  @override
  _TarjetasState createState() => _TarjetasState();
}

class _TarjetasState extends State<Tarjetas> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tarjetas guardadas")),
      body: ListView(
        children: List.generate(
          4,
          (index) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: CreditCardWidget(
              onCreditCardWidgetChange: (card) {},
              cardNumber: "${index + 1}41258963$index",
              expiryDate: "${index * 2}/2$index",
              cardHolderName: "Juan Perez",
              cvvCode: "${(index + 2) * 999 % 1000}",
              showBackView: false, //true when you want to show cvv(back) view
              obscureCardNumber: false,
              obscureCardCvv: false,
            ),
          ),
        ),
      ),
    );
  }
}
