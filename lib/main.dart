import 'package:currencyfinal/Model/Currency.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:intl/intl.dart';
import 'dart:ui'as ui;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Localizations Sample App',
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('fa', ''), // Farsi
      ],
      theme: ThemeData(
        fontFamily: 'dana',
        textTheme: TextTheme(
          headlineLarge: TextStyle(
            fontFamily: 'dana',
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
          headlineMedium: TextStyle(
            fontFamily: 'dana',
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
          bodyLarge: TextStyle(
            fontFamily: 'dana',
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.red,
          ),
          bodyMedium: TextStyle(
            fontFamily: 'dana',
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.green,
          ),
          headlineSmall: TextStyle(
            fontFamily: 'dana',
            fontSize: 13,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),

      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Currency> currency=[];

   Future getResponse (BuildContext context)async{

    var url = "https://sasansafari.com/flutter/api.php?access_key=flutter123456";
   var value = await http.get(Uri.parse(url));

        if(currency.isEmpty){
            if(value.statusCode==200){
              // ignore: use_build_context_synchronously
              _showSnackBar(context,"بروزرسانی با موفقیت انجام شد!");
                List jsonList = convert.jsonDecode(value.body);
                if(jsonList.isEmpty){

                    for(int i = 0 ; i < jsonList.length; i++){
                        setState(() {
                          currency.add(Currency(
                            id: jsonList[i]["id"],
                           title: jsonList[i]["title"],
                            price: jsonList[i]["price"],
                             changes: jsonList[i]["changes"],
                              status: jsonList[i]["status"]));
                        });

                    }
                }
            }
        }
  return value;
  

  }
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    getResponse(context);
  }
  @override
  Widget build(BuildContext context) {



    return Scaffold(
      backgroundColor: Color.fromARGB(255, 243, 243, 243),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          SizedBox(width: 12),
          Image.asset("assets/images/icon.png"),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              "قیمت بروز ارز",
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),

          Image.asset("assets/images/menu.png"),
          SizedBox(width: 12),
        ],
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Image.asset("assets/images/q.png"),
                  SizedBox(width: 8),
                  Text(
                    "نرخ ارز آزاد چیست؟",
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                ],
              ),
              SizedBox(height: 12),
              Text(
                " نرخ ارزها در معاملات نقدی و رایج روزانه است معاملات نقدی معاملاتی هستند که خریدار و فروشنده به محض انجام معامله، ارز و ریال را با هم تبادل می نمایند.",
                style: Theme.of(context).textTheme.headlineSmall,
                textDirection:ui.TextDirection.rtl,
              ),
              SizedBox(height: 12),
              Container(
                height: 35,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1000),
                  color: Color.fromARGB(255, 130, 130, 130),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "نام آزاد ارز",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Text(
                      "قیمت",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Text(
                      "تغییر",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 390,
                width: double.infinity,
                child: ListFutureBuilder(context),
              ),
              SizedBox(height: 5),

              Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1000),
                  color: Colors.white,
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 50,
                      child: TextButton.icon(
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(
                            Color.fromARGB(255, 202, 193, 255),
                          ),
                          shape: WidgetStatePropertyAll<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius:
                          BorderRadius.circular(1000) ))
                        ),
                        onPressed: (){
                          currency.clear();
                          ListFutureBuilder(context);
                        },
                        icon: Icon(CupertinoIcons.refresh_bold,color: Colors.black,),
                        label: Text("بروزرسانی",style: Theme.of(context).textTheme.headlineLarge,),
                      ),
                      
                    ),
                    Text(" آخرین بروز رسانی ${_getTime()}," ,style: Theme.of(context).textTheme.headlineSmall,),
                    SizedBox(width: 2,)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  FutureBuilder<dynamic> ListFutureBuilder(BuildContext context) {
    return FutureBuilder(
                builder: (context, snapshot) {
                  return snapshot.hasData?
                   ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: currency.length,
                  itemBuilder: (BuildContext context, int position) {
                    return MyItem(position,currency);
                  },
                ):Center(child: CircularProgressIndicator(),);
                }, future: getResponse(context),
              );
  }
}

_getTime() {
    DateTime now = DateTime.now();
    return DateFormat('kk:mm:ss').format(now); 
}

void _showSnackBar(BuildContext context,String msg){

    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg,style: Theme.of(context).textTheme.headlineLarge,),
        backgroundColor: Colors.greenAccent,)
        );
}

// ignore: must_be_immutable
class MyItem extends StatelessWidget {
    int position;
    List<Currency> currency;
   // ignore: use_key_in_widget_constructors
   MyItem(this.position,this.currency);

  @override
  Widget build(BuildContext context) {
    
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(1000),
          boxShadow: <BoxShadow>[
            BoxShadow(blurRadius: 3.0, color: Colors.white),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(currency[position].title!,style: Theme.of(context).textTheme.headlineSmall,),
             Text(getFarsiNumber(currency[position].price.toString()),style: Theme.of(context).textTheme.headlineSmall,),
              Text(getFarsiNumber(currency[position].changes.toString()),style: currency[position].status=='n'?
              Theme.of(context).textTheme.bodyLarge:Theme.of(context).textTheme.bodyMedium,)],
        ),
      ),
    );
  }
}
String getFarsiNumber(String number){

  const en = [ '0','1','2','3','4','5','6','7','8','9'];

  const fa = [ '۰','۱','۲','۳','۴','۵','۶','۷','۸','۹'];

  en.forEach((element){
    number = number.replaceAll(element, fa[en.indexOf(element)]);
  });
  return number;
}