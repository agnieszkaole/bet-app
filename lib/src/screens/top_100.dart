import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Top100 extends StatefulWidget {
  const Top100({super.key});

  @override
  State<Top100> createState() => _LeaderboardGroupState();
}

class _LeaderboardGroupState extends State<Top100> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        Container(
          height: 50,
          margin: EdgeInsets.all(8),
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          decoration: BoxDecoration(
            color: Color.fromARGB(78, 59, 59, 59),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              width: 0.6,
              color: Color.fromARGB(255, 148, 148, 148),
            ),
          ),
          child: SizedBox(
            width: 200,
            child: Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      width: 0.6,
                      color: Color.fromARGB(255, 148, 148, 148),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color.fromARGB(255, 255, 204, 0),
                        Color.fromARGB(255, 212, 175, 55),
                      ],
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      '1.  ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Text('Staś'),
              ],
            ),
          ),
        ),
        Container(
          height: 50,
          margin: EdgeInsets.all(8),
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          decoration: BoxDecoration(
            color: Color.fromARGB(78, 59, 59, 59),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              width: 0.6,
              color: Color.fromARGB(255, 148, 148, 148),
            ),
          ),
          child: SizedBox(
            width: 200,
            child: Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      width: 0.6,
                      color: Color.fromARGB(255, 148, 148, 148),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color.fromARGB(255, 97, 98, 99),
                        Color.fromARGB(255, 185, 185, 185),
                      ],
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      '2.  ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Text('Maciej'),
              ],
            ),
          ),
        ),
        Container(
          height: 50,
          margin: EdgeInsets.all(8),
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          decoration: BoxDecoration(
            color: Color.fromARGB(78, 59, 59, 59),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              width: 0.6,
              color: Color.fromARGB(255, 148, 148, 148),
            ),
          ),
          child: SizedBox(
            width: 200,
            child: Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      width: 0.6,
                      color: Color.fromARGB(255, 148, 148, 148),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color.fromARGB(255, 151, 101, 21),
                        Color.fromARGB(255, 184, 134, 11),
                      ],
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      '3.  ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Text('Zosia'),
              ],
            ),
          ),
        ),
        Container(
          height: 50,
          margin: EdgeInsets.all(8),
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          decoration: BoxDecoration(
            color: Color.fromARGB(78, 59, 59, 59),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              width: 0.6,
              color: Color.fromARGB(255, 148, 148, 148),
            ),
          ),
          child: SizedBox(
            width: 200,
            child: Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      width: 0.6,
                      color: Color.fromARGB(255, 148, 148, 148),
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      '4.  ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Text('Aga'),
              ],
            ),
          ),
        ),
        Container(
          height: 50,
          margin: EdgeInsets.all(8),
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          decoration: BoxDecoration(
            color: Color.fromARGB(78, 59, 59, 59),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              width: 0.6,
              color: Color.fromARGB(255, 148, 148, 148),
            ),
          ),
          child: SizedBox(
            width: 200,
            child: Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      width: 0.6,
                      color: Color.fromARGB(255, 148, 148, 148),
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      '5.  ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Text('Michał'),
              ],
            ),
          ),
        )
      ]),
    );
  }
}
