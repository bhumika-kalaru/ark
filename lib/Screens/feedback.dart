import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Feed extends StatefulWidget {
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<Feed> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  double _rating = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 10,
              ),
              Text(
                'Your Name',
                style: TextStyle(fontSize: 16.0),
              ),
              TextField(
                controller: _nameController,
              ),
              SizedBox(height: 16.0),
              Text(
                'Your Email',
                style: TextStyle(fontSize: 16.0),
              ),
              TextField(
                controller: _emailController,
              ),
              SizedBox(height: 16.0),
              Text(
                'Your Feedback',
                style: TextStyle(fontSize: 16.0),
              ),
              TextField(
                controller: _messageController,
                maxLines: 4,
              ),
              SizedBox(height: 16.0),
              Text(
                'Rating: $_rating',
                style: TextStyle(fontSize: 16.0),
              ),
              Slider(
                value: _rating,
                min: 0,
                max: 5,
                divisions: 5,
                onChanged: (value) {
                  setState(() {
                    _rating = value;
                  });
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                
                onPressed: () {
                  Feedback feedback = Feedback(
                    name: _nameController.text,
                    email: _emailController.text,
                    message: _messageController.text,
                    rating: _rating,
                  );

                  feedback.saveToFirebase().then((_) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Feedback Submitted'),
                          content: Text('Thank you for your feedback!'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Close'),
                            ),
                          ],
                        );
                      },
                    );
                  });
                },
                child: Center(child: Text('Submit')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Feedback {
  final String name;
  final String email;
  final String message;
  final double rating;

  Feedback({
    required this.name,
    required this.email,
    required this.message,
    required this.rating,
  });

  Future<void> saveToFirebase() async {
    try {
      final CollectionReference feedbackCollection =
          FirebaseFirestore.instance.collection('feedback');

      await feedbackCollection.add({
        'name': name,
        'email': email,
        'message': message,
        'rating': rating,
      });
    } catch (e) {
      print('Error saving feedback to Firebase: $e');
    }
  }
}
