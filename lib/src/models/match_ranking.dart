class MatchRanking {
  League league;
  List<Standing> standings;

  MatchRanking({required this.league, required this.standings});

  factory MatchRanking.fromJson(Map<String, dynamic> json) {
    return MatchRanking(
      league: League.fromJson(json['league']),
      standings: List<Standing>.from(
        json['league']['standings'][0].map((standingJson) => Standing.fromJson(standingJson)),
      ),
    );
  }
}

class League {
  int id;
  String name;
  String country;
  int season;

  League({
    required this.id,
    required this.name,
    required this.country,
    required this.season,
  });

  factory League.fromJson(Map<String, dynamic> json) {
    return League(
      id: json['id'],
      name: json['name'],
      country: json['country'],
      season: json['season'],
    );
  }
}

class Standing {
  int rank;
  Team team;
  int points;

  Standing({
    required this.rank,
    required this.team,
    required this.points,
  });

  factory Standing.fromJson(Map<String, dynamic> json) {
    return Standing(
      rank: json['rank'],
      team: Team.fromJson(json['team']),
      points: json['points'],
    );
  }
}

class Team {
  int id;
  String name;
  String logo;

  Team({
    required this.id,
    required this.name,
    required this.logo,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id'],
      name: json['name'],
      logo: json['logo'],
    );
  }
}
