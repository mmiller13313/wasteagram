import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/post.dart';

final detailDateFormat = DateFormat('EEEE, MMM d, y');

class PostDetail extends StatelessWidget {
  const PostDetail({super.key, required this.listing});

  final Post listing;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wasteagram'),
        centerTitle: true,
      ),
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
            Text(detailDateFormat.format(listing.dateTime)),
            Image.network(listing.imageURL),
            Text('Items: ${listing.quantity}'),
            Text('(${listing.latitude}, ${listing.longitude})')
          ])),
    );
  }
}
