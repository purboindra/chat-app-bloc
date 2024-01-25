import 'dart:developer';

import 'package:chat_app/main.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, dynamic>> _chats = [];

  bool _isLoading = false;

  @override
  void initState() {
    _fetchAllMessages();
    super.initState();
  }

  void _fetchAllMessages() async {
    setState(() {
      _isLoading = true;
    });
    final response = await homeRepository.fetchAllMessages();
    _chats.addAll(response);

    _isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator.adaptive(),
              )
            : Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: _chats.length,
                        itemBuilder: (context, index) {
                          log("${_chats[index]}");
                          return Text("${_chats[index]}");
                        },
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
