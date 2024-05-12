import 'package:flutter/material.dart';

class breaking extends StatefulWidget {
  const breaking({super.key});

  @override
  State<breaking> createState() => _breakingState();
}

class _breakingState extends State<breaking> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: 30,
        itemBuilder:(context,index){
          return ListTile(
            leading: Container(
              color: Colors.grey,
            ),
            title: Text("Breaking News"),
          );
        }
    );
  }
}
