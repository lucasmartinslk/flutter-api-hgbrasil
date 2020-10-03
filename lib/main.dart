import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'file:///C:/Users/Lucas/AndroidStudioProjects/flutter_app_api/lib/componentes/componentes.dart';
import 'package:http/http.dart';


void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  TextEditingController encontraAcao = TextEditingController();
  GlobalKey<FormState> cForm = GlobalKey<FormState>();

  dynamic symbol = "Ação";
  dynamic empresa = "Empresa";
  dynamic moeda = "Moeda";
  dynamic preco = "Valor";


  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  clicouNoBotao() async{
    if(!cForm.currentState.validate())
      return;
    String x = encontraAcao.text.toUpperCase();
    String url = "https://api.hgbrasil.com/finance/stock_price?key=ab42ba06&symbol=$x";
    Response resposta = await get(url);
    Map informa = json.decode(resposta.body);
    var resultado = informa["results"][encontraAcao.text];
    print(x);


    print(resultado["currency"]);
    setState(() {
      symbol = resultado["symbol"];
      preco = '${resultado["price"]}';
      empresa = resultado["name"];
      moeda = '${resultado["currency"]}';
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: cForm,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Colors.deepPurpleAccent,
                child: Image.asset(
                  "assets/imgs/hg.png",
                  fit: BoxFit.none,
                ),
                height: 200,
              ),
              Componentes.caixaDeTexto("Ação", "Digite o código da Ação", encontraAcao, null, numero: false),
              Container(
                alignment: Alignment.center,
                height: 100,
                child: IconButton(
                  onPressed: clicouNoBotao,
                  icon: FaIcon(FontAwesomeIcons.search, color: Colors.deepPurpleAccent, size: 50,),
                ),
              ),
              Componentes.rotulo(symbol),
              Componentes.rotulo(preco + ' ' + moeda),
              Componentes.rotulo(empresa),
            ],
          ),
        ),
      ),
    );
  }
}