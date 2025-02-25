// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // ------ DATA IN OUT
  final TextEditingController outCoin = TextEditingController(text: '');
  final TextEditingController inCoin = TextEditingController(text: '');

  // ------ Valor de compra y venta
  String fecha = '';
  String error = '';
  double compra = -1;
  double venta = -1;

  // ------ TipoCambioCTRL
  bool tc_ctrl = true;

  // ------ Colors
  Color color1 = Color.fromARGB(255, 79, 111, 82);
  Color color2 = Color.fromARGB(255, 115, 144, 114);
  Color color3 = Color.fromARGB(255, 134, 167, 137);
  Color color4 = Color.fromARGB(255, 210, 227, 200);

  // ------ FETCH DATA
  // TRAER DATA API
  Future<void> fectchData() async {
    final response = await http
        .get(Uri.parse('https://www.sunat.gob.pe/a/txt/tipoCambio.txt'));

    if (response.statusCode == 200) {
      String resp = response.body;
      String compra2 = resp.split('|')[1];
      String venta2 = resp.split('|')[2];

      setState(() {
        fecha = resp.split('|')[0];
        compra = double.parse(compra2);
        venta = double.parse(venta2);
      });
    } else {
      setState(() {
        error = 'Error al cargar los datos';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fectchData();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final sw = size.width;
    final sh = size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: color4,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(sh * 0.05, sh * 0.05, sh * 0.05, 10),
          child: Column(
            children: [
              // ------ LOGO IMG
              Center(
                  child: Image(
                      image: AssetImage('assets/img/logo_tc.png'),
                      height: sh * 0.15)),
              SizedBox(height: sh * 0.025),

              // ------ TITLE LOGO
              Text('Conversor de Dolares',
                  style: TextStyle(
                      fontSize: sh * 0.025,
                      fontWeight: FontWeight.bold,
                      color: color1)),
              SizedBox(height: sh * 0.06),

              // ------ ESCOGER COMPRAR O VENDER
              GestureDetector(
                onTap: () => setState(() {
                  tc_ctrl = !tc_ctrl;
                  inCoin.text = '';
                  outCoin.text = '';
                }),
                child: Container(
                  color: Colors.transparent,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // ------ Dolar Compra
                        Column(children: [
                          Text('Dólar compra',
                              style: TextStyle(
                                  color: color1,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w200)),
                          SizedBox(height: 4),
                          Text(
                            compra == -1 ? 'Cargando...' : compra.toString(),
                            style: TextStyle(
                              color: color1,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          )
                        ]),

                        // ------ Dolar Venta
                        Column(children: [
                          Text('Dólar venta',
                              style: TextStyle(
                                  color: color1,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w200)),
                          SizedBox(height: 4),
                          Text(
                            venta == -1 ? 'Cargando...' : venta.toString(),
                            style: TextStyle(
                              color: color1,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          )
                        ]),
                      ]),
                ),
              ),
              SizedBox(height: 3),

              // ------ LINEA HORIZONTAL
              Row(
                mainAxisAlignment:
                    tc_ctrl ? MainAxisAlignment.start : MainAxisAlignment.end,
                children: [
                  Container(
                    color: color1,
                    height: 1,
                    width: (sw - sh * 0.1) / 2,
                  ),
                ],
              ),
              Container(
                  color: Color.fromARGB(30, 126, 29, 44), width: sw, height: 1),

              // ------ MONTO MINIMO TEXT
              SizedBox(height: 20),
              Text(
                  style: TextStyle(
                    color: color2,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                  tc_ctrl
                      ? 'Monto mínimo \$1.00'
                      : 'Monto mínimo S/${venta.toString()}'),

              // ------ CONTAINER INPUT IN
              SizedBox(height: 25),
              Container(
                decoration: BoxDecoration(border: Border.all(color: color1)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: (sw - sh * 0.1) / 2,
                      color: color3,
                      child: Center(
                          child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 13, 0, 13),
                        child: Text(tc_ctrl ? 'Dólares' : 'Soles',
                            style: TextStyle(
                                fontSize: 18,
                                color: color1,
                                fontWeight: FontWeight.w600)),
                      )),
                    ),
                    SizedBox(
                      width: (sw - sh * 0.11) / 2,
                      child: Center(
                          child: Row(
                        children: [
                          SizedBox(width: 10),
                          Text(tc_ctrl ? '\$' : 'S/',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: color1,
                                  fontWeight: FontWeight.w600)),
                          SizedBox(width: 5),
                          Expanded(
                            // ------ TextField Ingresar
                            child: TextField(
                              onChanged: (val) {
                                if (val == '0' || val == '') {
                                  outCoin.text = '';
                                } else {
                                  if (tc_ctrl) {
                                    double outputDouble =
                                        double.parse(val) * compra;
                                    if (outputDouble.toString().length > 9) {
                                      outCoin.text =
                                          '${outputDouble.toStringAsFixed(3)}...';
                                    } else {
                                      outCoin.text = outputDouble.toString();
                                    }
                                  } else {
                                    if (double.parse(val) >= venta) {
                                      double outputDouble =
                                          double.parse(val) / venta;
                                      if (outputDouble.toString().length > 9) {
                                        outCoin.text =
                                            '${outputDouble.toStringAsFixed(3)}...';
                                      } else {
                                        outCoin.text = outputDouble.toString();
                                      }
                                    }
                                  }
                                }
                              },
                              controller: inCoin,
                              keyboardType: TextInputType.number,
                              maxLength: 9,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]')),
                                // RegExp(r'^\d+\.?\d{0,8}$')),
                              ],
                              decoration: InputDecoration(
                                hintText: '0.00',
                                border: InputBorder.none,
                                counterText: '',
                              ),
                            ),
                          )
                        ],
                      )),
                    ),
                  ],
                ),
              ),

              // ------ img change
              SizedBox(height: sh * 0.005),
              Center(
                  child: Image(
                      image: AssetImage('assets/img/img_change.png'),
                      height: sh * 0.03)),

              // ------ CONTAINER INPUT OUT
              SizedBox(height: 5),
              Container(
                decoration: BoxDecoration(border: Border.all(color: color1)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: (sw - sh * 0.1) / 2,
                      color: color3,
                      child: Center(
                          child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 13, 0, 13),
                        child: Text(tc_ctrl ? 'Soles' : 'Dólares',
                            style: TextStyle(
                                fontSize: 18,
                                color: color1,
                                fontWeight: FontWeight.w600)),
                      )),
                    ),
                    SizedBox(
                      width: (sw - sh * 0.11) / 2,
                      child: Center(
                          child: Row(
                        children: [
                          SizedBox(width: 10),
                          Text(!tc_ctrl ? '\$' : 'S/',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: color1,
                                  fontWeight: FontWeight.w600)),
                          SizedBox(width: 5),
                          Expanded(
                            // ------ TextField Ingresar
                            child: TextField(
                              controller: outCoin,
                              readOnly: true,
                              keyboardType: TextInputType.number,
                              maxLength: 9,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]')),
                                // RegExp(r'^\d+\.?\d{0,8}$')),
                              ],
                              decoration: InputDecoration(
                                hintText: '0.00',
                                border: InputBorder.none,
                                counterText: '',
                              ),
                            ),
                          )
                        ],
                      )),
                    ),
                  ],
                ),
              ),

              // ------
              SizedBox(height: sh * 0.05),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(border: Border.all(color: color1)),
                child: Column(
                  children: [
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 10),
                        Text(
                          'Importante:',
                          style: TextStyle(
                            color: color1,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 10, 10, 5),
                      child: Text(
                        'Los valores de compra y venta han sido obtenidos de la página de SUNAT correspondientes al día $fecha. Puedes consultarlos en el siguiente enlace:',
                        style: TextStyle(
                          color: color1,
                          fontWeight: FontWeight.w400,
                          fontSize: 10,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 10, 10, 5),
                      child: GestureDetector(
                        onTap: () {
                          const url =
                              'https://e-consulta.sunat.gob.pe/cl-at-ittipcam/tcS01Alias';
                          launchUrl(Uri.parse(url),
                              mode: LaunchMode.inAppBrowserView);
                        },
                        child: Text(
                          'https://e-consulta.sunat.gob.pe/cl-at-ittipcam/tcS01Alias',
                          style: TextStyle(
                              color: color1,
                              fontWeight: FontWeight.w600,
                              fontSize: 8),
                        ),
                      ),
                    )
                  ],
                ),
              ),

              // ------ FOOTER
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Center(
                        child: Text('Creado por',
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.w600))),
                    Center(
                        child: Text('Caleb Izquierdo',
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.w600))),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
