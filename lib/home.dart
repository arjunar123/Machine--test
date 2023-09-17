import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:productapp/product_details.dart';

import 'Model/product.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isLoading = true;
  List<Product> _products = <Product>[];
  List<Product> _productsDisplay = <Product>[];

  @override
  void initState() {
    super.initState();
    _getProduct().then((value) {
      setState(() {
        _isLoading = false;
        _products = _productsDisplay;
      });
    });
  }

  ItemModel? item;
  _getProduct() async {
    try {
      String url = "https://dummyjson.com/products";
      http.Response res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        item = ItemModel.fromJson(json.decode(res.body));
        _productsDisplay = item!.products;
        _isLoading = false;
        setState(() {});
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  _searchBar() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextField(
        autofocus: false,
        onChanged: (searchText) {
          searchText = searchText.toLowerCase();
          setState(() {
            _productsDisplay = _products.where((product) {
              var pTitle = product.title.toLowerCase();
              var pBrand = product.brand.toLowerCase();
              return pTitle.contains(searchText) || pBrand.contains(searchText);
            }).toList();
          });
        },
        // controller: _textController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.search),
          hintText: 'Search products',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _searchBar()
      ),

      body: _isLoading
          ? const LoadingView()
          : ListView.builder(
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return

                    ProductItem(productItem: _productsDisplay[index]);
              },
              itemCount: _productsDisplay.length,
            ),
    );
  }
}

class ProductItem extends StatelessWidget {
  final Product productItem;
  const ProductItem({Key? key, required this.productItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, "/prodetail",
            arguments: ProductArguments(
                id: productItem.id.toString(),
                title: productItem.title,
                description: productItem.description,
                image: productItem.thumbnail,
                price: productItem.price.toString(),
                imageList: productItem.images,
                brand: productItem.brand));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.network(
              productItem.thumbnail,
              width: 100,
            ),
            const SizedBox(width: 5,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productItem.title.toString(),
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Brand :- ${productItem.brand}",
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 15),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    productItem.description,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.2,
        ),
        Container(
          child: Lottie.asset('assets/loading.json'),
        ),
        const Text(
          'Loading ...',
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
      ],
    );
  }
}
