import 'package:chat_app/features/homepage/presentation/ui/components/usercard.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade500,
        leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomePage(),
                  ));
            },
            icon: const Icon(Icons.home)),
        title: const Text('Chat App'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
        elevation: 0.8,
      ),
      body: ListView.builder(
        itemCount: 16,
        padding: const EdgeInsets.only(top: 10),
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return const UserCard();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.green.shade500,
        child: const Icon(Icons.phone),
      ),
    );
  }
}
