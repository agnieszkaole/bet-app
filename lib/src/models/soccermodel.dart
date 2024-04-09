import 'package:intl/intl.dart';

final formatter = DateFormat('dd.MM.y - HH:mm');

class SoccerMatch {
  Fixture fixture;
  Team home;
  Team away;
  Goal goal;
  League league;
  Score score;
  SoccerMatch(
      {required this.fixture,
      required this.home,
      required this.away,
      required this.goal,
      required this.league,
      required this.score});

  factory SoccerMatch.fromJson(Map<String, dynamic> json) {
    return SoccerMatch(
        fixture: Fixture.fromJson(json['fixture']),
        home: Team.fromJson(json['teams']['home']),
        away: Team.fromJson(json['teams']['away']),
        goal: Goal.fromJson(json['goals']),
        league: League.fromJson(json['league']),
        score: Score.fromJson(json['score']));
  }
}

class League {
  int id;
  String name;
  String logo;
  String round;

  League({required this.id, required this.name, required this.logo, required this.round});

  factory League.fromJson(Map<String, dynamic> json) {
    return League(
      id: json['id'],
      name: json['name'],
      logo: json['logo'],
      round: json['round'],
    );
  }
}

class Fixture {
  int id;
  String date;
  Status status;

  Fixture({required this.id, required this.date, required this.status});

  factory Fixture.fromJson(Map<String, dynamic> json) {
    return Fixture(
      id: json['id'],
      date: json['date'],
      status: Status.fromJson(json['status']),
    );
  }
  int get matchId {
    return id;
  }

  // DateTime get dateTime {
  //   return DateTime.parse(date);
  // }

  String get formattedDate {
    DateTime dateTime = DateTime.parse(date);
    return formatter.format(dateTime.toLocal());
  }

  // String get formattedDateTime {
  //   return formatter.format(dateTime);
  // }
}

class Status {
  int? elapsedTime;
  String? long;
  String? short;
  Status({required this.elapsedTime, required this.long, required this.short});

  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(
      elapsedTime: json['elapsed'],
      long: json['long'],
      short: json['short'],
    );
  }
}

class Team {
  int id;
  String name;
  String logoUrl;
  bool? winner;
  Team({required this.id, required this.name, required this.logoUrl, required this.winner});

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(id: json['id'], name: json['name'], logoUrl: json['logo'], winner: json['winner']);
  }
}

class Goal {
  int? home;
  int? away;
  Goal({required this.home, required this.away});

  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      home: json['home'],
      away: json['away'],
    );
  }
}

class Score {
  final Halftime halftime;
  final Fulltime fulltime;
  final Extratime extratime;
  final Penalty penalty;

  Score({required this.halftime, required this.fulltime, required this.extratime, required this.penalty});

  factory Score.fromJson(Map<String, dynamic> json) {
    return Score(
      halftime: Halftime.fromJson(json['halftime']),
      fulltime: Fulltime.fromJson(json['fulltime']),
      extratime: Extratime.fromJson(json['extratime']),
      penalty: Penalty.fromJson(json['penalty']),
    );
  }
}

class Halftime {
  int? home;
  int? away;

  Halftime({required this.home, required this.away});

  factory Halftime.fromJson(Map<String, dynamic> json) {
    return Halftime(
      home: json['home'],
      away: json['away'],
    );
  }
}

class Fulltime {
  int? home;
  int? away;

  Fulltime({required this.home, required this.away});

  factory Fulltime.fromJson(Map<String, dynamic> json) {
    return Fulltime(
      home: json['home'],
      away: json['away'],
    );
  }
}

class Extratime {
  int? home;
  int? away;

  Extratime({required this.home, required this.away});

  factory Extratime.fromJson(Map<String, dynamic> json) {
    return Extratime(
      home: json['home'],
      away: json['away'],
    );
  }
}

class Penalty {
  int? home;
  int? away;

  Penalty({required this.home, required this.away});

  factory Penalty.fromJson(Map<String, dynamic> json) {
    return Penalty(
      home: json['home'],
      away: json['away'],
    );
  }
}
