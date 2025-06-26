import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'base_activity.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  List<dynamic> movies = [];
  List<dynamic> searchResults = [];
  List<dynamic> popularMovies = [];
  bool isLoading = true;
  bool isSearching = false;
  String selectedCategory = 'Popular';
  TextEditingController _searchController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Dummy poster URLs for fallback sample movies
  final List<String> dummyPosters = [
    'https://m.media-amazon.com/images/I/51EbJjlLQzL._AC_SY679_.jpg', // The Dark Knight
    'https://m.media-amazon.com/images/I/81p+xe8cbnL._AC_SY679_.jpg', // Inception
    'https://m.media-amazon.com/images/I/71c05lTE03L._AC_SY679_.jpg', // Pulp Fiction
    'https://m.media-amazon.com/images/I/51rOnIjLqzL._AC_SY679_.jpg', // The Godfather
    'https://m.media-amazon.com/images/I/61+Q6Rh3OQL._AC_SY679_.jpg', // Forrest Gump
    'https://m.media-amazon.com/images/I/51EG732BV3L._AC_SY679_.jpg', // The Matrix
    'https://m.media-amazon.com/images/I/91kFYg4fX3L._AC_SY679_.jpg', // Interstellar
    'https://m.media-amazon.com/images/I/51NiGlapXlL._AC_SY679_.jpg', // The Shawshank Redemption
    'https://m.media-amazon.com/images/I/41kTVLeW1CL._AC_SY679_.jpg', // Avatar
    'https://m.media-amazon.com/images/I/71rNJQ2g-EL._AC_SY679_.jpg', // Titanic
  ];

  final List<String> categories = [
    'Popular',
    'Action',
    'Comedy',
    'Drama',
    'Horror',
    'Romance',
  ];

  void _navigateToPrivacyPolicy() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PrivacyPolicyActivity()),
    );
  }

  void _navigateToHelp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HelpActivity()),
    );
  }

  // Free movie API endpoints
  final String omdbApiKey = '7472c2fe'; // Replace with your free OMDb API key
  final String imdbApiBase = 'https://rest.imdbapi.dev/v2/titles/tt26743210';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    fetchPopularMovies();
    _animationController.forward();
  }

  Future<void> fetchPopularMovies() async {
    setState(() => isLoading = true);

    try {
      // Try IMDbAPI.dev first (free tier)
      final response = await http
          .get(
            Uri.parse('$imdbApiBase/titles'),
            headers: {'Accept': 'application/json'},
          )
          .timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          movies = data['results'] ?? [];
          popularMovies = movies;
          isLoading = false;
        });
      } else {
        throw Exception('IMDbAPI failed');
      }
    } catch (e) {
      // Fallback to sample data or OMDb API
      await _loadFallbackMovies();
    }
  }

  Future<void> _loadFallbackMovies() async {
    // Sample popular movies for demonstration
    final sampleMovies = [
      {
        'title': 'The Dark Knight',
        'year': '2008',
        'poster': dummyPosters[0],
        'rating': '9.0',
        'genre': 'Action, Crime, Drama',
        'plot':
            'When the menace known as the Joker wreaks havoc on Gotham City, Batman must confront one of the greatest psychological and physical tests.',
        'videoUrl':
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
        'hasVideo': true,
      },
      {
        'title': 'Inception',
        'year': '2010',
        'poster': dummyPosters[1],
        'rating': '8.8',
        'genre': 'Action, Sci-Fi, Thriller',
        'plot':
            'A thief who steals corporate secrets through dream-sharing technology is given the inverse task of planting an idea.',
        'videoUrl':
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
        'hasVideo': true,
      },
      {
        'title': 'Pulp Fiction',
        'year': '1994',
        'poster': dummyPosters[2],
        'rating': '8.9',
        'genre': 'Crime, Drama',
        'plot':
            'The lives of two mob hitmen, a boxer, a gangster and his wife intertwine in four tales of violence and redemption.',
        'videoUrl':
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
        'hasVideo': true,
      },
      {
        'title': 'The Godfather',
        'year': '1972',
        'poster': dummyPosters[3],
        'rating': '9.2',
        'genre': 'Crime, Drama',
        'plot':
            'The aging patriarch of an organized crime dynasty transfers control of his clandestine empire to his reluctant son.',
        'videoUrl':
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
        'hasVideo': true,
      },
      {
        'title': 'Forrest Gump',
        'year': '1994',
        'poster': dummyPosters[4],
        'rating': '8.8',
        'genre': 'Drama, Romance',
        'plot':
            'The presidencies of Kennedy and Johnson through the eyes of an Alabama man with an IQ of 75.',
        'videoUrl':
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4',
        'hasVideo': true,
      },
      {
        'title': 'The Matrix',
        'year': '1999',
        'poster': dummyPosters[5],
        'rating': '8.7',
        'genre': 'Action, Sci-Fi',
        'plot':
            'A computer programmer is led to fight an underground war against powerful computers who have constructed his entire reality.',
        'videoUrl':
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4',
        'hasVideo': true,
      },
      {
        'title': 'Interstellar',
        'year': '2014',
        'poster': dummyPosters[6],
        'rating': '8.6',
        'genre': 'Adventure, Drama, Sci-Fi',
        'plot':
            'A team of explorers travel through a wormhole in space in an attempt to ensure humanity\'s survival.',
        'videoUrl':
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4',
        'hasVideo': true,
      },
      {
        'title': 'The Shawshank Redemption',
        'year': '1994',
        'poster': dummyPosters[7],
        'rating': '9.3',
        'genre': 'Drama',
        'plot':
            'Two imprisoned men bond over a number of years, finding solace and eventual redemption through acts of common decency.',
        'videoUrl':
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4',
        'hasVideo': true,
      },
      {
        'title': 'Avatar',
        'year': '2009',
        'poster': dummyPosters[8],
        'rating': '7.8',
        'genre': 'Action, Adventure, Fantasy',
        'plot':
            'A paraplegic Marine dispatched to the moon Pandora joins a mission to exploit a rare mineral.',
        'videoUrl':
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/SubaruOutbackOnStreetAndDirt.mp4',
        'hasVideo': true,
      },
      {
        'title': 'Titanic',
        'year': '1997',
        'poster': dummyPosters[9],
        'rating': '7.8',
        'genre': 'Drama, Romance',
        'plot':
            'A seventeen-year-old aristocrat falls in love with a kind but poor artist aboard the luxurious, ill-fated R.M.S. Titanic.',
        'videoUrl':
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4',
        'hasVideo': true,
      },
    ];

    setState(() {
      movies = sampleMovies;
      popularMovies = sampleMovies;
      isLoading = false;
    });
  }

  Future<void> searchMovies(String query) async {
    if (query.isEmpty) {
      setState(() {
        movies = popularMovies;
        isSearching = false;
      });
      return;
    }

    setState(() => isSearching = true);

    try {
      // Try OMDb API for search (requires free API key)
      final response = await http
          .get(Uri.parse('http://www.omdbapi.com/?apikey=$omdbApiKey&s=$query'))
          .timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['Response'] == 'True') {
          setState(() {
            searchResults = data['Search'] ?? [];
            movies = searchResults;
            isSearching = false;
          });
        } else {
          throw Exception('No results found');
        }
      } else {
        throw Exception('Search failed');
      }
    } catch (e) {
      // Fallback search in local data
      final filtered = popularMovies
          .where(
            (movie) =>
                movie['title'].toLowerCase().contains(query.toLowerCase()),
          )
          .toList();

      setState(() {
        movies = filtered;
        isSearching = false;
      });
    }
  }

  void _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacementNamed('/auth');
  }

  // Add this placeholder method to avoid undefined reference error
  void _navigateToAccount() {
    // You can implement account navigation here
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Account page not implemented')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsActivity()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Account'),
              onTap: _navigateToAccount,
            ),
            ListTile(
              leading: Icon(Icons.privacy_tip),
              title: Text('Privacy Policy'),
              onTap: _navigateToPrivacyPolicy,
            ),
            ListTile(
              leading: Icon(Icons.help),
              title: Text('Help'),
              onTap: _navigateToHelp,
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Logout'),
              onTap: _signOut,
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          _buildSearchSection(),
          _buildCategorySection(),
          _buildMoviesGrid(),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 120.0,
      floating: false,
      pinned: true,
      backgroundColor: Colors.black,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'Erickfy',
          style: TextStyle(
            color: Colors.redAccent,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        titlePadding: EdgeInsets.only(left: 16, bottom: 16),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.red.withOpacity(0.3), Colors.black],
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.logout, color: Colors.white),
          onPressed: _signOut,
        ),
      ],
    );
  }

  Widget _buildSearchSection() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.red.withOpacity(0.2),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: _searchController,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Search movies...',
              hintStyle: TextStyle(color: Colors.grey[400]),
              prefixIcon: Icon(Icons.search, color: Colors.red),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear, color: Colors.grey),
                      onPressed: () {
                        _searchController.clear();
                        searchMovies('');
                      },
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 15,
              ),
            ),
            onChanged: searchMovies,
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySection() {
    return SliverToBoxAdapter(
      child: Container(
        height: 50,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 16),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            final isSelected = selectedCategory == category;

            return Padding(
              padding: EdgeInsets.only(right: 12),
              child: GestureDetector(
                onTap: () {
                  setState(() => selectedCategory = category);
                  // Here you could filter movies by category
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.red : Colors.grey[800],
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: Colors.red.withOpacity(0.4),
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Text(
                    category,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMoviesGrid() {
    if (isLoading || isSearching) {
      return SliverToBoxAdapter(
        child: Container(
          height: 300,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: Colors.red, strokeWidth: 3),
                SizedBox(height: 16),
                Text(
                  isLoading ? 'Loading movies...' : 'Searching...',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (movies.isEmpty) {
      return SliverToBoxAdapter(
        child: Container(
          height: 300,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.movie_outlined, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No movies found',
                  style: TextStyle(color: Colors.white70, fontSize: 18),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SliverPadding(
      padding: EdgeInsets.all(16),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.6,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        delegate: SliverChildBuilderDelegate((context, index) {
          final movie = movies[index];
          return FadeTransition(
            opacity: _fadeAnimation,
            child: _buildMovieCard(movie, index),
          );
        }, childCount: movies.length),
      ),
    );
  }

  Widget _buildMovieCard(dynamic movie, int index) {
    return GestureDetector(
      onTap: () => _showMovieDetails(movie),
      child: Hero(
        tag: 'movie_${movie['title']}_$index',
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.red.withOpacity(0.2),
                blurRadius: 10,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              color: Colors.grey[900],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 4,
                    child: Container(
                      width: double.infinity,
                      child: Image.network(
                        movie['poster'] ??
                            movie['Poster'] ??
                            'https://via.placeholder.com/300x450/1a1a1a/ffffff?text=No+Image',
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: Colors.grey[800],
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Colors.red,
                                strokeWidth: 2,
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[800],
                            child: Center(
                              child: Icon(
                                Icons.movie,
                                color: Colors.white54,
                                size: 48,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            movie['title'] ?? movie['Title'] ?? 'Unknown Title',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4),
                          Text(
                            movie['year'] ?? movie['Year'] ?? '',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.amber, size: 16),
                              SizedBox(width: 4),
                              Text(
                                movie['rating'] ?? movie['imdbRating'] ?? 'N/A',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showMovieDetails(dynamic movie) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    movie['title'] ?? movie['Title'] ?? 'Unknown Title',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, color: Colors.grey, size: 16),
                      SizedBox(width: 8),
                      Text(
                        movie['year'] ?? movie['Year'] ?? '',
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(width: 20),
                      Icon(Icons.star, color: Colors.amber, size: 16),
                      SizedBox(width: 4),
                      Text(
                        movie['rating'] ?? movie['imdbRating'] ?? 'N/A',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  if (movie['genre'] != null)
                    Text(
                      movie['genre'],
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  SizedBox(height: 16),
                  Text(
                    'Plot',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    movie['plot'] ?? movie['Plot'] ?? 'No plot available.',
                    style: TextStyle(color: Colors.white70, height: 1.5),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }
}

// Add similar methods for other activities

// Placeholder for SettingsActivity
class SettingsActivity extends StatefulWidget {
  const SettingsActivity({Key? key}) : super(key: key);

  @override
  _SettingsActivityState createState() => _SettingsActivityState();
}

class _SettingsActivityState extends State<SettingsActivity> {
  bool _notificationsEnabled = false;
  bool _darkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return BaseActivity(
      title: 'Settings',
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8), // Semi-transparent white
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            ListTile(
              title: Text('Profile'),
              subtitle: Text('Update your account info'),
              leading: Icon(Icons.person),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Navigate to Profile Page
              },
            ),
            Divider(),
            SwitchListTile(
              title: Text('Notifications'),
              subtitle: Text('Receive updates and reminders'),
              value: _notificationsEnabled,
              onChanged: (val) {
                setState(() {
                  _notificationsEnabled = val;
                });
              },
              secondary: Icon(Icons.notifications_active),
            ),
            SwitchListTile(
              title: Text('Dark Mode'),
              subtitle: Text('Enable darker UI theme'),
              value: _darkModeEnabled,
              onChanged: (val) {
                setState(() {
                  _darkModeEnabled = val;
                });
                // Optional: apply dark mode logic here
              },
              secondary: Icon(Icons.dark_mode),
            ),
            Divider(),
            ListTile(
              title: Text('About'),
              subtitle: Text('Learn more about this app'),
              leading: Icon(Icons.info),
              onTap: () {
                // Navigate to About screen
              },
            ),
            ListTile(
              title: Text('Privacy Policy'),
              leading: Icon(Icons.privacy_tip),
              onTap: () {
                // Open privacy policy link or page
              },
            ),
            ListTile(
              title: Text('Log Out'),
              leading: Icon(Icons.logout),
              onTap: () {
                // Handle logout logic
              },
            ),
          ],
        ),
      ),
    );
  }
}

class HelpActivity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Help')),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8), // Semi-transparent white
          borderRadius: BorderRadius.circular(12),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Frequently Asked Questions',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(height: 16),
              _buildFAQ(
                context,
                question: 'How do I search for a movie?',
                answer:
                    'Tap the search icon on the home screen and enter the movie title or IMDb ID. You’ll see suggestions and detailed information instantly.',
              ),
              _buildFAQ(
                context,
                question: 'Where does Erickfy get its movie data?',
                answer:
                    'We use the Free IMDb API to fetch accurate and up-to-date information about movies and TV shows.',
              ),
              _buildFAQ(
                context,
                question: 'Why do some posters show a placeholder image?',
                answer:
                    'If a movie poster is missing or marked as "N/A" in the API, Erickfy uses a fallback placeholder to maintain visual consistency.',
              ),
              _buildFAQ(
                context,
                question: 'Can I save movies or mark favorites?',
                answer:
                    'This feature is coming soon! We’re working on a favorites list that syncs with your profile across devices.',
              ),
              _buildFAQ(
                context,
                question: 'How can I contact support?',
                answer:
                    'Reach out to us anytime at support@erickfy.com. We typically respond within 24 hours.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFAQ(
    BuildContext context, {
    required String question,
    required String answer,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: ExpansionTile(
        title: Text(question, style: Theme.of(context).textTheme.titleMedium),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(answer, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}

// Placeholder for PrivacyPolicyActivity
class PrivacyPolicyActivity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseActivity(
      title: 'Privacy Policy',
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8), // Semi-transparent white
          borderRadius: BorderRadius.circular(12),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Privacy Policy\n\n'
                'At Erickfy, we value your privacy and are committed to protecting your personal information. This Privacy Policy outlines how we collect, use, and safeguard your data when you use our mobile application.\n\n'
                '1. Information We Collect:\n'
                '- We may collect basic information such as your name, email address, and preferences when you interact with the app.\n'
                '- We may also collect anonymous usage data to improve app performance and user experience.\n\n'
                '2. How We Use Your Information:\n'
                '- To personalize your experience within the app.\n'
                '- To improve our services and provide relevant content.\n'
                '- To communicate with you about updates or support.\n\n'
                '3. Data Sharing:\n'
                '- We do not sell or rent your personal information to third parties.\n'
                '- We may share data with trusted service providers who help us operate the app, under strict confidentiality agreements.\n\n'
                '4. Security:\n'
                '- We implement industry-standard security measures to protect your data from unauthorized access or disclosure.\n\n'
                '5. Your Choices:\n'
                '- You can manage your data preferences in the app settings.\n'
                '- You may request to access, update, or delete your personal information by contacting us.\n\n'
                '6. Changes to This Policy:\n'
                '- We may update this Privacy Policy from time to time. We will notify you of any significant changes within the app.\n\n'
                '7. Contact Us:\n'
                'If you have any questions or concerns about this policy, please reach out to us at support@erickfy.com.\n\n'
                'By using Erickfy, you agree to the terms outlined in this Privacy Policy.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              SizedBox(height: 16),
              Text(
                'Your privacy is important to us...',
                // Add your full privacy policy text here
              ),
            ],
          ),
        ),
      ),
    );
  }
}
