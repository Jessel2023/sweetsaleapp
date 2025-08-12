import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'manageproduct.dart';
import 'product_mode.dart'; // Hive model

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  double totalSales = 0;
  double totalProfit = 0;
  int totalProducts = 0;

  List<Map<String, dynamic>> productStats = [];

  @override
  void initState() {
    super.initState();
    _calculateStats();
  }

  void _calculateStats() {
    var box = Hive.box<Product>('products');
    double sales = 0;
    double profit = 0;
    int productCount = 0;

    List<Map<String, dynamic>> tempList = [];

    for (var product in box.values) {
      double productSales = product.totalSales;
      double productProfit = product.totalProfit;

      sales += productSales;
      profit += productProfit;
      productCount++;

      tempList.add({
        "name": product.name,
        "sales": productSales,
        "profit": productProfit,
      });
    }

    setState(() {
      totalSales = sales;
      totalProfit = profit;
      totalProducts = productCount;
      productStats = tempList;
    });
  }

  Widget statCard(String label, String value, {double size = 90}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.yellow, width: 4),
      ),
      child: Center(
        child: Text(
          "$label\n$value",
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF003366),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              "Welcome to Dashboard",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Image.asset(
              'assets/logo.png',
              width: 120,
              height: 120,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 10),
            const Text(
              "Sweet Sales",
              style: TextStyle(
                fontFamily: 'Cursive',
                fontSize: 26,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),

            // Three stat circles in one row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Center(
                      child: statCard(
                        "Total Sales",
                        "₱${totalSales.toStringAsFixed(2)}",
                        size: 90,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: statCard(
                        "Products",
                        "$totalProducts",
                        size: 90,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: statCard(
                        "Total Profit",
                        "₱${totalProfit.toStringAsFixed(2)}",
                        size: 90,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Expandable section for scrolling content
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Product Sales and Profit",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 2,
                          crossAxisSpacing: 4,
                          mainAxisSpacing: 4,
                        ),
                        itemCount:
                            productStats.length > 4 ? 4 : productStats.length,
                        itemBuilder: (context, index) {
                          final product = productStats[index];
                          return Container(
                            decoration: BoxDecoration(
                              color: index % 2 == 0
                                  ? Color.fromARGB(255, 17, 53, 71)
                                  : Color.fromARGB(255, 0, 49, 48),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: Color.fromARGB(255, 253, 169, 1), // Border color
                                width: 1.5,     ),       // Border thickness
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    product["name"],
                                    style: const TextStyle(
                                      color: Color.fromARGB(221, 255, 255, 255),
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "₱${product["sales"].toStringAsFixed(2)}",
                                    style: const TextStyle(
                                      color: Color.fromARGB(221, 255, 255, 255),
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    "₱${product["profit"].toStringAsFixed(2)} profit",
                                    style: const TextStyle(
                                      color: Color.fromARGB(137, 245, 245, 245),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 30),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ManageProductsPage()),
                            ).then((_) => _calculateStats());
                          },
                          child: const Text(
                            "Manage Product",
                            style: TextStyle(
                              fontSize: 18,
                              color: Color.fromARGB(255, 250, 243, 255),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
