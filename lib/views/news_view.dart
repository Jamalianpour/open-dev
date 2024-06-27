import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:open_dev/model/rss_item_model.dart';
import 'package:xml/xml.dart';

import '../widgets/rss/rss_card.dart';

class NewsView extends StatefulWidget {
  const NewsView({super.key});

  @override
  State<NewsView> createState() => _NewsViewState();
}

class _NewsViewState extends State<NewsView> {
  final List<Map<String, String>> rssFeeds = [
    {'name': 'TheHackerNews', 'url': 'https://feeds.feedburner.com/feedburner/qmx0fekpcy0'},
    {'name': 'DZone', 'url': 'https://feeds.feedburner.com/dzone/1quqwul4ic9'},
    {'name': 'MacRumors', 'url': 'https://feeds.feedburner.com/macrumors/ryqjtjmbox3'},
    {'name': 'Slashdot', 'url': 'https://feeds.feedburner.com/slashdot/nuyhe5k8tbj'},
  ];

  late Future<List<RssItemModel>> futureRssItems;
  String selectedFeedUrl = 'https://feeds.feedburner.com/feedburner/qmx0fekpcy0';

  Future<List<RssItemModel>> fetchRssFeed(String url) async {
    final response = await Dio().get(selectedFeedUrl);

    if (response.statusCode == 200) {
      final document = XmlDocument.parse(response.data);
      final items = document.findAllElements('item');
      return items.map((node) => RssItemModel.fromXml(node)).toList();
    } else {
      throw Exception('Failed to load RSS feed');
    }
  }

  void _onFeedChanged(String? newFeedUrl) {
    if (newFeedUrl != null) {
      setState(() {
        selectedFeedUrl = newFeedUrl;
        futureRssItems = fetchRssFeed(selectedFeedUrl);
      });
    }
  }

  @override
  void initState() {
    String selectedFeedUrl = rssFeeds[0]['url']!;

    futureRssItems = fetchRssFeed(selectedFeedUrl);
    super.initState();
  }

  Padding _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Text('Developer News', style: Theme.of(context).textTheme.headlineSmall),
          const Spacer(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context),
        const Divider(
          indent: 8,
          endIndent: 8,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text('Source: ', style: Theme.of(context).textTheme.bodyMedium),
              SizedBox(
                width: 170,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).splashColor,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: DropdownButtonFormField<String>(
                      borderRadius: BorderRadius.circular(6),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                      ),
                      items: rssFeeds.map((feed) {
                        return DropdownMenuItem<String>(
                          value: feed['url'],
                          child: Text(feed['name']!),
                        );
                      }).toList(),
                      value: selectedFeedUrl,
                      onChanged: _onFeedChanged,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: FutureBuilder<List<RssItemModel>>(
            future: futureRssItems,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text('Failed to load feed'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No items found'));
              } else {
                final items = snapshot.data!;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return FeedCard(item: items[index]);
                    },
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
    // if (rssFeed != null) {
    //   return Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       Padding(
    //         padding: const EdgeInsets.symmetric(horizontal: 8),
    //         child: Text('Developer News', style: Theme.of(context).textTheme.headlineSmall),
    //       ),
    //       const Divider(endIndent: 8, indent: 8),
    //       Expanded(
    //         child: ListView.builder(
    //           itemCount: rssFeed!.items.length,
    //           itemBuilder: (context, index) => FeedCard(item: rssFeed!.items[index]),
    //         ),
    //       ),
    //     ],
    //   );
    // }
    // return const Center(child: CircularProgressIndicator());
  }
}
