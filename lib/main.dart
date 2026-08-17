import 'package:flutter/material.dart';

void main() {
  runApp(const CrowdfundingProApp());
}

class CrowdfundingProApp extends StatelessWidget {
  const CrowdfundingProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const LiveScreen(),
    );
  }
}

class LiveScreen extends StatefulWidget {
  const LiveScreen({super.key});

  @override
  State<LiveScreen> createState() => _LiveScreenState();
}

class _LiveScreenState extends State<LiveScreen> {
  // Datos de la campaña
  final int targetCoins = 10000;
  int currentCoins = 0;
  String lastDonor = "";
  int lastAmount = 0;

  // Ranking de donantes
  Map<String, int> leaderboard = {};

  void addDonation(String username, int coins) {
    setState(() {
      currentCoins += coins;
      lastDonor = username;
      lastAmount = coins;
      leaderboard[username] = (leaderboard[username] ?? 0) + coins;
    });

    // Cartel flotante de agradecimiento
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.pinkAccent,
        duration: const Duration(seconds: 2),
        content: Text(
          "🎁 ¡$username donó $coins monedas! ❤️ ¡Gracias por el apoyo!",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double progress = (currentCoins / targetCoins).clamp(0.0, 1.0);
    var sortedLeaderboard = leaderboard.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // --- VISTA DE LA CAMPAÑA (PARA EL LIVE) ---
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.pinkAccent, width: 2),
                ),
                child: Column(
                  children: [
                    const Text(
                      "❤️ AYUDEMOS A DON PEDRO",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const Text("Recaudemos para su almuerzo de hoy", style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 15),

                    // BARRA DE PROGRESO ANIMADA
                    TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                      tween: Tween<double>(begin: 0, end: progress),
                      builder: (context, value, child) => Column(
                        children: [
                          LinearProgressIndicator(
                            value: value,
                            minHeight: 25,
                            backgroundColor: Colors.grey[800],
                            color: Colors.pinkAccent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "$currentCoins / $targetCoins 🪙",
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.yellowAccent),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // --- RANKING TOP 3 ---
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: Cross.start,
                  children: [
                    const Text("🏆 TOP COLABORADORES", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber)),
                    const Divider(color: Colors.grey),
                    if (sortedLeaderboard.isEmpty)
                      const Text("Sé el primero en colaborar", style: TextStyle(color: Colors.grey)),
                    ...sortedLeaderboard.take(3).map((entry) {
                      int index = sortedLeaderboard.indexOf(entry) + 1;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("$index. @${entry.key}", style: const TextStyle(fontSize: 16, color: Colors.white)),
                            Text("${entry.value} 🪙", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.yellowAccent)),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),

              const Spacer(),

              // --- PANEL SIMULADOR (PARA PROBAR) ---
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blueGrey[900],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    const Text("🎮 Panel de Pruebas", style: TextStyle(fontSize: 12, color: Colors.white54)),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () => addDonation("Maria", 100),
                          child: const Text("+100 Maria"),
                        ),
                        ElevatedButton(
                          onPressed: () => addDonation("Carlos", 500),
                          child: const Text("+500 Carlos"),
                        ),
                        ElevatedButton(
                          onPressed: () => addDonation("Juan", 1000),
                          child: const Text("+1000 Juan"),
                        ),
                      ],
                    ),
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
