class Movie {
  final int id;
  final String title;
  final int votesCount;
  final double votesAverage;
  final String image;
  final String overview;
  final String releaseDate;
  final String language;

  Movie({
    required this.id,
    required this.image,
    required this.overview,
    required this.releaseDate,
    required this.title,
    required this.votesAverage,
    required this.votesCount,
    required this.language,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'],
      overview: json['overview'],
      image: json['poster_path'],
      votesCount: json['vote_count'],
      votesAverage: json['vote_average'].toDouble(),
      releaseDate: json['release_date'],
      language: json['original_language'],
    );
  }
}
