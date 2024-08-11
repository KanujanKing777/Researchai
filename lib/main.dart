import 'package:flutter/material.dart';
import 'package:newresearchai/backend.dart';
import 'package:newresearchai/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:newresearchai/backback.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:newresearchai/loginpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
User? user;

void main () async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: LoginPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String title = "";
  String objectives = "";
  String question = "";
  String resource = "";
  String vary = "";
  String output = "";
  String txt = "";
  Widget analysis = Text("");
  Widget resources = Text("");
  Widget previousResearches = Text("");
  Widget dataCollected = Text("");
  Widget dataAnalysis = Text("");
  int currentIndex = 0;
  void _incrementCounter() async{
    Widget loading = Container(
      margin: EdgeInsets.only(bottom: 20.0, top:20.0),
      child: LoadingAnimationWidget.prograssiveDots(
        color: Colors.blue,
        size:50
        
      ),
    );
    setState(() {
      analysis = loading;
      resources = loading;
      previousResearches = loading;
      dataCollected = loading;
      dataAnalysis = loading;
    });
    final apiKey = 'AIzaSyC6tO8ztxsjgryvBHgJ0getzJ_WsA7oyfY';
    if (apiKey == null) {
      print('No \$API_KEY environment variable');
    }
    String newtext = "I am going to do a research on the title $title" + 
    "covering the research question $question" + 
    "with the objectives of $objectives" + 
    "while using the resourve $resource" + 
    "please prepare only the headings of my research";
    var content = [Content.text(newtext)];
    var model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);

    var response = await model.generateContent(content);
    
      setState(() {
        txt = response.text??"";
      });
      var listt = parseTextToMap(txt);
      List<Widget> outputs = [];
      List<String> outputsreal = [];
      listt.forEach((key, value) {
        Widget newws = ListTile(
                    title: Text(key),
                    subtitle: Text(value),
                  );
        outputs.add(newws);
        outputsreal.add(value);
      });
      setState(() {
      analysis = ExpansionTile(
              title: Text('Research Overview'),
              children: outputs,
            );
    });
      newtext = "I want to find some resources related with $question" + 
      "please find the relevant resources";
      content = [Content.text(newtext)];
      model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);

      response = await model.generateContent(content);
      String resourcestring = response.text??""; 
      String outputresource = resourcestring;
      outputresource = parseTextToMap2(outputresource);
      setState(() {
        resources = ExpansionTile(
              title: Text('Resources'),
              children:[Text(outputresource)]
            );
      });
      newtext = "I am going to do a research on the title $title" + 
      "covering the research question $question" + 
      "while using the resourve $resource" + 
      "please list only the previously done researches similar to mine";
      content = [Content.text(newtext)];
      model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);

      response = await model.generateContent(content);
      String resourcestring2 = response.text??""; 
      Text outputresource2 = Text(parseTextToMap2(resourcestring2));
      String outputresource2real = parseTextToMap2(resourcestring2);
      
      setState(() {
        previousResearches = ExpansionTile(
              title: Text('Previously done Researches'),
              children:[outputresource2],
            );
      });

      newtext = 
      "please collect some data that would be required for this $question" +
      "from the resources $outputresource";

      content = [Content.text(newtext)];
      model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);

      response = await model.generateContent(content);
      String resourcestring3 = response.text??""; 
      listt = parseTextToMap(resourcestring3);
      List<Widget> outputresource3 = [];
      List<String> outputresource3real = [];
      listt.forEach((key, value) {
      Widget newws = ListTile(
                  title: Text(key),
                  subtitle: Text(value),
                );
      outputresource3.add(newws);
      outputresource3real.add(value);
    });
      setState(() {
        dataCollected = ExpansionTile(
              title: Text('Collected Data'),
              children:outputresource3
            );
      });
      newtext = "I am going to do a research on the title $title" + 
      "covering the research question $question" + 
      "while using the resourve $resource" + 
      "and $outputresource3 is the collected data" + 
      "now prepare the analysis of that data in research point of view";
      content = [Content.text(newtext)];
      model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);

      response = await model.generateContent(content);
      String resourcestring4 = response.text??""; 
      listt = parseTextToMap(resourcestring4);
    Text outputresource4 = Text(parseTextToMap2(resourcestring4));
    String outputresource4real = parseTextToMap2(resourcestring4);
      setState(() {
        dataAnalysis = ExpansionTile(
              title: Text('Data Analysis'),
              children:[outputresource4]
            );
      });

    RegExp regExp = RegExp(r'\n(?=[IVXLCDM]+\.)');
  
    List<String> sections = txt.split(regExp);
    for(var section in sections){
      newtext = "I am going to do a research on the title $title" + 
      "covering the research question $question" + 
      "while using the resourve $resource" + 
      "please prepare only the content on $section";
      content = [Content.text(newtext)];
      model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);

      response = await model.generateContent(content);
      
      setState(() {
        txt += response.text??"";
      });
    }
    final db = FirebaseFirestore.instance;
    // Create a new user with a first and last name
    final research = <String, dynamic>{
      "Title": title,
      "overview":outputsreal,
      "resources":outputresource.toString(),
      "previousresearches":outputresource2real,
      "contents": outputresource3real,
      "analysis": outputresource4real,
      "question":question,
      "author":user?.displayName
    };

// Add a new document with a generated ID
  db.collection("researches").add(research).then((DocumentReference doc) =>
    print('DocumentSnapshot added with ID: ${doc.id}'));
  }

  void change(String value, String vary) {
    if(vary == "title"){
      setState(() {
        title = value;
      });
    }else if(vary == "resource"){
      setState(() {
        resource = value;
      });
    }else if(vary == "objectives"){
      setState(() {
        objectives = value;
      });
    }else if(vary == "question"){
      setState(() {
        question = value;
      });
    }

  }
    

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Research Ai'),
      ),
      body: currentIndex == 1 ? 
      SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(8.0),
          child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            TextField(
              onChanged: (value) => {
                change(value, "title")
              },
              decoration: InputDecoration(hintText: "Title"),
            ),
            TextField(
              onChanged: (value) => {
                change(value,"question")
              },
              maxLines: 2,
              decoration: InputDecoration(hintText: "Research Question"),
            ),
            TextField(
              onChanged: (value) => {
                change(value,"objectives")
              },
              maxLines: 3,
              decoration: InputDecoration(hintText: "Objectives"),
            ),
            TextField(
              onChanged: (value) => {
                change(value,"resource")
              },
              maxLines: 3,
              decoration: InputDecoration(hintText: "Resources"),
            ),
            analysis,
            resources,
            previousResearches,
            dataCollected,
            dataAnalysis
           
          ],
        ),
       )
      )
      :HomePage(),
      floatingActionButton: 
      FloatingActionButton(
        onPressed: _incrementCounter,
        child: const Icon(Icons.send),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedIconTheme: IconThemeData(color: Colors.blue),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.create), label: "Create"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
        ],
        onTap: (value) {
          setState(() {
            currentIndex = value;
          });
        },
      ),
    );
  }
}
