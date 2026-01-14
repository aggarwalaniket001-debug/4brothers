import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});
  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final _postsStream = Supabase.instance.client
      .from('posts')
      .stream(primaryKey: ['id'])
      .order('created_at', ascending: false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("MIST COMMUNITY")),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _postsStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final posts = snapshot.data!;
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return Card(
                margin: const EdgeInsets.all(10),
                color: Colors.white.withOpacity(0.05),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: post['profile_pic_url'] != null 
                        ? NetworkImage(post['profile_pic_url']) 
                        : null,
                    child: post['profile_pic_url'] == null ? const Icon(Icons.person) : null,
                  ),
                  title: Row(
                    children: [
                      Text("@${post['username']}", style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(width: 5),
                      const Icon(Icons.verified, color: Colors.blue, size: 14),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(post['content'] ?? ""),
                      const SizedBox(height: 5),
                      Text("📍 ${post['city'] ?? 'India'}", style: const TextStyle(fontSize: 10, color: Colors.grey)),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showPostDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showPostDialog(BuildContext context) {
    final controller = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 20, right: 20, top: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: controller, decoration: const InputDecoration(hintText: "What's on your mind?")),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final user = Supabase.instance.client.auth.currentUser;
                final profile = await Supabase.instance.client.from('profiles').select().eq('id', user!.id).single();
                
                await Supabase.instance.client.from('posts').insert({
                  'content': controller.text,
                  'username': profile['username'],
                  'profile_pic_url': profile['profile_pic_url'],
                  'city': profile['city'],
                });
                Navigator.pop(context);
              },
              child: const Text("POST"),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}