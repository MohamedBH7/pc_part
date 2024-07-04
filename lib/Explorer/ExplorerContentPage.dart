import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pc_part/CategoryPage/DetailsPage.dart';
import 'package:pc_part/config.dart';

class ExplorerContentPage extends StatefulWidget {
  final String userID;

  const ExplorerContentPage({required this.userID});

  @override
  _ExplorerContentPageState createState() => _ExplorerContentPageState();
}

class _ExplorerContentPageState extends State<ExplorerContentPage> {
  late List<Product> _products = []; // Initialize _products with an empty list
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    final response = await http.get(Uri.parse('${Config.apiBaseUrl}/server/explorer.php'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      setState(() {
        _products = (jsonData as List)
            .map((item) => Product.fromJson(item))
            .toList();
      });
    } else {
      throw Exception('Failed to load products');
    }
  }

  void _performSearch(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  List<Product> _filterProducts() {
    final lowerCaseQuery = _searchQuery.toLowerCase();
    return _products.where((product) =>
    product.name.toLowerCase().contains(lowerCaseQuery) ||
        product.category.toLowerCase().contains(lowerCaseQuery)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Explorer'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: _performSearch,
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: ImageIcon(
                  AssetImage('lib/assets/search.png'),
                ),
                border: OutlineInputBorder(),
              ),
            ),
          ),

          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              itemCount: _filterProducts().length,
              itemBuilder: (context, index) {
                final product = _filterProducts()[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailsPage(
                          category: product.category,
                          description: product.description,
                          imageURL: product.imageUrl,
                          price: product.price.toString(),
                          review: product.review,
                          quantityAvailable: product.quantityAvailable,
                          name: product.name,
                          itemID: product.itemID,
                          userID: widget.userID,
                        ),
                      ),
                    );
                  },
                  child: ProductTile(
                    product: product,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Product {
  final String name;
  final String imageUrl;
  final double price;
  final String description;
  final String category;
  final String review;
  final String quantityAvailable;
  final String itemID;

  Product({
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.description,
    required this.category,
    required this.review,
    required this.quantityAvailable,
    required this.itemID,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['Name'],
      imageUrl: json['ImageURL'],
      price: double.parse(json['Price']),
      description: json['Description'],
      category: json['Category'],
      review: json['review'],
      quantityAvailable: json['QuantityAvailable'],
      itemID: json['ItemID'],
    );
  }
}

class ProductTile extends StatelessWidget {
  final Product product;

  const ProductTile({required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
