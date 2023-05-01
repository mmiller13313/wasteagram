class Post {
  DateTime dateTime;
  String imageURL;
  int quantity;
  double latitude;
  double longitude;

  Post(
      {DateTime? dateTime,
      this.imageURL = 'none',
      this.quantity = 0,
      this.latitude = 0.0,
      this.longitude = 0.0})
      : this.dateTime = dateTime ?? DateTime.now();

  factory Post.fromFirestore(Map<String, dynamic> json) {
    return Post(
        dateTime: json['dateTime'].toDate(),
        imageURL: json['imageURL'],
        quantity: json['quantity'],
        latitude: json['latitude'],
        longitude: json['longitude']);
  }

  @override
  String toString() {
    return 'DateTime: $dateTime, ImageURL: $imageURL, Quantity: $quantity, Latitude: $latitude, Longitude: $longitude';
  }

  Map<String, dynamic> toFirestore() {
    return {
      "dateTime": dateTime,
      "imageURL": imageURL,
      "quantity": quantity,
      "latitude": latitude,
      "longitude": longitude
    };
  }
}
