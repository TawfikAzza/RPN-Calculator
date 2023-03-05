import 'package:flutter/material.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const Calculator(title: 'Flutter Demo Home Page'),
    );
  }
}

class Calculator extends StatefulWidget {
  const Calculator({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<Calculator> createState() => _MyCalculator();
}

class _MyCalculator extends State<Calculator> {
  int _counter = 0;
  var listEntries = [];
  var listCommands = [];
  var entry = "";
  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });

  }
  void _handleCommands(String operator) {
    calculate(listEntries, operator, listCommands);
  }
  void _handleUndo() {
    undo(listEntries, listCommands);
    setState(() {
      entry="";
    });
  }
  void _handleEnter() {
    if(num.tryParse(entry)!= null){
      listEntries.add(num.tryParse(entry));
      setState(() {
        entry="";
      });
    }
  }
  void _handleEntries(String n) {
    setState(() {
      entry+= n.toString();
    });
  }
  void _handleClear() {

    setState(() {
      listCommands.clear();
      listEntries.clear();
      entry="";
    });
  }
  List calculate(List entries, String operator, List listCommand) {
    if (entries.length < 2) {
      print("Number of entries insufficient to perform an operation");
      return entries;
    }
    Command<num> cmd;
    num num2 = entries.removeLast();
    num num1 = entries.removeLast();
    listCommand.add(num2);
    listCommand.add(operator);
    switch (operator) {
      case '+':
        cmd = Addition();
        num result = cmd.execute(num1, num2);
        print(result);
        setState(() {
          entry=result.toString();
        });
        entries.add(result);
        break;
      case '-':
        cmd = Subtraction();
        num result = cmd.execute(num1, num2);
        setState(() {
          entry=result.toString();
        });
        entries.add(result);
        break;
      case '*':
        cmd = Multiplication();
        num result = cmd.execute(num1, num2);
        setState(() {
          entry=result.toString();
        });
        entries.add(result);
        break;
      case '/':
        cmd = Division();
        if(num2==0){
          print('Dividing by zero, impossible');
          return entries;
        }
        num result = cmd.execute(num1, num2);
        setState(() {
          entry=result.toString();
        });
        entries.add(result);
        break;
    }
    return entries;
  }
  void undo(List listEntries, List listCommands) {
    if(listCommands.length<2) {
      print("No operations available for UNDO");
      return;
    }
    var operator = listCommands.removeLast();

    num num1 = listEntries.removeLast();
    num num2 = listCommands.removeLast();

    Command<num> cmd;
    switch (operator) {
      case '+':
        cmd = Addition();
        print(cmd.undo(num1,num2));
        listEntries.add(cmd.undo(num1, num2));
        listEntries.add(num2);
        print(listEntries);
        setState(() {
          entry=num2.toString();
        });
        break;
      case '-':
        cmd = Subtraction();
        listEntries.add(cmd.undo(num1, num2));
        listEntries.add(num2);
        break;
      case '*':
        cmd = Multiplication();
        if(num2==0) {
          print('Dividing by zero, impossible');
          return;
        }
        listEntries.add(cmd.undo(num1, num2));
        listEntries.add(num2);
        break;
      case '/':
        cmd = Division();
        listEntries.add(cmd.undo(num1, num2));
        listEntries.add(num2);
        break;
    }
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
      backgroundColor: Colors.black,
      body: Column(

        children: [
          Text(
              listEntries.toString(),
              style: TextStyle(fontSize: 25, color: Colors.white),textAlign: TextAlign.end),
          SizedBox(height: 175,),
          Row(
            children: <Widget>[

              Expanded(
                child: Text(
                  entry,
                  style: TextStyle(fontSize: 100, color: Colors.white),textAlign: TextAlign.end,
                ),
              ),

            ],
          ),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children:  [
              GestureDetector(onTap:() => _handleClear(),child: CircleAvatar(minRadius: 45,child: Text("Clear", style: TextStyle(color: Colors.black,fontSize: 30,fontWeight: FontWeight.bold),),backgroundColor: Colors.grey,)),
              CircleAvatar(minRadius: 45,child: Text("+/-", style: TextStyle(color: Colors.black,fontSize: 30,fontWeight: FontWeight.bold),),backgroundColor: Colors.grey,),
              GestureDetector(onTap:() => _handleUndo(),child: CircleAvatar(minRadius: 45,child: Text("Undo", style: TextStyle(color: Colors.black,fontSize: 30,fontWeight: FontWeight.bold),),backgroundColor: Colors.grey,)),
              GestureDetector(onTap:() => _handleCommands("/"),child: CircleAvatar(minRadius: 45,child: Text("÷", style: TextStyle(color: Colors.black,fontSize: 30,fontWeight: FontWeight.bold),),backgroundColor: Colors.orange,)),
            ],
          ),
          const SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(onTap: () => _handleEntries("7"),child: CircleAvatar(minRadius: 45,child: Text("7", style: TextStyle(color: Colors.black,fontSize: 30,fontWeight: FontWeight.bold),),backgroundColor: Colors.grey,)),
              GestureDetector(onTap:() => _handleEntries("8"),child: CircleAvatar(minRadius: 45,backgroundColor: Colors.grey,child: Text("8", style: TextStyle(color: Colors.black,fontSize: 30,fontWeight: FontWeight.bold),),)),
              GestureDetector(onTap:() => _handleEntries("9"),child: CircleAvatar(minRadius: 45,backgroundColor: Colors.grey,child: Text("9", style: TextStyle(color: Colors.black,fontSize: 30,fontWeight: FontWeight.bold),),)),
              GestureDetector(onTap:() => _handleCommands("*"),child: CircleAvatar(minRadius: 45,child: Text("x", style: TextStyle(color: Colors.black,fontSize: 30,fontWeight: FontWeight.bold),),backgroundColor: Colors.orange,)),
            ],
          ),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(onTap: () => _handleEntries("4"),child: CircleAvatar(minRadius: 45,child: Text("4", style: TextStyle(color: Colors.black,fontSize: 30,fontWeight: FontWeight.bold),),backgroundColor: Colors.grey,)),
              GestureDetector(onTap: () => _handleEntries("5"),child: CircleAvatar(minRadius: 45,child: Text("5", style: TextStyle(color: Colors.black,fontSize: 30,fontWeight: FontWeight.bold),),backgroundColor: Colors.grey,)),
              GestureDetector(onTap: () => _handleEntries("6"),child: CircleAvatar(minRadius: 45,child: Text("6", style: TextStyle(color: Colors.black,fontSize: 30,fontWeight: FontWeight.bold),),backgroundColor: Colors.grey,)),
              GestureDetector(onTap:() => _handleCommands("-"),child: CircleAvatar(minRadius: 45,child: Text("-", style: TextStyle(color: Colors.black,fontSize: 30,fontWeight: FontWeight.bold),),backgroundColor: Colors.orange,)),
            ],
          ),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(onTap: ()=>_handleEntries("1"), child: CircleAvatar(minRadius: 45,child: Text("1", style: TextStyle(color: Colors.black,fontSize: 30,fontWeight: FontWeight.bold),),backgroundColor: Colors.grey,)),
              GestureDetector(onTap: ()=> _handleEntries("2"),child: CircleAvatar(minRadius: 45,child: Text("2", style: TextStyle(color: Colors.black,fontSize: 30,fontWeight: FontWeight.bold),),backgroundColor: Colors.grey,)),
              GestureDetector(onTap:()=> _handleEntries("3"),child: CircleAvatar(minRadius: 45,child: Text("3", style: TextStyle(color: Colors.black,fontSize: 30,fontWeight: FontWeight.bold),),backgroundColor: Colors.grey,)),
              GestureDetector(onTap:() => _handleCommands("+"),child: CircleAvatar(minRadius: 45,child: Text("+", style: TextStyle(color: Colors.black,fontSize: 30,fontWeight: FontWeight.bold),),backgroundColor: Colors.orange,)),
            ],
          ),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(onPressed: ()=> _handleEntries("0"), child: Text("0           ",style: TextStyle(fontSize: 52),),style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(45),
                          side: BorderSide(color: Colors.grey)
                      )
                  )
              ),),
              GestureDetector(onTap:()=> _handleEntries("."),child: CircleAvatar(minRadius: 45,child: Text(",", style: TextStyle(color: Colors.black,fontSize: 30,fontWeight: FontWeight.bold),),backgroundColor: Colors.grey,)),
              GestureDetector(onTap:_handleEnter,child: CircleAvatar(minRadius: 45,child: Text("Enter", style: TextStyle(color: Colors.black,fontSize: 30,fontWeight: FontWeight.bold),),backgroundColor: Colors.orange,)),
            ],
          ),
        ],
      ),
    );
  }
}
abstract class Command<T> {
  T execute(T a, T b);
  T undo(T a, T b);
}

class Addition implements Command<num> {
  num execute(num a, num b) {
    return a + b;
  }
  num undo(num a,num b){
    return a - b;
  }
}

class Subtraction implements Command<num> {
  num execute(num a, num b) {
    return a - b;
  }
  num undo(num a,num b){
    return a + b;
  }
}

class Multiplication implements Command<num> {
  num execute(num a, num b) {
    return a * b;
  }
  num undo(num a,num b){
    return a / b;
  }
}

class Division implements Command<num> {
  num execute(num a, num b) {
    return a / b;
  }
  num undo(num a,num b){
    return a * b;
  }

}

