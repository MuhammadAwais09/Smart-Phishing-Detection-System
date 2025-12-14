import 'package:flutter/material.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _controller;
  late Animation<double> _fadeAnim;

  // All available app pages
  final List<_PageItem> _pages = [
    _PageItem(Icons.search, 'Detect Phishing', '/detection'),
    _PageItem(Icons.history, 'Detection History', '/history'),
    _PageItem(Icons.chat_bubble_outline, 'AI Chatbot', '/chatbot'),
    _PageItem(Icons.settings, 'Settings', '/settings'),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..forward();
    _fadeAnim = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigate(String route) {
    Navigator.pushNamed(context, route);
  }

  void _logout() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _onBottomTap(int index) {
    setState(() => _selectedIndex = index);
    _controller.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    const blue = Color(0xFF003366);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Smart Phishing Detection'),
        backgroundColor: blue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      // LEFT MENU DRAWER
      drawer: Drawer(
        child: Container(
          color: Colors.white,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: blue,
                ),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [
                      Icon(Icons.shield_outlined,
                          size: 60, color: Colors.white),
                      SizedBox(height: 10),
                      Text(
                        'Smart Phishing\nDetection System',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Navigation options
              for (int i = 0; i < _pages.length; i++) ...[
                _drawerItem(
                  icon: _pages[i].icon,
                  title: _pages[i].label,
                  isSelected: _selectedIndex == i,
                  onTap: () {
                    Navigator.pop(context);
                    setState(() => _selectedIndex = i);
                    _controller.forward(from: 0.0);
                    _navigate(_pages[i].route);
                  },
                ),
              ],

              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.redAccent),
                title: const Text(
                  'Log Out',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _logout();
                },
              ),
            ],
          ),
        ),
      ),

      // MAIN CONTENT
      body: FadeTransition(
        opacity: _fadeAnim,
        child: _buildScreen(context, _selectedIndex),
      ),

      // BOTTOM NAVIGATION BAR
      bottomNavigationBar: BottomNavigationBar(
        currentIndex:
            _selectedIndex < _pages.length ? _selectedIndex : 0,
        onTap: _onBottomTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: blue,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(0.6),
        items: _pages
            .take(4)
            .map((p) =>
                BottomNavigationBarItem(icon: Icon(p.icon), label: p.label))
            .toList(),
      ),
    );
  }

  // Mock content body for now
  Widget _buildScreen(BuildContext context, int index) {
    const blue = Color(0xFF003366);
    final selected = _pages[index];

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(selected.icon, color: blue, size: 80),
          const SizedBox(height: 20),
          Text(
            selected.label,
            style: const TextStyle(
              color: blue,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
            label: const Text('Log Out'),
            style: ElevatedButton.styleFrom(
              backgroundColor: blue,
              padding:
                  const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Drawer item builder
  Widget _drawerItem({
    required IconData icon,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    const blue = Color(0xFF003366);
    return ListTile(
      leading: Icon(icon, color: isSelected ? blue : Colors.black54),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? blue : Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
      selected: isSelected,
      selectedTileColor: blue.withOpacity(0.08),
      onTap: onTap,
    );
  }
}

// Small helper class for page info
class _PageItem {
  final IconData icon;
  final String label;
  final String route;
  const _PageItem(this.icon, this.label, this.route);
}