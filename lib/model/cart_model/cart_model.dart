class CartItems {
  String Category;
  String Description;
  String ImageURL;
  String Price;
  String Review;
  String QuantityAvailable;
  String ItemID;
  String UserID ;
  String Quantity;
  String Name;


  CartItems({
    required this.Category,
    required this.Description,
    required this.ImageURL,
    required this.Price,
    required this.Review,
    required this.QuantityAvailable,
    required this.UserID,
    required this.ItemID,
    required this.Quantity,
    required this.Name,

  });
   Map<String, dynamic>toJson() => {};
}
