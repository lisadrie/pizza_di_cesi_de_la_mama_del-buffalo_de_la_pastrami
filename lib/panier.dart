import 'package:flutter/material.dart';
import 'package:pizzas/pizza.dart';

class Panier extends ChangeNotifier {
  final List<Pizza> _articles = [];

  List<Pizza> get articles => _articles;

  void ajouterAuPanier(Pizza pizza) {
    _articles.add(pizza); 
  notifyListeners();
  }

  void viderPanier() {
    _articles.clear();
    notifyListeners();
  }
  int nombreDePizzasDansPanier(Pizza pizza) {
  int count = 0;
  for (var article in _articles) {
    if (article == pizza) {
      count++;
    }
  }
  return count;
}
}
