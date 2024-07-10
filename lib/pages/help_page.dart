import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {

  final List<Map<String, String>> faqs = [
    {
      "question": "¿Cómo puedo escanear un código QR?",
      "answer":
          "Para escanear un código QR, abre la aplicación y selecciona la opción de escaneo. Asegúrate de que la cámara esté enfocando correctamente el código QR para que pueda ser leído correctamente."
    },
    {
      "question": "¿Por qué la cámara no enfoca el código QR?",
      "answer":
          "Verifica que la cámara de tu dispositivo esté limpia y tenga suficiente iluminación. También puedes intentar acercarte o alejarte del código QR para que la cámara pueda enfocarlo adecuadamente."
    },
    {
      "question": "¿Qué debo hacer si la aplicación no reconoce el código QR?",
      "answer":
          "Asegúrate de que el código QR esté bien impreso y no esté dañado. Si el problema persiste, intenta reiniciar la aplicación o el dispositivo."
    },
    {
      "question": "¿Cómo puedo hacer un pedido desde la mesa?",
      "answer":
          "Después de escanear el código QR, navega por el menú en la aplicación, selecciona los ítems que deseas pedir y agrégalos al carrito. Una vez que hayas terminado, procede a realizar el pago y disfruta de tu pedido."
    },
    {
      "question": "¿Qué hago si mi pedido no se procesa correctamente?",
      "answer":
          "Verifica tu conexión a internet y asegúrate de haber seguido todos los pasos correctamente. Si el problema persiste, contacta al personal del restaurante para asistencia."
    },
    {
      "question": "¿Cómo puedo pagar mi cuenta desde la mesa?",
      "answer":
          "Selecciona la opción de pago en la aplicación después de haber realizado tu pedido. Puedes ingresar los detalles de tu tarjeta de crédito o usar otros métodos de pago disponibles en la aplicación.(Proximamente)"
    },
    {
      "question": "¿Qué debo hacer si el pago no se completa?",
      "answer":
          "Asegúrate de que los detalles de pago sean correctos y que tu tarjeta tenga fondos suficientes. Si el problema persiste, intenta usar otro método de pago o contacta con tu banco. Contacta al personal del restaurante para asistencia"
    }
  ];

  HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayuda'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: faqs.length,
        itemBuilder: (context, index) {
          return FAQItem(
            question: faqs[index]['question']!,
            answer: faqs[index]['answer']!
          );
        },
      ),
    );
  }
}



class FAQItem extends StatelessWidget {

  final String question;
  final String answer;

  const FAQItem({
    super.key,
    required this.question,
    required this.answer
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 157, 217, 180),
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, 2)
          )
        ]
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: ExpansionTile(
          title: Text(
            question,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18
            ),
          ),
          children: <Widget>[
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16.0),
              child: Text(
                answer,
                style: const TextStyle(
                  fontSize: 16
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}