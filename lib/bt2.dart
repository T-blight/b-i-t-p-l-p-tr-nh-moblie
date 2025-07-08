import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Model sản phẩm
class Product {
  final String name;
  final String image;
  final double price;
  final String description;

  Product({
    required this.name,
    required this.image,
    required this.price,
    required this.description,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'] ?? '',
      image: json['imgURL'] ?? '',
      price: json['price'] ?? '',
      description: json['des'] ?? '',
    );
  }
}

// Hàm gọi API
Future<Product> fetchProduct() async {
  final response = await http.get(Uri.parse(
      'https://mock.apidog.com/m1/890655-872447-default/v2/product'));

  if (response.statusCode == 200) {
    print(Product.fromJson(jsonDecode(response.body)).image);
    return Product.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load product');
  }
}

// UI chính
void main() {
  runApp(const MaterialApp(home: ProductScreen()));
}

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product Detail')),
      body: FutureBuilder<Product>(
        future: fetchProduct(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final product = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(product.image, height: 300),
                  const SizedBox(height: 16),
                  Text(
                    product.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Giá: ${product.price}",
                    style: const TextStyle(color: Colors.red, fontSize: 20),
                  ),
                  const SizedBox(height: 16),
                  Text(product.description),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
