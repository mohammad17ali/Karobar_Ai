class Record {
  final String id;
  final String pictureUrl;
  final String itemName;
  final int price;
  final int quantity;
  final String category;
  final String itemID;

  Record({
    required this.id,
    required this.pictureUrl,
    required this.itemName,
    required this.price,
    required this.quantity,
    required this.category,
    required this.itemID,
  });

  factory Record.fromJson(Map<String, dynamic> json) {
    final fields = json['fields'];
    return Record(
      id: json['id'],
      pictureUrl: fields['Picture']?.first['url'] ?? '',
      itemName: fields['Item Name'] ?? '',
      price: fields['Price'] ?? 0,
      quantity: fields['Quantity'] ?? 0,
      category: fields['Category'] ?? '',
      itemID: fields['ItemID'] ?? '',
    );
  }
}
