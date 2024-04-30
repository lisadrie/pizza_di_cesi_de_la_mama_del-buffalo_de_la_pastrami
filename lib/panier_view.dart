import 'package:flutter/material.dart';
import 'package:pizzas/panier.dart';
import 'package:pizzas/pizza.dart';
import 'package:provider/provider.dart';

class PanierView extends StatelessWidget {
  const PanierView({super.key}); 

  @override
  Widget build(BuildContext context) {
    final panier = Provider.of<Panier>(context); 
    final Map<Pizza, int> pizzaCount = {};
    for (var pizza in panier.articles) {
      pizzaCount.update(pizza, (value) => value + 1, ifAbsent: () => 1);
    }

    double total = 0;
    for (var entry in pizzaCount.entries) {
      total += entry.key.price * entry.value;
    }


    return Scaffold(
      appBar: AppBar(
        title: const Text('Panier'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Nombre de pizzas différentes dans le panier : ${pizzaCount.length}"),
            Text('Total: \$${total.toStringAsFixed(2)}'),
            Expanded(
              child: ListView.builder(
                itemCount: pizzaCount.length,
                itemBuilder: (context, index) {
                  final pizza = pizzaCount.keys.toList()[index];
                  final count = pizzaCount[pizza]!;
                  return ListTile(
                    title: Text('${pizza.name} (x$count)'),
                    subtitle: Text('Price: \$${pizza.price.toString()}'),
                     
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
