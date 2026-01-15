import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:async';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});
  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  int _karmaPoints = 150;
  bool _isInVoiceRoom = false;
  
  // Local State for Interactivity
  final List<bool> _likedPosts = List.generate(10, (_) => false);
  final List<String> _myStories = [];

  // --- 1. THE AD MANAGER (HYPER-LOCAL CONTROL) ---
  void _showAdCreator() {
    double radius = 10.0;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          decoration: BoxDecoration(
            color: const Color(0xFF121212),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
            border: Border.all(color: Colors.white10),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Ad Campaign Center", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              const Text("1. Select Media to Boost", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 10),
              _buildMediaPicker(),
              const SizedBox(height: 20),
              Text("2. Radius Control: ${radius.toInt()} km", style: const TextStyle(fontWeight: FontWeight.bold)),
              Slider(
                value: radius, min: 1, max: 100, activeColor: Colors.redAccent,
                onChanged: (v) => setModalState(() => radius = v),
              ),
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(15)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Est. Reach: ${(radius * 1200).toInt()}", style: const TextStyle(fontSize: 12)),
                    Text("Cost: ₹${(radius * 12).toInt()}", style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, minimumSize: const Size(double.infinity, 50)),
                onPressed: () => Navigator.pop(context),
                child: const Text("LAUNCH AD"),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _selectedIndex == 3 ? null : AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text("MIST", style: TextStyle(letterSpacing: 4, fontWeight: FontWeight.w900)),
        actions: [_buildKarmaBadge()],
      ),
      body: Stack(
        children: [
          IndexedStack(
            index: _selectedIndex,
            children: [
              _buildHomeFeed(),
              _buildGlimpseSection(),
              _buildBubblesSection(),
              _buildModernProfile(),
            ],
          ),
          if (_isInVoiceRoom) _buildVoiceRoomOverlay(),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // --- HOME FEED UI ---
  Widget _buildHomeFeed() {
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        // Story Bar 
        SizedBox(
          height: 110,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 10,
            itemBuilder: (context, i) => _buildStoryItem(i),
          ),
        ),
        const Divider(color: Colors.white10),
        ...List.generate(5, (i) => _buildGlassPost(i)),
      ],
    );
  }

  Widget _buildGlassPost(int i) {
    return Container(
      margin: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          ListTile(
            leading: const CircleAvatar(backgroundImage: NetworkImage("https://i.pravatar.cc/100")),
            title: const Text("Arjun Mehta", style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text("Mumbai • 1h ago", style: TextStyle(fontSize: 10, color: Colors.grey)),
          ),
          Container(
            height: 300,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: const DecorationImage(image: NetworkImage("https://picsum.photos/500/500"), fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                IconButton(icon: Icon(_likedPosts[i] ? Icons.favorite : Icons.favorite_border, color: _likedPosts[i] ? Colors.red : Colors.white), onPressed: () => setState(() => _likedPosts[i] = !_likedPosts[i])),
                IconButton(icon: const Icon(Icons.chat_bubble_outline), onPressed: () {}),
                const Spacer(),
                const Icon(Icons.bookmark_border),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- GLIMPSE (REELS) UI ---
  Widget _buildGlimpseSection() {
    return PageView.builder(
      scrollDirection: Axis.vertical,
      onPageChanged: (i) => setState(() => _karmaPoints++),
      itemBuilder: (context, index) => Stack(
        fit: StackFit.expand,
        children: [
          const Center(child: Icon(Icons.play_circle_outline, size: 100, color: Colors.white10)),
          Positioned(
            bottom: 40, left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Glimpse #$index", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const Text("Trending in Patna #BiharDiwas", style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- MODERN PROFILE UI ---
  Widget _buildModernProfile() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 60),
          const CircleAvatar(radius: 60, backgroundImage: NetworkImage("https://i.pravatar.cc/300")),
          const SizedBox(height: 20),
          const Text("Singh Baishnavi", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
          const Text("AI Verified Citizen", style: TextStyle(color: Colors.blueAccent, fontSize: 12)),
          const SizedBox(height: 30),
          _profileTile("Ads Manager", "Target local audience", Icons.campaign, Colors.purpleAccent, _showAdCreator),
          _profileTile("Wallet", "Withdraw ₹${(_karmaPoints * 0.15).toStringAsFixed(2)}", Icons.account_balance_wallet, Colors.greenAccent, () {}),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // --- HELPERS ---
  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (i) => setState(() => _selectedIndex = i),
      backgroundColor: Colors.black,
      selectedItemColor: Colors.redAccent,
      unselectedItemColor: Colors.white38,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.play_circle_outline), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.blur_on), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ""),
      ],
    );
  }

  Widget _buildKarmaBadge() => Center(child: Container(margin: const EdgeInsets.only(right: 15), padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: Colors.redAccent.withOpacity(0.1), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.redAccent.withOpacity(0.3))), child: Row(children: [const Icon(Icons.bolt, color: Colors.redAccent, size: 16), Text(" $_karmaPoints", style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold))])));
  Widget _profileTile(String t, String s, IconData i, Color c, VoidCallback tap) => ListTile(onTap: tap, leading: Icon(i, color: c), title: Text(t), subtitle: Text(s, style: const TextStyle(fontSize: 10)), trailing: const Icon(Icons.chevron_right));
  Widget _buildStoryItem(int i) => Padding(padding: const EdgeInsets.all(8.0), child: Column(children: [Container(padding: const EdgeInsets.all(2), decoration: const BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(colors: [Colors.redAccent, Colors.orange])), child: const CircleAvatar(radius: 30, backgroundImage: NetworkImage("https://i.pravatar.cc/150"))), const Text("User", style: TextStyle(fontSize: 10))]));
  Widget _buildMediaPicker() => SizedBox(height: 80, child: ListView(scrollDirection: Axis.horizontal, children: [Container(width: 80, decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(15)), child: const Icon(Icons.add_a_photo))]));
  Widget _buildBubblesSection() => const Center(child: Text("Bubbles Tab"));
  Widget _buildVoiceRoomOverlay() => Container();
}