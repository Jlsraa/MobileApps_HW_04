import 'package:flutter/material.dart';

class CuentaItem extends StatelessWidget {
  final String tipoCuenta;
  final String terminacion;
  final String saldoDisponible;
  const CuentaItem({
    Key? key,
    this.tipoCuenta = "Cuenta",
    this.terminacion = "0000",
    this.saldoDisponible = "0.0",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          "$tipoCuenta",
          style: TextStyle(
            color: Colors.indigo,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        subtitle: Text("~$terminacion"),
        trailing: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "\$$saldoDisponible",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w300,
              ),
            ),
            Text(
              "Saldo disponible",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
