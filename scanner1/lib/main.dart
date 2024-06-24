import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QR Code Scanner',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: Colors.blue, // Couleur du texte du bouton Copy
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const QRCodeWidget(),
    );
  }
}

class QRCodeWidget extends StatefulWidget{
  const QRCodeWidget({super.key});

  @override
  State<QRCodeWidget> createState() => _QRCodeWidgetState();
}


class _QRCodeWidgetState extends State<QRCodeWidget> {

  final GlobalKey qrKey = GlobalKey(debugLabel: "QR");
  QRViewController? controller;
  String result = "";

  @override
  void dispose(){
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller){
    this.controller = controller;
    controller.scannedDataStream.listen((scanData){
      setState(() {
        result = scanData.code!;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        title: const Text("QR Code Scanner"),
      ),
      body: Column(
        children: [
        Expanded(
          flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,)
        ),

        Expanded(
          flex: 1,
            child: Center(
              child: Text("Scan Result : $result",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold, // Met en gras
              ),
              ),
            ),
        ),

        Expanded(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
            ElevatedButton(
                onPressed: (){
                  if(result.isNotEmpty){
                    Clipboard.setData(ClipboardData(text: result));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("copied to Clipboard")),
                    );
                  }
                },
                child: const Text("Copy")),
              ElevatedButton(onPressed: ()async{



                if(result.isNotEmpty) {
                  final Uri _url = Uri.parse(result);
                  await launchUrl(_url);
                }
              },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.indigo,
                  ),
                  child: const Text("Open"))
          ],),

        ),
      ],),
    );

  }
}
