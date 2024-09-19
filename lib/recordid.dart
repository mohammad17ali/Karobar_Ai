class Record {
  final String id;
  final String pictureUrl;
  final String itemName;
  final int price;
  final int quantity;
  final String category;
  final String itemID;
  bool isInOrderSummary;

  Record({
    required this.id,
    required this.pictureUrl,
    required this.itemName,
    required this.price,
    required this.quantity,
    required this.category,
    required this.itemID,
    this.isInOrderSummary = false,
  });

  // Factory constructor to create a Record object from a JSON map
  factory Record.fromJson(Map<String, dynamic> json) {
    final fields = json['fields'] ?? {};

    return Record(
      id: json['id'] ?? '', // Ensure the ID is not null
      pictureUrl: (fields['Picture'] != null && fields['Picture'].isNotEmpty)
          ? fields['Picture'].first['url']
          : '', // Handle null or empty pictures
      itemName: fields['Item Name'] ?? '', // Default to an empty string
      price: fields['Price'] ?? 0, // Default to 0 if price is missing
      quantity: fields['Quantity'] ?? 0, // Default to 0 if quantity is missing
      category: fields['Category'] ?? '', // Default to an empty string
      itemID: fields['ItemID'] ?? '', // Default to an empty string
    );
  }

  // Optional: Method to convert Record back to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fields': {
        'Picture': [
          {'url': pictureUrl}
        ],
        'Item Name': itemName,
        'Price': price,
        'Quantity': quantity,
        'Category': category,
        'ItemID': itemID,
      },
    };
  }

  // Method to create a copy of the Record with updated values
  Record copyWith({
    String? id,
    String? pictureUrl,
    String? itemName,
    int? price,
    int? quantity,
    String? category,
    String? itemID,
  }) {
    return Record(
      id: id ?? this.id,
      pictureUrl: pictureUrl ?? this.pictureUrl,
      itemName: itemName ?? this.itemName,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      category: category ?? this.category,
      itemID: itemID ?? this.itemID,
    );
  }
}
