import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pizzas/panier.dart';
import 'package:pizzas/panier_view.dart';
import 'package:pizzas/signin_signup.dart';
import 'package:provider/provider.dart';
import 'package:pizzas/pizza.dart';
import 'package:go_router/go_router.dart';


// GoRouter configuration
final _router = GoRouter(
  routes: [ 
    GoRoute(
      path: '/',
      builder: (context, state) => const SignupCard(),
    ),
    GoRoute(
      path: '/connexion',
      builder: (context, state) => const LoginCard(),
    ),
    GoRoute(
      path: '/panier',
      builder: (context, state) => const PanierView(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const Home(),
    ),
  ],
);

Future<void> main() async {
  runApp(
    ChangeNotifierProvider(
      create: (context) => Panier(),
      child: MaterialApp.router(
        routerConfig: _router,
      ),
    ),
  );
}

class Home extends StatelessWidget {
  const Home({super.key});
  


  Future<List<Pizza>?> fetchPizzas() async {
    const String apiURL = 'https://pizzas.shrp.dev/items/pizzas/';
    final response = await Dio().get(apiURL);

    return response.data["data"]
        .map<Pizza>((json) => Pizza.fromJson(json))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    int nombreDePizzas =0;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pizza Menu'),
      ),
      body: Center(
        child: Column(
          children: [
            IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                context.go("/panier");
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => const PanierView(),
                //   ),
                // );
              },
            ),
            Expanded(
              child: FutureBuilder(
                future: fetchPizzas(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text("Error"));
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Image.network(
                            'https://pizzas.shrp.dev/assets/${snapshot.data![index].image}',
                            width: 50,
                            height: 50,
                          ),
                          title: Text(snapshot.data![index].name),
                          subtitle: Text(
                            'Price: \$${snapshot.data![index].price.toString()}',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  final panier = Provider.of<Panier>(context, listen: false);
                                  panier.ajouterAuPanier(snapshot.data![index]);
                                  nombreDePizzas = panier.nombreDePizzasDansPanier(snapshot.data![index]);
                                },
                                child: Text("Ajouter (x$nombreDePizzas)"),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(
                                            "La ${snapshot.data![index].name}"),
                                        content: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Text(
                                              "Ingrédients :",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            for (var ingredient in snapshot
                                                .data![index].ingredients)
                                              Text('- $ingredient'),
                                          ],
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Fermer'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: const Text('Détails'),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
