import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:untitled/constants.dart';
import 'package:untitled/models/movie.dart';
import 'package:untitled/widgets/error_card.dart';
import 'package:untitled/widgets/loading_card.dart';
import 'package:untitled/widgets/movie_card.dart';

class MoviesScreen extends StatefulWidget {
  const MoviesScreen({Key? key}) : super(key: key);

  @override
  State<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  int page = 1;
  List<Movie>? moviesList;
  bool isLoading = false;
  String? error;

  @override
  void initState() {
    getMovies();
    super.initState();
  }

  void getMovies() async {
    try {
      setState(() {
        isLoading = true;
      });

      var uri = Uri.parse(
          'https://api.themoviedb.org/3/discover/movie?api_key=$API_KEY&page=$page');
      var response = await http.get(uri);
      var data = jsonDecode(response.body);

      List<Movie> list = [];
      for (var result in data['results']) {
        var movie = Movie.fromJson(result);
        list.add(movie);
      }

      setState(() {
        moviesList = list;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Movies App'),
        backgroundColor: Colors.black,
        titleTextStyle: const TextStyle(
          color: Colors.indigo,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        actions: [
          if (!isLoading)
            IconButton(
              onPressed: () => getMovies(),
              icon: const Icon(Icons.refresh),
            ),
        ],
      ),
      body: isLoading
          ? const LoadingCard()
          : error != null
              ? ErrorCard(error: error!)
              : ListView(
                  padding: const EdgeInsets.all(8),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: .6,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children: [
                        for (var movie in moviesList!) MovieCard(movie: movie),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          if (page > 1) ...[
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                ),
                                onPressed: () {
                                  setState(() {
                                    page--;
                                    getMovies();
                                  });
                                },
                                child: const Text(
                                  'Previous',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                          Container(
                            height: 35,
                            constraints: const BoxConstraints(minWidth: 35),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: Colors.white,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '$page',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.indigo,
                              ),
                              onPressed: () {
                                setState(() {
                                  page++;
                                  getMovies();
                                });
                              },
                              child: const Text('Next'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }
}
