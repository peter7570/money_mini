import 'package:flutter/material.dart';

class SubcategoryNoteScreen extends StatefulWidget {
  final Map<String, dynamic> category;

  const SubcategoryNoteScreen({super.key, required this.category});

  @override
  State<SubcategoryNoteScreen> createState() => _SubcategoryNoteScreenState();
}

class _SubcategoryNoteScreenState extends State<SubcategoryNoteScreen> {
  final TextEditingController _noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final icon = widget.category['icon'] ?? Icons.category;
    final color = widget.category['color'] ?? Colors.grey;
    final label = widget.category['label'] ?? 'Category';

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: BackButton(color: Colors.white),
        title: const Text('Add Note', style: TextStyle(color: Colors.white)),
        actions: const [Icon(Icons.swap_vert, color: Colors.white), SizedBox(width: 16)],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: color,
                  child: Icon(icon, color: Colors.black),
                ),
                const SizedBox(width: 12),
                Text(label, style: const TextStyle(color: Colors.white, fontSize: 18)),
              ],
            ),
            const SizedBox(height: 20),
            const Text('Comment', style: TextStyle(color: Colors.white)),
            const SizedBox(height: 8),
            TextField(
              controller: _noteController,
              maxLines: 5,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Write something...',
                hintStyle: TextStyle(color: Colors.white24),
                filled: true,
                fillColor: Color(0xFF1A1A1A),
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                final note = _noteController.text.trim();
                Navigator.pop(context, note);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF7FF5C),
                minimumSize: const Size.fromHeight(52),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
              ),
              child: const Text('Continue', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
