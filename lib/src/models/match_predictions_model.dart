class PredictionData {
  final Prediction predictions;
  final League league;
  final TeamsData teams;
  final Comparison comparison;

  PredictionData({required this.predictions, required this.league, required this.teams, required this.comparison});

  factory PredictionData.fromJson(Map<String, dynamic> json) {
    return PredictionData(
        predictions: Prediction.fromJson(json['predictions']),
        league: League.fromJson(json['league']),
        teams: TeamsData.fromJson(json['teams']),
        comparison: Comparison.fromJson(json['comparison']));
  }
}

class Prediction {
  // final Winner winner;
  // final bool winOrDraw;
  // final String? underOver;
  // final Goals goals;
  final String advice;
  final Percent percent;

  Prediction({
    // required this.winner,
    // required this.winOrDraw,
    // this.underOver,
    // required this.goals,
    required this.advice,
    required this.percent,
  });

  factory Prediction.fromJson(Map<String, dynamic> json) {
    return Prediction(
      // winner: Winner.fromJson(json['winner']),
      // winOrDraw: json['win_or_draw'],
      // underOver: json['under_over'],
      // goals: Goals.fromJson(json['goals']),
      advice: json['advice'] ?? '',
      percent: Percent.fromJson(json['percent'] ?? ''),
    );
  }
}

// class Winner {
//   final int? id;
//   final String? name;
//   final String? comment;

//   Winner({this.id, this.name, this.comment});

//   factory Winner.fromJson(Map<String, dynamic> json) {
//     return Winner(
//       id: json['id'],
//       name: json['name'],
//       comment: json['comment'],
//     );
//   }
// }

// class Goals {
//   final int? home;
//   final int? away;

//   Goals({this.home, this.away});

//   factory Goals.fromJson(Map<String, dynamic> json) {
//     return Goals(
//       home: json['home'],
//       away: json['away'],
//     );
//   }
// }

class Percent {
  final String home;
  final String draw;
  final String away;

  Percent({required this.home, required this.draw, required this.away});

  factory Percent.fromJson(Map<String, dynamic> json) {
    return Percent(
      home: json['home'] ?? '',
      draw: json['draw'] ?? '',
      away: json['away'] ?? '',
    );
  }
}

class Comparison {
  final String home;
  final String away;

  Comparison({required this.home, required this.away});

  factory Comparison.fromJson(Map<String, dynamic> json) {
    return Comparison(
      home: json['poisson_distribution']['home'] ?? 'No data',
      away: json['poisson_distribution']['away'] ?? 'No data',
    );
  }
}

class League {
  final int? id;
  final String name;
  final String country;
  final String logo;
  final int? season;

  League({required this.id, required this.name, required this.country, required this.logo, required this.season});

  factory League.fromJson(Map<String, dynamic> json) {
    return League(
      id: json['id'],
      name: json['name'] ?? '',
      country: json['country'] ?? '',
      logo: json['logo'] ?? '',
      season: json['season'],
    );
  }
}

class TeamsData {
  final Team home;
  final Team away;

  TeamsData({required this.home, required this.away});

  factory TeamsData.fromJson(Map<String, dynamic> json) {
    return TeamsData(
      home: Team.fromJson(json['home']),
      away: Team.fromJson(json['away']),
    );
  }
}

class Team {
  final int? id;
  final String name;
  final String logo;
  // final Last5 last5;
  final League teamLeague;

  Team(
      {required this.id,
      required this.name,
      required this.logo,
      // required this.last5,
      required this.teamLeague});

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id'],
      name: json['name'] ?? '',
      logo: json['logo'] ?? '',
      // last5: Last5.fromJson(json['last_5']),
      teamLeague: League.fromJson(json['league']),
    );
  }
}

// class Last5 {
//   final int? played;
//   final String form;
//   final String att;
//   final String def;
//   final Goals goals;

//   Last5({required this.played, required this.form, required this.att, required this.def, required this.goals});

//   factory Last5.fromJson(Map<String, dynamic> json) {
//     return Last5(
//       played: json['played'],
//       form: json['form'],
//       att: json['att'],
//       def: json['def'],
//       goals: Goals.fromJson(json['goals']),
//     );
//   }
