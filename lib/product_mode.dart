import 'package:hive/hive.dart';

part 'product_mode.g.dart';

@HiveType(typeId: 0)
class Product extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  double puhunan; // investment price per piece

  @HiveField(2)
  double sellingPrice; // selling price per piece

  @HiveField(3)
  int stock; // total pieces in stock

  @HiveField(4)
  int sold; // total pieces sold

  Product({
    required this.name,
    required this.puhunan,
    required this.sellingPrice,
    required this.stock,
    this.sold = 0,
  });

  double get totalSales => sellingPrice * sold;

  double get totalProfit => sellingPrice * sold - puhunan;

  int get remainingStock => stock - sold;
}
