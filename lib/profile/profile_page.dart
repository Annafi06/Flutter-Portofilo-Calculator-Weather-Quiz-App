import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background_image.jpg"), // Replace with your image path
            fit: BoxFit.cover,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/profile_photo.jpg'),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Abdun Nafi Annafi',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Hello, I am your regular CSE student trying to get through the ups and downs of life.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.email, color: Colors.blueAccent),
                        const SizedBox(width: 8),
                        Text(
                          'nafi15-14755@diu.edu.bd',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(Icons.phone, color: Colors.blueAccent),
                        const SizedBox(width: 8),
                        Text(
                          '+8801735205584',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Personal Information
            Text(
              'Personal Information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            // Input fields for personal information
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Name',
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Bio',
                filled: true,
                fillColor: Colors.white,
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 8),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Email',
                filled: true,
                fillColor: Colors.white,
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 8),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Phone',
                filled: true,
                fillColor: Colors.white,
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            // Social Media Links section
            Text(
              'Social Media Links',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: Icon(Icons.link, color: Colors.blue),
              title: Text(
                'LinkedIn',
                style: TextStyle(color: Colors.blue),
              ),
              onTap: () {
                _launchURL('https://www.linkedin.com/in/annafi/');
              },
            ),
            ListTile(
              leading: Icon(Icons.link, color: Colors.blue),
              title: Text(
                'Facebook',
                style: TextStyle(color: Colors.blue),
              ),
              onTap: () {
                _launchURL('https://www.facebook.com/a.n.annafi06/');
              },
            ),
            ListTile(
              leading: Icon(Icons.link, color: Colors.blue),
              title: Text(
                'GitHub',
                style: TextStyle(color: Colors.blue),
              ),
              onTap: () {
                _launchURL('https://github.com/Annafi06');
              },
            ),
            // Add more social media links as needed
          ],
        ),
      ),
    );
  }

  // Function to launch URLs
  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
