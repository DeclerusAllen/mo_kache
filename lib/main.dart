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
        leading: TextButton(
          child: Icon(Icons.menu),
          onPressed: (){},
        ),
        actions: [
          Center(child: Text("❤️ $chances  ", style: TextStyle(fontSize: 18))),
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

  // Les 26 lettres en ordre QWERTY
  List<String> lettres = [
  "Q","W","E","R","T","Y","U","I","O","P",
  "A","S","D","F","G","H","J","K","L",
  "Z","X","C","V","B","N","M",
  ];


  // Fonction qui crée la liste des boutons pour le GridView
  List<Widget> getKeyboardButtons() {
    List<Widget> list = [];
    for (int i = 0; i < lettres.length; i++) {
      String letter = lettres[i];
      bool dejaClique = clickedLetters.contains(letter);

      // Couleur selon si la lettre est bonne, mauvaise, ou pas encore cliquée
      Color couleur;
      Color textColor;
      if (!dejaClique) {
        couleur = Colors.white;
        textColor = Colors.black87;
      } else if (word.contains(letter)) {
        couleur = Color(0xFF4CAF50); // Vert = bonne lettre
        textColor = Colors.white;
      } else {
        couleur = Color(0xFFE57373); // Rouge = mauvaise lettre
        textColor = Colors.white;
      }

      list.add(
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: couleur,
            foregroundColor: textColor,
            padding: EdgeInsets.all(0),
            elevation: dejaClique ? 0 : 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: dejaClique ? null : () {
            checkLetter(letter);
          },
          child: Text(letter, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        ),
      );
    }
    return list;
  }

  Widget buildGameScreen() {
    return Column(
      children: [
        SizedBox(height: 30),

        // Le mot caché
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: getHiddenWordWidgets(),
        ),

        SizedBox(height: 10),

        // L'indice
        Text("Endis: $hint", style: TextStyle(fontStyle: FontStyle.italic)),

        Spacer(),

        // Clavier QWERTY avec GridView
        Container(
          height: 200,
          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 5),
          decoration: BoxDecoration(
            color: Color(0xFFE0E0E0),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: GridView.count(
            crossAxisCount: 10,
            mainAxisSpacing: 5,
            crossAxisSpacing: 4,
            childAspectRatio: 0.85,
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
