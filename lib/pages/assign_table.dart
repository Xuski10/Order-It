import 'dart:io';
import 'package:flutter/material.dart';
import 'package:order_it_2/services/supabase_api.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

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


  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}