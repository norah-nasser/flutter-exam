import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() => runApp(const MaterialApp(home: LoginScreen(), debugShowCheckedModeBanner: false));

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const TextField(decoration: InputDecoration(labelText: "Email")),
            const TextField(decoration: InputDecoration(labelText: "Password"), obscureText: true),
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ProductsScreen())),
              child: const Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  Future<List> getData() async {
    var res = await http.get(Uri.parse('https://dummyjson.com/products'));
    return json.decode(res.body)['products'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Products")),
      body: FutureBuilder<List>(
        future: getData(),
        builder: (context, snap) {
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          return ListView.builder(
            itemCount: snap.data!.length,
            itemBuilder: (context, i) {
              var p = snap.data![i];
              return ListTile(
                leading: Image.network(p['thumbnail'], width: 50),
                title: Text(p['title']),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Details(p: p))),
              );
            },
          );
        },
      ),
    );
  }
}

class Details extends StatelessWidget {
  final dynamic p;
  const Details({super.key, this.p});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(p['title'])),
      body: Column(
        children: [
          SizedBox(height: 200, child: PageView.builder(itemCount: p['images'].length, itemBuilder: (context, i) => Image.network(p['images'][i]))),
          Text(p['title'], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text("Price: \$${p['price']}"),
          Text(p['description']),
        ],
      ),
    );
  }
}