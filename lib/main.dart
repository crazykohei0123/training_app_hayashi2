import 'package:flutter/material.dart';

void main() {
  runApp(const SocialApp());
}

class SocialApp extends StatelessWidget {
  const SocialApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Social Feed',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

class Tweet {
  final String id;
  final String username;
  final String handle;
  final String content;
  final DateTime timestamp;
  final String? avatarUrl;
  int likes;
  int retweets;
  int replies;
  bool isLiked;
  bool isRetweeted;

  Tweet({
    required this.id,
    required this.username,
    required this.handle,
    required this.content,
    required this.timestamp,
    this.avatarUrl,
    this.likes = 0,
    this.retweets = 0,
    this.replies = 0,
    this.isLiked = false,
    this.isRetweeted = false,
  });
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final List<Tweet> _tweets = [
    Tweet(
      id: '1',
      username: 'Flutter Dev',
      handle: '@flutterdev',
      content: 'Just shipped an amazing new feature! The hot reload is getting even faster 🚀 #Flutter #Development',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      likes: 342,
      retweets: 89,
      replies: 45,
    ),
    Tweet(
      id: '2',
      username: 'Sarah Johnson',
      handle: '@sarahj_codes',
      content: 'Beautiful sunset today! Sometimes you need to step away from the code and enjoy nature 🌅',
      timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      likes: 156,
      retweets: 23,
      replies: 12,
    ),
    Tweet(
      id: '3',
      username: 'Tech News',
      handle: '@technews24',
      content: 'Breaking: New AI breakthrough announced at the latest conference. This could change everything we know about machine learning.',
      timestamp: DateTime.now().subtract(const Duration(hours: 6)),
      likes: 892,
      retweets: 234,
      replies: 67,
    ),
    Tweet(
      id: '4',
      username: 'Coffee Lover',
      handle: '@coffeeaddict',
      content: 'Third cup of coffee today and it\'s only noon ☕ Anyone else running on pure caffeine?',
      timestamp: DateTime.now().subtract(const Duration(hours: 8)),
      likes: 78,
      retweets: 15,
      replies: 34,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _toggleLike(String tweetId) {
    setState(() {
      final tweet = _tweets.firstWhere((t) => t.id == tweetId);
      if (tweet.isLiked) {
        tweet.likes--;
        tweet.isLiked = false;
      } else {
        tweet.likes++;
        tweet.isLiked = true;
      }
    });
  }

  void _toggleRetweet(String tweetId) {
    setState(() {
      final tweet = _tweets.firstWhere((t) => t.id == tweetId);
      if (tweet.isRetweeted) {
        tweet.retweets--;
        tweet.isRetweeted = false;
      } else {
        tweet.retweets++;
        tweet.isRetweeted = true;
      }
    });
  }

  void _showComposeDialog() {
    final TextEditingController controller = TextEditingController();
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Compose Tweet'),
          content: TextField(
            controller: controller,
            maxLines: 3,
            maxLength: 280,
            decoration: const InputDecoration(
              hintText: 'What\'s happening?',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  setState(() {
                    _tweets.insert(0, Tweet(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      username: 'You',
                      handle: '@yourhandle',
                      content: controller.text.trim(),
                      timestamp: DateTime.now(),
                    ));
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Tweet'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildHomePage(),
      _buildSearchPage(),
      _buildNotificationsPage(),
      _buildProfilePage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Social Feed'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _showComposeDialog,
          ),
        ],
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showComposeDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildHomePage() {
    return RefreshIndicator(
      onRefresh: () async {
        // Simulate refresh
        await Future.delayed(const Duration(seconds: 1));
        setState(() {});
      },
      child: ListView.builder(
        itemCount: _tweets.length,
        itemBuilder: (context, index) {
          return _buildTweetCard(_tweets[index]);
        },
      ),
    );
  }

  Widget _buildTweetCard(Tweet tweet) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.blue,
                  child: Text(
                    tweet.username[0].toUpperCase(),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            tweet.username,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            tweet.handle,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '· ${_formatTimestamp(tweet.timestamp)}',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              tweet.content,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildActionButton(
                  icon: Icons.chat_bubble_outline,
                  count: tweet.replies,
                  onTap: () {},
                ),
                _buildActionButton(
                  icon: tweet.isRetweeted ? Icons.repeat : Icons.repeat,
                  count: tweet.retweets,
                  onTap: () => _toggleRetweet(tweet.id),
                  isActive: tweet.isRetweeted,
                  activeColor: Colors.green,
                ),
                _buildActionButton(
                  icon: tweet.isLiked ? Icons.favorite : Icons.favorite_border,
                  count: tweet.likes,
                  onTap: () => _toggleLike(tweet.id),
                  isActive: tweet.isLiked,
                  activeColor: Colors.red,
                ),
                _buildActionButton(
                  icon: Icons.share,
                  count: 0,
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required int count,
    required VoidCallback onTap,
    bool isActive = false,
    Color? activeColor,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isActive ? activeColor : Colors.grey[600],
            ),
            if (count > 0) ...[
              const SizedBox(width: 4),
              Text(
                count.toString(),
                style: TextStyle(
                  color: isActive ? activeColor : Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h';
    } else {
      return '${difference.inDays}d';
    }
  }

  Widget _buildSearchPage() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text('Search functionality coming soon!'),
        ],
      ),
    );
  }

  Widget _buildNotificationsPage() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text('No new notifications'),
        ],
      ),
    );
  }

  Widget _buildProfilePage() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundColor: Colors.blue,
            child: Text(
              'Y',
              style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Your Name',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const Text(
            '@yourhandle',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
          const SizedBox(height: 16),
          const Text(
            'Flutter developer passionate about creating beautiful mobile experiences.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatColumn('Following', '123'),
              _buildStatColumn('Followers', '456'),
              _buildStatColumn('Tweets', _tweets.where((t) => t.username == 'You').length.toString()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String label, String count) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}