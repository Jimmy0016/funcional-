import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  static const String _favoritesKey = 'favorite_quotes';

  // Obtener lista de favoritos
  Future<List<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_favoritesKey) ?? [];
  }

  // Agregar a favoritos
  Future<void> addToFavorites(String quoteId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavorites();
    if (!favorites.contains(quoteId)) {
      favorites.add(quoteId);
      await prefs.setStringList(_favoritesKey, favorites);
    }
  }

  // Quitar de favoritos
  Future<void> removeFromFavorites(String quoteId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavorites();
    favorites.remove(quoteId);
    await prefs.setStringList(_favoritesKey, favorites);
  }

  // Verificar si está en favoritos
  Future<bool> isFavorite(String quoteId) async {
    final favorites = await getFavorites();
    return favorites.contains(quoteId);
  }

  // Toggle favorito
  Future<bool> toggleFavorite(String quoteId) async {
    print('Toggling favorite for quote: $quoteId');
    final isFav = await isFavorite(quoteId);
    print('Current favorite status: $isFav');
    if (isFav) {
      await removeFromFavorites(quoteId);
      print('Removed from favorites');
      return false;
    } else {
      await addToFavorites(quoteId);
      print('Added to favorites');
      return true;
    }
  }
}