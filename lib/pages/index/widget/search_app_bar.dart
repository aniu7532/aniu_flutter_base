import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

class SearchAppbar extends StatefulWidget {
  SearchAppbar({required this.onSearchTextChanged, super.key});

  ValueChanged<String> onSearchTextChanged;

  @override
  _SearchAppbarState createState() => _SearchAppbarState();
}

class _SearchAppbarState extends State<SearchAppbar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      widget.onSearchTextChanged.call(_controller.text);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 14,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.grey[200],
          ),
          child: TextField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: '搜索...',
              border: InputBorder.none,
              icon: Icon(Icons.search),
            ),
          ),
        ),
      ],
    );
  }
}
