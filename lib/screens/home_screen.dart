import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/amiibo_model.dart';
import '../services/api_service.dart';
import '../widgets/amiibo_card.dart';
import 'detail_screen.dart';
import 'favorite_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  List<Amiibo> _amiibos = [];
  List<String> _favoriteIds = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
    _fetchAmiibos();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _favoriteIds = prefs.getStringList('favorites') ?? [];
    });
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favorites', _favoriteIds);
  }

  Future<void> _fetchAmiibos() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final amiibos = await ApiService.getAllAmiibos();
      setState(() {
        _amiibos = amiibos;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  void _toggleFavorite(String id) {
    setState(() {
      if (_favoriteIds.contains(id)) {
        _favoriteIds.remove(id);
      } else {
        _favoriteIds.add(id);
      }
    });
    _saveFavorites();
  }

  bool _isFavorite(String id) {
    return _favoriteIds.contains(id);
  }

  List<Amiibo> get _favoriteAmiibos {
    return _amiibos.where((amiibo) => _favoriteIds.contains(amiibo.id)).toList();
  }

  void _onItemTapped(int index) {
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FavoriteScreen(
            favoriteAmiibos: _favoriteAmiibos,
            onFavoriteToggle: _toggleFavorite,
            isFavorite: _isFavorite,
          ),
        ),
      ).then((_) => setState(() {}));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nintendo Amiibo List'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildAmiiboList(_amiibos),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: '',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }

  Widget _buildAmiiboList(List<Amiibo> amiibos) {
    if (amiibos.isEmpty) {
      return const Center(
        child: Text(
          'Tidak ada data',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: amiibos.length,
      itemBuilder: (context, index) {
        final amiibo = amiibos[index];
        return AmiiboCard(
          amiibo: amiibo,
          isFavorite: _isFavorite(amiibo.id),
          onFavoriteToggle: () => _toggleFavorite(amiibo.id),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailScreen(
                  amiibo: amiibo,
                  isFavorite: _isFavorite(amiibo.id),
                  onFavoriteToggle: () => _toggleFavorite(amiibo.id),
                ),
              ),
            ).then((_) => setState(() {}));
          },
        );
      },
    );
  }
}