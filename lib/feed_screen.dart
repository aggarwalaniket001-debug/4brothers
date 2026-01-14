import 'package:flutter/material.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});
  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  int _selectedIndex = 0;
  int _karmaPoints = 150;
  
  // --- VOICE ROOM STATE ---
  bool _isInVoiceRoom = false;
  bool _isMuted = true;
  String _activeBubbleName = "";

  // --- DATA STATE FOR INTERACTIVITY ---
  final List<String> _myStories = []; 
  final List<List<String>> _postComments = List.generate(5, (_) => ["MIST is the future! 🚀", "Proudly Indian app. 🇮🇳"]);
  final List<bool> _likedPosts = List.generate(5, (_) => false);

  void _incrementKarma() => setState(() => _karmaPoints += 1);

  void _addStory() {
    setState(() { _myStories.add("New"); _karmaPoints += 5; });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Story Posted! +5 Karma"), backgroundColor: Colors.green)
    );
  }

  void _showCommentSheet(int postIndex) {
    TextEditingController controller = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(padding: EdgeInsets.all(15), child: Text("Comments", style: TextStyle(fontWeight: FontWeight.bold))),
            SizedBox(
              height: 250,
              child: ListView.builder(
                itemCount: _postComments[postIndex].length,
                itemBuilder: (context, i) => ListTile(
                  leading: const CircleAvatar(radius: 15, child: Icon(Icons.person, size: 15)),
                  title: Text(_postComments[postIndex][i], style: const TextStyle(fontSize: 14)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(child: TextField(controller: controller, decoration: const InputDecoration(hintText: "Add a comment...", border: InputBorder.none))),
                  IconButton(icon: const Icon(Icons.send, color: Colors.redAccent), onPressed: () {
                    if (controller.text.isNotEmpty) { 
                      setState(() => _postComments[postIndex].add(controller.text)); 
                      Navigator.pop(context); 
                    }
                  })
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String userType = ModalRoute.of(context)?.settings.arguments as String? ?? 'social';
    final bool isAnon = userType == 'anonymous';

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("MIST", style: TextStyle(letterSpacing: 4, fontWeight: FontWeight.bold)),
        actions: [
          if (!isAnon) _buildKarmaBadge(),
          IconButton(icon: const Icon(Icons.logout, color: Colors.redAccent), onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false))
        ],
      ),
      body: Stack(
        children: [
          IndexedStack(
            index: _selectedIndex,
            children: [
              _buildMainFeed(isAnon),
              _buildGlimpseSection(),
              _buildBubblesSection(),
              _buildProfileSection(), // Full Business Profile
            ],
          ),
          if (_isInVoiceRoom) _buildVoiceRoomOverlay(), // Populated Voice Room
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.play_arrow_rounded), label: "Glimpse"),
          BottomNavigationBarItem(icon: Icon(Icons.bubble_chart), label: "Bubbles"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  // --- 1. POPULATED BUBBLE VOICE ROOM ---
  Widget _buildVoiceRoomOverlay() {
    return Positioned(
      bottom: 0, left: 0, right: 0, height: 550,
      child: Container(
        decoration: const BoxDecoration(color: Color(0xFF1A1A1A), borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
        child: Column(
          children: [
            Container(margin: const EdgeInsets.only(top: 10), width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(10))),
            ListTile(
              title: Text("Live in $_activeBubbleName", style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text("8 Speakers | 1.2k Listening"),
              trailing: IconButton(icon: const Icon(Icons.close), onPressed: () => setState(() => _isInVoiceRoom = false)),
            ),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 20), child: Text("SPEAKERS", style: TextStyle(color: Colors.grey, fontSize: 10, letterSpacing: 1.5))),
            // Speakers Grid
            Expanded(
              child: GridView.count(
                crossAxisCount: 4,
                padding: const EdgeInsets.all(20),
                children: List.generate(8, (i) => Column(
                  children: [
                    CircleAvatar(
                      radius: 28, 
                      backgroundColor: i == 0 ? Colors.redAccent : Colors.white10, 
                      child: Icon(Icons.person, color: i == 0 ? Colors.white : Colors.white24)
                    ),
                    const SizedBox(height: 5),
                    Text(i == 0 ? "You" : "User $i", style: const TextStyle(fontSize: 10, color: Colors.white70)),
                    if (i != 0 && i % 2 == 0) const Icon(Icons.mic_off, size: 12, color: Colors.grey),
                  ],
                )),
              ),
            ),
            // Bottom Controls & Reactions
            Container(
              padding: const EdgeInsets.all(25),
              decoration: const BoxDecoration(color: Colors.black, borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text("👏", style: TextStyle(fontSize: 24)),
                  const Text("🔥", style: TextStyle(fontSize: 24)),
                  GestureDetector(
                    onTap: () => setState(() => _isMuted = !_isMuted),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: _isMuted ? Colors.white10 : Colors.redAccent,
                      child: Icon(_isMuted ? Icons.mic_off : Icons.mic, color: Colors.white, size: 28),
                    ),
                  ),
                  const Text("❤️", style: TextStyle(fontSize: 24)),
                  const Text("😂", style: TextStyle(fontSize: 24)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- 2. BUSINESS PROFILE & WITHDRAWAL ---
  Widget _buildProfileSection() {
    double earnings = _karmaPoints * 0.15; // 1 Karma = ₹0.15
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const CircleAvatar(radius: 50, backgroundColor: Colors.redAccent, child: Icon(Icons.person, size: 50)),
          const SizedBox(height: 10),
          const Text("Singh Baishnavi", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const Text("@baishnavi_mist • Developer Account", style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 15),
          // WALLET CARD
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.white.withOpacity(0.1), Colors.white.withOpacity(0.05)]),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white10),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text("Earnings", style: TextStyle(color: Colors.grey)), Text("₹${earnings.toStringAsFixed(2)}", style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.green))]),
                    Column(crossAxisAlignment: CrossAxisAlignment.end, children: [const Text("Total Karma", style: TextStyle(color: Colors.grey)), Text("$_karmaPoints", style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.amber))]),
                  ],
                ),
                const Divider(height: 30, color: Colors.white10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, minimumSize: const Size(double.infinity, 50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Withdrawal Initiated! Check your bank in 24h. 🏦"))),
                  child: const Text("WITHDRAW KARMA TO BANK", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [_pStat("Posts", "42"), _pStat("Followers", "2.8k"), _pStat("Following", "190")]),
          const Divider(height: 40, color: Colors.white10),
          _pLink(Icons.verified, "AI Verification Center", Colors.blue),
          _pLink(Icons.history_edu, "Karma Earning History", Colors.amber),
          _pLink(Icons.support_agent, "Creator Support Fund", Colors.green),
        ],
      ),
    );
  }

  // --- REUSED SUB-WIDGETS ---
  Widget _pStat(String l, String v) => Column(children: [Text(v, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), Text(l, style: const TextStyle(color: Colors.grey))]);
  Widget _pLink(IconData i, String t, Color c) => ListTile(leading: Icon(i, color: c), title: Text(t), trailing: const Icon(Icons.arrow_forward_ios, size: 14));
  Widget _buildKarmaBadge() => Center(child: Container(margin: const EdgeInsets.only(right: 12), padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: Colors.amber.withOpacity(0.2), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.amber, width: 0.5)), child: Row(children: [const Icon(Icons.stars, color: Colors.amber, size: 16), Text(" $_karmaPoints", style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold))])));
  Widget _buildMainFeed(bool isAnon) => ListView(children: [SizedBox(height: 110, child: ListView(scrollDirection: Axis.horizontal, children: [_storyItem(label: "Your Story", isAddButton: true, onTap: isAnon ? null : _addStory), ..._myStories.map((s) => _storyItem(label: "You", hasStory: true)), ...List.generate(5, (i) => _storyItem(label: "User $i", hasStory: true))])), const Divider(color: Colors.white12), ...List.generate(5, (index) => _postItem(index, isAnon))]);
  Widget _storyItem({required String label, bool isAddButton = false, bool hasStory = false, VoidCallback? onTap}) => GestureDetector(onTap: onTap, child: Padding(padding: const EdgeInsets.all(8.0), child: Column(children: [CircleAvatar(radius: 30, backgroundColor: (hasStory || isAddButton) ? Colors.redAccent : Colors.white12, child: CircleAvatar(radius: 27, backgroundColor: Colors.black, child: Icon(isAddButton ? Icons.add : Icons.person))), const SizedBox(height: 4), Text(label, style: const TextStyle(fontSize: 10))])));
  Widget _postItem(int i, bool isAnon) => Column(children: [ListTile(leading: const CircleAvatar(backgroundColor: Colors.redAccent), title: Text("Mist Creator $i")), Container(height: 300, width: double.infinity, color: Colors.white10, child: const Icon(Icons.image, color: Colors.white24)), Row(children: [IconButton(icon: Icon(_likedPosts[i] ? Icons.favorite : Icons.favorite_border, color: _likedPosts[i] ? Colors.red : Colors.white), onPressed: () => setState(() => _likedPosts[i] = !_likedPosts[i])), IconButton(icon: const Icon(Icons.comment_outlined), onPressed: () => _showCommentSheet(i))])]);
  Widget _buildGlimpseSection() => PageView.builder(scrollDirection: Axis.vertical, onPageChanged: (i) => _incrementKarma(), itemBuilder: (context, index) => Stack(fit: StackFit.expand, children: [const Center(child: Icon(Icons.play_circle_fill, size: 100, color: Colors.white10)), Positioned(bottom: 40, left: 20, child: Text("Glimpse #$index\nScroll for +1 Karma", style: const TextStyle(fontSize: 18)))]));
  Widget _buildBubblesSection() { final b = ["Tech", "Startup", "Gaming", "Politics"]; return ListView.builder(itemCount: b.length, itemBuilder: (context, i) => ListTile(leading: const Icon(Icons.blur_on, color: Colors.redAccent), title: Text("${b[i]} Bubble"), subtitle: const Text("1.2k members live"), trailing: ElevatedButton(onPressed: () => setState(() { _activeBubbleName = b[i]; _isInVoiceRoom = true; }), child: const Text("JOIN VOICE")))); }
}