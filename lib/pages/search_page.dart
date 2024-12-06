import 'package:flutter/material.dart';
import 'package:news_app/models/article_model.dart';
import 'package:news_app/pages/article_view.dart';
import 'package:news_app/services/news.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<ArticleModel> searchResults = [];
  TextEditingController searchController = TextEditingController();
  bool _loading = false;
  String selectedSortBy = "publishedAt";

  performSearch(String query) async {
    if (query.isEmpty) return;

    setState(() {
      _loading = true;
    });

    News searchClass = News();
    await searchClass.getSearchResults(query, sortBy: selectedSortBy);
    setState(() {
      _loading = false;
      searchResults = searchClass.news;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search News"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: searchController,
              onSubmitted: performSearch,
              decoration: InputDecoration(
                hintText: "Search for news...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),

          // Sort Dropdown
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Sort By:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                DropdownButton<String>(
                  value: selectedSortBy,
                  items: const [
                    DropdownMenuItem(
                      value: "publishedAt",
                      child: Text("Published At"),
                    ),
                    DropdownMenuItem(
                      value: "popularity",
                      child: Text("Popularity"),
                    ),
                    DropdownMenuItem(
                      value: "relevancy",
                      child: Text("Relevancy"),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedSortBy = value!;
                    });
                  },
                ),
              ],
            ),
          ),

          // Search Results
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : searchResults.isEmpty
                ? const Center(
              child: Text("No results found. Try searching."),
            )
                : ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                return BlogTile(
                  title: searchResults[index].title!,
                  desc: searchResults[index].description!,
                  imageUrl: searchResults[index].urlToImage!,
                  url: searchResults[index].url!,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class BlogTile extends StatelessWidget {
  final String imageUrl, title, desc, url;

  const BlogTile({
    super.key,
    required this.title,
    required this.desc,
    required this.imageUrl,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ArticleView(blogUrl: url)),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imageUrl,
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    desc,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
