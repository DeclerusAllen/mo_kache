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

  List<String> words = [
    "BONJOU",
    "FLUTTER",
    "AYITI",
    "LEKOL",
    "MANJE",
    "DANSE",
    "SOLEIL",
    "ESIH"
  ];

  List<String> hints = [
    "Se yon mo ki itilize pou salye moun",
    "Yon framework pou kreye aplikasyon mobil",
    "Yon peyi nan Karayib la",
    "Kote timoun ale pou aprann",
    "Yon bagay nou fè lè nou grangou",
    "Yon aktivite kote ou bouje kò ou ak mizik",
    "Li klere nan syèl la pandan jounen an",
    "Inivèsite ki pi di nan karayib la",
  ];

  List<String> lettres = [
    "Q","W","E","R","T","Y","U","I","O","P",
    "A","S","D","F","G","H","J","K","L",
    "Z","X","C","V","B","N","M",
  ];

  String word = "";               
  String hint = "";              
  List<String> clickedLetters = []; 
  int chances = 5;          

  @override
  void initState() {
    super.initState();
    choisirMot();
  }

  void choisirMot() {
    var random = Random();
    int index = random.nextInt(words.length);
    word = words[index];
    hint = hints[index];
    clickedLetters = [];
    chances = 5;
  }


  void verifierLettre(String lettre) {
    setState(() {
      clickedLetters.add(lettre);
    });

    if (word.contains(lettre) == false) {
      setState(() {
        chances = chances - 1;
      });
    }

    bool gagne = true;
    for (int i = 0; i < word.length; i++) {
      if (clickedLetters.contains(word[i]) == false) {
        gagne = false;
      }
    }

    if (gagne == true) {
      allerEcranResultat(true);
    }

    if (chances == 0) {
      allerEcranResultat(false);
    }
  }


  void allerEcranResultat(bool victoire) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return ResultScreen(
            victoire: victoire,
            motCorrect: word,
          );
        },
      ),
    );
  }

  List<Widget> afficherMotCache() {
    List<Widget> liste = [];

    for (int i = 0; i < word.length; i++) {
      String caractere = word[i];

      if (clickedLetters.contains(caractere)) {
        liste.add(
          Text(
            caractere + " ",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        );
      }
 
      else {
        liste.add(
          Text(
            "* ",
            style: TextStyle(fontSize: 30, color: Colors.grey),
          ),
        );
      }
    }

    return liste;
  }


  List<String> ligne1 = ["Q","W","E","R","T","Y","U","I","O","P"];
  
  List<String> ligne2 = ["A","S","D","F","G","H","J","K","L"];
 
  List<String> ligne3 = ["Z","X","C","V","B","N","M"];


  List<Widget> creerBoutonsLigne(List<String> lettresLigne) {
    List<Widget> boutons = [];

    for (int i = 0; i < lettresLigne.length; i++) {
      String lettre = lettresLigne[i];
      bool dejaClique = clickedLetters.contains(lettre);

      boutons.add(
        ElevatedButton(
          onPressed: dejaClique ? null : () {
            verifierLettre(lettre);
          },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(0),
          ),
          child: Text(lettre),
        ),
      );
    }

    return boutons;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text("Mo Kache"),
        leading: TextButton(
          child: Icon(Icons.menu),
          onPressed: () {},
        ),
        actions: [
          Row(
            children: [
              Icon(Icons.favorite, color: Colors.red),
              SizedBox(width: 4),
              Text(
                "$chances  ",
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),

      body: SafeArea(
        child: Column(
        children: [

          SizedBox(height: 30),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: afficherMotCache(),
          ),

          SizedBox(height: 15),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Endis: " + hint,
              style: TextStyle(fontStyle: FontStyle.italic, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),

          Spacer(),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2),
            child: Container(
              height: MediaQuery.of(context).size.width / 10,
              child: GridView.count(
                crossAxisCount: 10,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                children: creerBoutonsLigne(ligne1),
              ),
            ),
          ),

          // Ligne 2 : 9 touches (un peu plus étroite)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 18),
            child: Container(
              height: MediaQuery.of(context).size.width / 10,
              child: GridView.count(
                crossAxisCount: 9,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                children: creerBoutonsLigne(ligne2),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 45),
            child: Container(
              height: MediaQuery.of(context).size.width / 10,
              child: GridView.count(
                crossAxisCount: 7,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                children: creerBoutonsLigne(ligne3),
              ),
            ),
          ),

          SizedBox(height: 20),

        ],
        ),
      ),

    );
  }
}



class ResultScreen extends StatelessWidget {

  final bool victoire;
  final String motCorrect;

  ResultScreen({required this.victoire, required this.motCorrect});

  @override
  Widget build(BuildContext context) {
    return Scaffold(


      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Icon(
              victoire ? Icons.emoji_events : Icons.sentiment_dissatisfied,
              size: 80,
              color: victoire ? Colors.green : Colors.red,
            ),

            SizedBox(height: 20),

            Text(
              victoire ? "OU GENYEN! " : "OU PÈDI ",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 20),

            Text(
              "Mo a te: " + motCorrect,
              style: TextStyle(fontSize: 20),
            ),

            SizedBox(height: 40),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return HomeScreen();
                        },
                      ),
                    );
                  },
                  child: Text("REJWE"),
                ),

                SizedBox(width: 20),

                OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("KITE"),
                ),

              ],
            ),

          ],
        ),
      ),

    );
  }
}
