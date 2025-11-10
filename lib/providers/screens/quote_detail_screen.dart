import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share_plus/share_plus.dart';
import '../widgets/gradient_background.dart';

class QuoteDetailScreen extends StatelessWidget {
  final String texto;
  final String autor;

  const QuoteDetailScreen({
    super.key,
    required this.texto,
    required this.autor,
  });

  // 📤 Compartir la frase
  void _shareQuote() {
    Share.share('"$texto" — $autor');
  }

  // 📋 Copiar la frase
  void _copyQuote() {
    Clipboard.setData(ClipboardData(text: '"$texto" — $autor'));
    Fluttertoast.showToast(msg: "Frase copiada al portapapeles 📋");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        showOverlay: true,
        overlayOpacity: 0.15,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 🔙 Botón atrás
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),

                // 💬 Contenido principal
                Expanded(
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.deepPurple.withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.format_quote_rounded,
                              size: 60, color: Colors.deepPurple),
                          const SizedBox(height: 16),
                          Text(
                            '"$texto"',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 22,
                              fontStyle: FontStyle.italic,
                              color: Colors.deepPurple,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "- $autor",
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // 🔘 Botones inferiores
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.deepPurple,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      icon: const Icon(Icons.share),
                      label: const Text("Compartir"),
                      onPressed: _shareQuote,
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.deepPurple,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      icon: const Icon(Icons.copy),
                      label: const Text("Copiar"),
                      onPressed: _copyQuote,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
