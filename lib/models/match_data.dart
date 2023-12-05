import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();

const uuid = Uuid();

class MatchData {
  MatchData({
    required this.team1,
    required this.team2,
    required this.matchTime,
  }) : id = uuid.v4();

  final String id;
  final String team1;
  final String team2;
  final DateTime matchTime;

  // String get formattedDate {
  //   return formatter.format(matchTime);
  // }
}
