import 'package:flutter/material.dart';
import 'note_detail_page.dart';
import '../providers/categories_provider.dart';
import '../providers/user_provider.dart';
import '../utils/responsive.dart';
import '../widgets/note_card_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> _notes = [];

  void _onEditNote(int index, Map<String, dynamic> updatedNote) {
    setState(() {
      _notes[index] = {
        'title': updatedNote['title'],
        'category': (updatedNote['categories'] as List).isNotEmpty
            ? updatedNote['categories'][0]
            : 'Tanpa Kategori',
        'content': updatedNote['content'] ?? '',
        'date': DateTime.now().toString().substring(0, 10),
        'color': _notes[index]['color'],
      };
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Catatan berhasil diperbarui'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _onDeleteNote(int index) {
    setState(() {
      _notes.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Catatan dihapus'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _addNewNote() async {
    final result = await Navigator.pushNamed(context, '/add');
    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        _notes.insert(0, {
          'title': result['title'],
          'category': (result['categories'] as List).isNotEmpty
              ? result['categories'][0]
              : 'Tanpa Kategori',
          'content': result['content'] ?? '',
          'date': DateTime.now().toString().substring(0, 10),
          'color': Colors.accents[_notes.length % Colors.accents.length],
        });
      });
    }
  }

  void _changeName() {
    final userProvider = UserProvider.of(context);
    final controller = TextEditingController(text: userProvider.userName);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ubah Nama'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Nama baru',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              final newName = controller.text.trim();
              if (newName.isNotEmpty) {
                userProvider.setUserName(newName);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Nama berhasil diubah')),
                );
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  Widget _buildNoteCard(int index, Map<String, dynamic> note) {
    return NoteCardWidget(
      title: note['title'] ?? '-',
      category: note['category'] ?? 'Tanpa Kategori',
      date: note['date'] ?? '',
      backgroundColor: note['color'],
      onTap: () {
        final categoryProvider = CategoriesProvider.of(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NoteDetailPage(
              note: note,
              index: index,
              onEditNote: _onEditNote,
              onDeleteNote: _onDeleteNote,
              categories: categoryProvider.categories,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = UserProvider.of(context);
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);
    final gridColumns = Responsive.getGridColumns(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hai ${userProvider.userName}!',
                          style: TextStyle(
                            fontSize: isMobile ? 24 : 28,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1F2937),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Siap menulis insight hari ini?',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Color(0xFF6B7280)),
                    onPressed: _changeName,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: isMobile ? double.infinity : 280,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrangeAccent,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.add, color: Colors.white, size: 20),
                  label: const Text(
                    'Tambah Catatan Baru',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onPressed: _addNewNote,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _notes.isEmpty
                    ? const Center(
                  child: Text(
                    "Belum ada catatan.\nTekan tombol di atas untuk menambah!",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
                    : GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: gridColumns,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: isMobile
                        ? 4.0
                        : isTablet ? 1.5 : 3.3,
                  ),
                  itemCount: _notes.length,
                  itemBuilder: (context, index) {
                    return _buildNoteCard(index, _notes[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}