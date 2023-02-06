import 'package:delivery_app/core/ui/helpers/size_extensions.dart';
import 'package:delivery_app/core/ui/styles/text_styles.dart';
import 'package:delivery_app/core/ui/widgets/delivery_button.dart';
import 'package:flutter/material.dart';

class OrderCompletedPage extends StatelessWidget {
  const OrderCompletedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: context.percentHeight(.25)),
        child: Column(
          children: [
            Image.asset(
              "assets/images/logo_rounded.png",
              alignment: Alignment.center,
            ),
            Text(
              "Pedido realizado com sucesso, em breve você receberá a confirmação do seu pedido.",
              style: context.textStyles.textExtraBold.copyWith(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            DeliveryButton(
              width: context.percentWidth(.8),
              label: "FECHAR",
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
