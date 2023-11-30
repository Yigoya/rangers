import 'package:flutter/material.dart';

Widget button(void Function() onTop) {
  return GestureDetector(
    onTap: onTop,
    child: const Text("click"),
  );
}

Widget textfield(TextEditingController controller, String hint) {
  return Container(
    height: 100,
    margin: const EdgeInsets.all(10),
    padding: const EdgeInsets.symmetric(horizontal: 20),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.black.withOpacity(0.1)),
    child: TextField(
      controller: controller,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      decoration: InputDecoration(
        hintText: hint,
        border: InputBorder.none,
      ),
    ),
  );
}

Widget searchBar(String hint) {
  return Container(
    padding: const EdgeInsets.only(left: 20),
    decoration: BoxDecoration(
        color: Colors.grey.shade300, borderRadius: BorderRadius.circular(100)),
    width: double.infinity,
    height: 50,
    child: Row(
      children: [
        const Icon(
          Icons.search,
        ),
        const SizedBox(
          width: 10,
        ),
        SizedBox(
            width: 300,
            height: 40,
            child: TextField(
              decoration:
                  InputDecoration(border: InputBorder.none, hintText: hint),
            ))
      ],
    ),
  );
}

class ButtonWidget extends StatelessWidget {
  final IconData icon;
  final VoidCallback onClicked;
  const ButtonWidget({super.key, required this.onClicked, required this.icon});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        icon,
        color: const Color.fromARGB(255, 54, 49, 5),
      ),
      onPressed: onClicked,
    );
  }
}
