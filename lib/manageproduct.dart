import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'product_mode.dart';

class ManageProductsPage extends StatefulWidget {
  const ManageProductsPage({Key? key}) : super(key: key);

  @override
  State<ManageProductsPage> createState() => _ManageProductsPageState();
}

class _ManageProductsPageState extends State<ManageProductsPage> {
  late Box<Product> productBox;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController puhunanController = TextEditingController();
  final TextEditingController sellingPriceController = TextEditingController();
  final TextEditingController stockController = TextEditingController();
  final TextEditingController soldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    productBox = Hive.box<Product>('products');
  }

  void showProductDialog({int? index}) {
    if (index != null) {
      final product = productBox.getAt(index)!;
      nameController.text = product.name;
      puhunanController.text = product.puhunan.toString();
      sellingPriceController.text = product.sellingPrice.toString();
      stockController.text = product.stock.toString();
      soldController.text = product.sold.toString();
    } else {
      nameController.clear();
      puhunanController.clear();
      sellingPriceController.clear();
      stockController.clear();
      soldController.clear();
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Color(0xFF003366),
        title: Text(
          index == null ? 'Add Product' : 'Edit Product',
          style: const TextStyle(color: Colors.white),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildTextField("Name", nameController),
              buildTextField("Puhunan", puhunanController, isNumber: true),
              buildTextField("Selling Price", sellingPriceController, isNumber: true),
              buildTextField("Stock", stockController, isNumber: true),
              buildTextField("Sold", soldController, isNumber: true),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.white))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 2, 189, 105)),
            onPressed: () {
              if (index == null) {
                productBox.add(Product(
                  name: nameController.text.trim(),
                  puhunan: double.tryParse(puhunanController.text) ?? 0,
                  sellingPrice: double.tryParse(sellingPriceController.text) ?? 0,
                  stock: int.tryParse(stockController.text) ?? 0,
                  sold: int.tryParse(soldController.text) ?? 0,
                ));
              } else {
                final product = productBox.getAt(index)!;
                product.name = nameController.text.trim();
                product.puhunan = double.tryParse(puhunanController.text) ?? 0;
                product.sellingPrice = double.tryParse(sellingPriceController.text) ?? 0;
                product.stock = int.tryParse(stockController.text) ?? 0;
                product.sold = int.tryParse(soldController.text) ?? 0;
                product.save();
              }
              Navigator.pop(context);
            },
            child: Text(index == null ? 'Add' : 'Save'),
          ),
        ],
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller, {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white54),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(255, 0, 159, 71), width: 2),
          ),
        ),
      ),
    );
  }

  void deleteProduct(int index) {
    productBox.deleteAt(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF003366),
      appBar: AppBar(
        title: const Text('Manage Products'),
        backgroundColor: Colors.orange,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 249, 249, 249),
        onPressed: () => showProductDialog(),
        child: const Icon(Icons.add),
      ),
      body: ValueListenableBuilder(
        valueListenable: productBox.listenable(),
        builder: (context, Box<Product> box, _) {
          if (box.isEmpty) {
            return const Center(
              child: Text(
                "No products yet. Tap + to add.",
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
            );
          }
          return LayoutBuilder(
  builder: (context, constraints) {
    int crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;

    final cardColors = [
      Color.fromRGBO(255, 255, 255, 1),
      Color.fromARGB(255, 244, 212, 212),
      Color.fromARGB(255, 141, 236, 245),
      Color.fromARGB(255, 215, 191, 249),
    ];

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 0.9,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: box.length,
      itemBuilder: (context, index) {
        final product = box.getAt(index)!;

        return Container(
          decoration: BoxDecoration(
            color: cardColors[index % cardColors.length],
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Color.fromARGB(255, 196, 183, 6), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                product.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Color.fromARGB(255, 244, 121, 33),
                  letterSpacing: 1.2,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Container(height: 1, color: Colors.black, width: 50),
              const SizedBox(height: 6),
              Text(
                "Puhunan: ₱${product.puhunan}",
                style: const TextStyle(fontSize: 15, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
              Text(
                "Selling Price: ₱${product.sellingPrice}",
                style: const TextStyle(fontSize: 15, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
              Text(
                "Stock: ${product.stock}",
                style: const TextStyle(fontSize: 15, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
              Text(
                "Sold: ${product.sold}",
                style: const TextStyle(fontSize: 15, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),

              // 🔹 Sold Button
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    if (product.stock > 0) {
                      product.stock -= 1;
                      product.sold += 1;
                      product.save();
                    }
                  });
                },
                icon: const Icon(Icons.check_circle, color: Colors.white),
                label: const Text("Sold"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
              ),

              const SizedBox(height: 8),

              // Edit & Delete Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.amber),
                    onPressed: () => showProductDialog(index: index),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () => deleteProduct(index),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  },
);

        },
      ),
    );
  }
}
