class LeagueStandings {
  final int id;
  final String name;
  final String country;
  final int season;
  final List<Standing> standings;

  LeagueStandings({
    required this.id,
    required this.name,
    required this.country,
    required this.season,
    required this.standings,
  });

  factory LeagueStandings.fromJson(Map<String, dynamic> json) {
    return LeagueStandings(
      id: json['league']['id'],
      name: json['league']['name'],
      country: json['league']['country'],
      season: json['league']['season'],
      standings: List<Standing>.from(json['standings'][0].map((standingJson) => Standing.fromJson(standingJson))),
    );
  }
}

class Standing {
  final int rank;
  final Team team;
  final int points;
  final int goalsDiff;
  final String group;
  final String form;
  final String status;
  final String? description;
  final MatchStats all;
  final MatchStats home;
  final MatchStats away;
  final DateTime update;

  Standing({
    required this.rank,
    required this.team,
    required this.points,
    required this.goalsDiff,
    required this.group,
    required this.form,
    required this.status,
    required this.description,
    required this.all,
    required this.home,
    required this.away,
    required this.update,
  });

  factory Standing.fromJson(Map<String, dynamic> json) {
    return Standing(
      rank: json['rank'],
      team: Team.fromJson(json['team']),
      points: json['points'],
      goalsDiff: json['goalsDiff'],
      group: json['group'],
      form: json['form'],
      status: json['status'],
      description: json['description'],
      all: MatchStats.fromJson(json['all']),
      home: MatchStats.fromJson(json['home']),
      away: MatchStats.fromJson(json['away']),
      update: DateTime.parse(json['update']),
    );
  }
}

class Team {
  final int id;
  final String name;
  final String logo;

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

class MatchStats {
  final int played;
  final int win;
  final int draw;
  final int lose;
  final Map<String, int> goals;

  MatchStats({
    required this.played,
    required this.win,
    required this.draw,
    required this.lose,
    required this.goals,
  });

  factory MatchStats.fromJson(Map<String, dynamic> json) {
    return MatchStats(
      played: json['played'],
      win: json['win'],
      draw: json['draw'],
      lose: json['lose'],
      goals: Map<String, int>.from(json['goals']),
    );
  }
}
