import "package:flutter/material.dart";
import "dart:math";

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<String> words = ["BONJOU", "FLUTTER", "AYITI", "LEKOL", "MANJE"];
  List<String> hints = ["Salitasyon", "App Mobile", "Peyi nou", "Edikasyon", "Nouri vant"];
  
  String word = "";
  String hint = "";
  List<String> clickedLetters = [];
  int chances = 5;
  bool gameOver = false;
  String message = "";

  @override
  void initState() {
    super.initState();
    startNewGame();
  }

  void startNewGame() {
    setState(() {
      int index = Random().nextInt(words.length);
      word = words[index];
      hint = hints[index];
      clickedLetters = [];
      chances = 5;
      gameOver = false;
      message = "";
    });
  }

  void checkLetter(String letter) {
    if (gameOver) return; 

    setState(() {
      clickedLetters.add(letter);

      if (!word.contains(letter)) {
        chances = chances - 1; 
      }
    });

    bool won = true;
    for (int i = 0; i < word.length; i++) {
      if (!clickedLetters.contains(word[i])) {
        won = false;
      }
    }

    if (won) {
      setState(() {
        gameOver = true;
        message = "OU GENYEN!";
      });
    } else if (chances == 0) {
      setState(() {
        gameOver = true;
        message = "OU PÈDI... \nMo a te: $word";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mo Kache"),
        backgroundColor: Colors.blue,
        leading: TextButton(
          child: Icon(Icons.menu, color: Colors.white),
          onPressed: (){},
        ),
        actions: [
          Center(child: Text("$chances  ", style: TextStyle(fontSize: 18))),
          IconButton(icon: Icon(Icons.settings), onPressed: (){}),
          IconButton(icon: Icon(Icons.more_vert), onPressed: (){}),
        ],
      ),

      body: gameOver ? buildResultScreen() : buildGameScreen(),

      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.checklist), label: "Chek List"),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.contact_support), label: "Contact"),
        ]
      ),
    );
  }


  List<Widget> getHiddenWordWidgets() {
    List<Widget> list = [];
    for (int i = 0; i < word.length; i++) {
        String char = word[i];
        if (clickedLetters.contains(char)) {
            list.add(Text(char + " ", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)));
        } else {
            list.add(Text("* ", style: TextStyle(fontSize: 30, color: Colors.grey)));
        }
    }
    return list;
  }

  List<Widget> getKeyboardButtons() {
    List<Widget> list = [];
    String alphabet = "QWERTYUIOPASDFGHJKLZXCVBNM";

    for (int i = 0; i < alphabet.length; i++) {
        String letter = alphabet[i];
        list.add(
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                   backgroundColor: Colors.blueAccent, 
                   foregroundColor: Colors.white,
                   padding: EdgeInsets.zero
                ),
                // Si la lettre est cliquée, on désactive le bouton (null)
                onPressed: clickedLetters.contains(letter) ? null : () {
                    checkLetter(letter);
                },
                child: Text(letter),
            )
        );
    }
    return list;
  }

  Widget buildGameScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 20),
        
        Row(
            mainAxisAlignment: MainAxisAlignment.center,

            children: getHiddenWordWidgets(),
        ),

        SizedBox(height: 10),
        Text("Endis: $hint", style: TextStyle(fontStyle: FontStyle.italic)),

        Spacer(), 

        Container(
            height: 400, 
            padding: EdgeInsets.all(10),
            child: GridView.count(
                crossAxisCount: 7, 
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
                children: getKeyboardButtons(),
            ),
        ),
      ],
    );
  }


  Widget buildResultScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message, 
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold), 
            textAlign: TextAlign.center
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: startNewGame,
            child: Text("REKÒMANSE"),
          )
        ],
      ),
    );
  }
}
