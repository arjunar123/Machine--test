import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class ProductDetailScreen extends StatefulWidget {

  const ProductDetailScreen({Key? key}) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  ProductArguments? product;

  String image = "",
      title = "",
      description = "",
      price = "";
  @override
  Widget build(BuildContext context) {
    product=ModalRoute.of(context)?.settings.arguments as ProductArguments?;
    //product = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(title: const Text("Product Details",)),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(product!.title,style: const TextStyle(fontSize: 20,fontWeight: FontWeight.w900),),
            const SizedBox(height: 10,),
           // Image(image: NetworkImage(product!.image,),height: 300,fit: BoxFit.contain,),
            SizedBox(
              height: 300,
                child: CarouselSlider(

                  options: CarouselOptions(
                    autoPlay: true
                  ),
                  items: product?.imageList
                      .map((item) => Center(child: Image(image: NetworkImage(item),fit: BoxFit.fill,)))
                      .toList(),
                )),
            const SizedBox(height: 20,),
            Text("Description : ${product!.description}",style: const TextStyle(fontSize: 15,fontWeight: FontWeight.w800),),
            const SizedBox(height: 10,),
            Text("Brand : ${product!.brand}",style: const TextStyle(fontSize: 15,fontWeight: FontWeight.w800),),
            const SizedBox(height: 10,),
            Text("Rs ${product!.price}",style: const TextStyle(fontSize: 15,fontWeight: FontWeight.w800),),
            const SizedBox(height: 10,),
          ],
        ),
      ),
    );
  }
}

class ProductArguments {
  String id;
  String title;
  String description;
  String image;
  List<String> imageList;
  String price;
  String brand;

  ProductArguments(
      {required this.id,
      required this.title,
      required this.description,
      required this.image,
        required this.imageList,
      required this.price,
      required this.brand
      });
}
