import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:html/parser.dart';
import 'package:xml/xml.dart';

class RssItemModel {
  final String title; // Title of the item
  final String link; // Link to the item's content
  final String description; // Description of the item
  final String pubDate; // Publication date of the item (optional)
  final String? enclosure;
  // final String? author; // Author of the item (optional)

  RssItemModel({
    // this.author,
    required this.title,
    required this.link,
    required this.description,
    this.pubDate = "",
    this.enclosure,
  });

  factory RssItemModel.fromXml(XmlElement doc) {
    // final doc = XmlDocument.parse(xmlString);
    // final items = doc.findAllElements("item");
    // var feedItems = items
    //     .map((item) => RssItemModel(
    //           title: item.findElements("title").first.innerText,
    //           pubDate: item.findElements("pubDate").first.innerText,
    //           link: item.findElements("link").first.innerText,
    //           description:
    //               parse(parse(item.findElements("description").first.innerText).body?.text).documentElement?.text ?? '',
    //         ))
    //     .toList();

    return RssItemModel(
      title: doc.findAllElements("title").first.innerText,
      link: doc.findAllElements("link").first.innerText,
      description:
          parse(parse(doc.findElements("description").first.innerText).body?.text).documentElement?.text.trim() ?? '',
      pubDate: doc.findAllElements("pubDate").isNotEmpty
          ? doc.findAllElements("pubDate").first.innerText
          : doc.findAllElements("dc:date").isNotEmpty
              ? doc.findAllElements("dc:date").first.innerText
              : '',
      enclosure:
          doc.findElements('enclosure').isNotEmpty ? doc.findElements('enclosure').first.getAttribute('url') : null,
    );
  }

  RssItemModel copyWith({
    String? title,
    String? link,
    String? description,
    String? pubDate,
    ValueGetter<String?>? enclosure,
  }) {
    return RssItemModel(
      title: title ?? this.title,
      link: link ?? this.link,
      description: description ?? this.description,
      pubDate: pubDate ?? this.pubDate,
      enclosure: enclosure != null ? enclosure() : this.enclosure,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'link': link,
      'description': description,
      'pubDate': pubDate,
      'enclosure': enclosure,
    };
  }

  factory RssItemModel.fromMap(Map<String, dynamic> map) {
    return RssItemModel(
      title: map['title'] ?? '',
      link: map['link'] ?? '',
      description: map['description'] ?? '',
      pubDate: map['pubDate'] ?? '',
      enclosure: map['enclosure'],
    );
  }

  String toJson() => json.encode(toMap());

  factory RssItemModel.fromJson(String source) => RssItemModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'RssItemModel(title: $title, link: $link, description: $description, pubDate: $pubDate, enclosure: $enclosure)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RssItemModel &&
        other.title == title &&
        other.link == link &&
        other.description == description &&
        other.pubDate == pubDate &&
        other.enclosure == enclosure;
  }

  @override
  int get hashCode {
    return title.hashCode ^ link.hashCode ^ description.hashCode ^ pubDate.hashCode ^ enclosure.hashCode;
  }
}
