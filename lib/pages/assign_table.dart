import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:order_it_2/pages/home_page.dart';
import 'package:order_it_2/services/supabase_api.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;

class AssignTable extends StatefulWidget {

  final String userId;

  const AssignTable({
    super.key,
    required this.userId
  });

  @override
  State<AssignTable> createState() => _AssignTableState();
}

class _AssignTableState extends State<AssignTable> {

  // Sirve para identificar de manera única un widget en el árbol de widgets. Esto es útil cuando necesitas acceder al estado de un widget desde fuera del mismo.
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  // Puede ser null en casos como justo después de que se crea el widget, pero antes de que el controlador haya sido inicializado, por eso "?"
  QRViewController? controller;
  SupabaseApi supabaseApi = SupabaseApi();

  // Método para cuando la aplicación se recompone (funcionalidad de la cámara)
  @override
  void reassemble(){
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    }
    controller?.resumeCamera();
  }

  // Liberar recursos de la cámara cuando el widget se elimina del árbol de widgets
  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  // Listener para escuchar los datos escaneados
  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      if (result == null && scanData.code != null) {
        setState(() {
          result = scanData;
        });
        await _scanTableQR(scanData.code!);
      }
    });
  }

  Future<void> _scanTableQR(String qrCode) async {
    
    const String baseUrl = 'https://jfpvrylxyunglhbegowh.supabase.co';
    const String apikey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImpmcHZyeWx4eXVuZ2xoYmVnb3doIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTkzMjE3MTcsImV4cCI6MjAzNDg5NzcxN30.KujGgYTg_0ZVU5lkujuLZ7EVXloz566IgziKvNwZRf8';
    const String authorization = 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImpmcHZyeWx4eXVuZ2xoYmVnb3doIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTkzMjE3MTcsImV4cCI6MjAzNDg5NzcxN30.KujGgYTg_0ZVU5lkujuLZ7EVXloz566IgziKvNwZRf8';
    bool isOccupied;
  
    // Extraer el número de mesa del contenido del código QR (asumiendo que es una URL)
    Uri uri = Uri.parse(qrCode);
    final String tableNumberQuery =uri.queryParameters['table_number'] ?? '';
    int tableNumber = int.tryParse(tableNumberQuery.replaceAll("eq.", "")) ?? 0;

    if (tableNumber == 0) {
      //_showDialog('Error', 'No se ha encontrado el número de la mesa en el QR Code URL', () {});
      return;
    }

    isOccupied = await supabaseApi.getIsOccupied(tableNumber);

    bool doubleReservation = await supabaseApi.getReservations(widget.userId);

    if (doubleReservation) {
      _showDialog('Error', 'Ya tienes una mesa reservada. No puedes reservar otra.', () {});
      return;
    }

    // URL para la petición PATCH
    final url = '$baseUrl/rest/v1/tables?table_number=eq.$tableNumber';

    final headers = {
      'apikey' : apikey,
      'Authorization' : authorization,
      'Content-Type' : 'application/json'
    };

    final body = jsonEncode({
      'is_occupied' : true,
      'user_id' : widget.userId
    });

    if (!doubleReservation) {
      final response = await http.patch(Uri.parse(url), headers: headers, body: body);

      if (response.statusCode == 204) {
        if (isOccupied) {
          _showDialog('Error', 'La mesa $tableNumber está ocupada, escoja otra por favor.', (){});
        } else {
          _showDialog('Mesa asignada', 'La mesa $tableNumber ha sido reservada con éxito.', (){
            controller?.stopCamera();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePage(ordersAllowed: true),
              )
            );
          });
        }
      } else {
        _showDialog('Error', 'Error al asignar la mesa $tableNumber.', (){});
      }
    }
  }

  void _showDialog(String title, String content, VoidCallback onOkPressed) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  result = null; // Resetea el resultado para poder escanear otro QR
                });
                controller?.resumeCamera(); // Reactiva la cámara para volver a escanear
                onOkPressed(); // Ejecuta la acción del showDialog de forma dinámica (errores/éxito)
              },
              child: const Text('Ok')
            )
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Escanea el QR de tu mesa', style: TextStyle( color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Stack(
        children: [
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated
          ),
          Center(
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all( color: Colors.white, width: 2 ),
                borderRadius: BorderRadius.circular(12)
              ),
            ),
          )
        ],
      ),
    );
  }
}