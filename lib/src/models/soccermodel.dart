import 'package:intl/intl.dart';

final formatter = DateFormat('dd.MM.y - HH:mm');

class SoccerMatch {
  Fixture fixture;
  Team home;
  Team away;
  Goal goal;
  League league;
  SoccerMatch(
      {required this.fixture,
      required this.home,
      required this.away,
      required this.goal,
      required this.league});

  factory SoccerMatch.fromJson(Map<String, dynamic> json) {
    return SoccerMatch(
        fixture: Fixture.fromJson(json['fixture']),
        home: Team.fromJson(json['teams']['home']),
        away: Team.fromJson(json['teams']['away']),
        goal: Goal.fromJson(json['goals']),
        league: League.fromJson(json['league']));
  }
}

class League {
  int id;
  String name;
  String logo;
  String round;

  League(
      {required this.id,
      required this.name,
      required this.logo,
      required this.round});

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
  String long;
  Status({required this.elapsedTime, required this.long});

  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(
      elapsedTime: json['elapsed'],
      long: json['long'],
    );
  }
}

class Team {
  int id;
  String name;
  String logoUrl;
  bool? winner;
  Team(
      {required this.id,
      required this.name,
      required this.logoUrl,
      required this.winner});

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
        id: json['id'],
        name: json['name'],
        logoUrl: json['logo'],
        winner: json['winner']);
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
