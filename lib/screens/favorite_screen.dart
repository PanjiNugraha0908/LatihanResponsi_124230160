import 'package:flutter/material.dart';
import '../models/amiibo_model.dart';
import '../widgets/amiibo_card.dart';
import 'detail_screen.dart';

class FavoriteScreen extends StatefulWidget {
  final List<Amiibo> favoriteAmiibos;
  final Function(String) onFavoriteToggle;
  final bool Function(String) isFavorite;

  const FavoriteScreen({
    Key? key,
    required this.favoriteAmiibos,
    required this.onFavoriteToggle,
    required this.isFavorite,
  }) : super(key: key);

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  late List<Amiibo> _favoriteAmiibos;

  @override
  void initState() {
    super.initState();
    _favoriteAmiibos = List.from(widget.favoriteAmiibos);
  }

  void _removeFavorite(String id, int index) {
    setState(() {
      _favoriteAmiibos.removeAt(index);
    });
    widget.onFavoriteToggle(id);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Berhasil menghapus favorite'),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: _favoriteAmiibos.isEmpty
          ? const Center(
              child: Text(
                'Tidak ada favorit',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _favoriteAmiibos.length,
              itemBuilder: (context, index) {
                final amiibo = _favoriteAmiibos[index];
                return Dismissible(
                  key: Key(amiibo.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  onDismissed: (direction) {
                    _removeFavorite(amiibo.id, index);
                  },
                  child: AmiiboCard(
                    amiibo: amiibo,
                    isFavorite: true,
                    onFavoriteToggle: () => _removeFavorite(amiibo.id, index),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(
                            amiibo: amiibo,
                            isFavorite: widget.isFavorite(amiibo.id),
                            onFavoriteToggle: () {
                              widget.onFavoriteToggle(amiibo.id);
                              setState(() {
                                _favoriteAmiibos = _favoriteAmiibos
                                    .where((a) => widget.isFavorite(a.id))
                                    .toList();
                              });
                            },
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}