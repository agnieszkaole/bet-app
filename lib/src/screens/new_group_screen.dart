import 'package:bet_app/src/constants/league_names.dart';
import 'package:bet_app/src/services/groups.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;

class NewGroupScreen extends StatefulWidget {
  const NewGroupScreen({super.key});

  @override
  State<NewGroupScreen> createState() => _NewGroupScreenState();
}

class _NewGroupScreenState extends State<NewGroupScreen> {
  final _formKey = GlobalKey<FormState>();
  Groups groups = Groups();
  List<Map<String, dynamic>> members = [];
  String? _groupName;
  // String? _groupId;
  String? _privacySettings = 'public';
  String? _groupNameError;

  late Map<String, dynamic>? selectedLeague;

  @override
  void initState() {
    super.initState();
    selectedLeague = leagueNames[0];
  }

  String generateGroupAccessCode(int length) {
    var uuid = const Uuid();
    String groupAccessCode = uuid.v4();
    if (groupAccessCode.length > length) {
      groupAccessCode = groupAccessCode.substring(0, length);
    }
    return groupAccessCode;
  }

  Future<void> createNewGroup(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      String groupAccessCode = generateGroupAccessCode(8);
      bool groupCreated =
          await groups.createGroup(_groupName, _privacySettings, selectedLeague, members, groupAccessCode);

      if (groupCreated) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('You have created a new group: $_groupName'),
          ),
        );
        Navigator.of(context).pop(true);
      } else {
        setState(() {
          _groupNameError = 'Group name "$_groupName" already exists.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Color.fromARGB(255, 26, 26, 26),
        title: Text('Create a new group'),
        leading: Container(
          child: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
            width: MediaQuery.of(context).size.width - 50,
            constraints: BoxConstraints(maxWidth: 400),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(25),
              ),
              border: Border.all(width: 0.4, color: Color.fromARGB(99, 206, 206, 206)),
              // color: Color.fromARGB(100, 39, 39, 39),
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Color.fromARGB(199, 50, 124, 15),
                  Color.fromARGB(200, 31, 77, 10),
                ],
              ),
            ),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  // const SizedBox(height: 50),
                  Container(
                    padding: EdgeInsets.only(bottom: 5),
                    alignment: Alignment.center,
                    child: const Text(
                      'Enter the group name',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                  TextFormField(
                    autofocus: false,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      errorStyle: const TextStyle(color: Colors.red, fontSize: 14.0),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                      contentPadding: EdgeInsets.all(10.0),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 93, 207, 40),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: const BorderSide(color: Color.fromARGB(255, 145, 255, 71)),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: const BorderSide(color: Color.fromARGB(255, 255, 52, 37)),
                      ),
                      errorText: _groupNameError,
                    ),
                    initialValue: "",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter the group name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _groupName = value;
                    },
                  ),
                  const SizedBox(height: 30),

                  Container(
                    padding: EdgeInsets.only(bottom: 5),
                    alignment: Alignment.center,
                    child: const Text(
                      'Select a league',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // const SizedBox(height: 10),
                      SingleChildScrollView(
                        child: InputDecorator(
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: const BorderSide(
                                color: Color.fromARGB(255, 93, 207, 40),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: const BorderSide(color: Colors.greenAccent),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: const BorderSide(color: Color.fromARGB(255, 145, 255, 71)),
                            ),
                          ),
                          child: SizedBox(
                            height: 20,
                            child: DropdownButton<Map<String, dynamic>>(
                              isExpanded: true,

                              underline: Container(
                                height: 0,
                              ),

                              value: selectedLeague,
                              // itemHeight: kMinInteractiveDimension,
                              items: leagueNames.map((league) {
                                return DropdownMenuItem<Map<String, dynamic>>(
                                  value: league,
                                  child: Center(
                                    child: Text(
                                      league['name'],
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedLeague = value!;
                                });
                              },
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  RadioListTile(
                    value: 'public',
                    title: Row(
                      children: [
                        const Text("Public"),
                        Text(
                          '  🔓',
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    subtitle: const Text("Any user can join without additional conditions."),
                    activeColor: const Color.fromARGB(255, 40, 122, 43),
                    groupValue: _privacySettings,
                    onChanged: (val) => setState(() {
                      _privacySettings = val!;
                    }),
                  ),
                  RadioListTile(
                    value: 'private',
                    title: Row(
                      children: [
                        const Text("Private"),
                        Text(
                          '  🔐',
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    subtitle: const Text("The user have to enter an access code to join the group."),
                    activeColor: const Color.fromARGB(255, 40, 122, 43),
                    groupValue: _privacySettings,
                    onChanged: (val) => setState(() {
                      _privacySettings = val!;
                    }),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Once you create the group, you will be able to invite your friends to join it',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        createNewGroup(context);
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Color.fromARGB(255, 45, 139, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text(
                        'Create a group',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
