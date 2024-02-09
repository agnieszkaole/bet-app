import 'package:bet_app/src/constants/league_names.dart';
import 'package:bet_app/src/services/groups.dart';
import 'package:flutter/material.dart';

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

  late Map<String, dynamic>? selectedLeague;

  @override
  void initState() {
    super.initState();
    selectedLeague = leagueNames[0];
    // selectedLeague = null;
  }

  Future<String?> createNewGroup() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      await groups.createGroup(
          _groupName, _privacySettings, selectedLeague, members);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('You have created a new group: $_groupName'),
        ),
      );
      // Navigator.of(context).push(MaterialPageRoute(
      //   builder: (context) => GroupTabs(),
      // ));
      Navigator.of(context).pop();
    }
    return _groupName;
  }

  // padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  //           decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(12),
  //             color: Color.fromARGB(255, 32, 80, 162),
  // ),
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create a new group'),
        // titleSpacing: 10,
        leading: Container(
          // margin: EdgeInsets.only(left: 5),
          // decoration: BoxDecoration(
          //   borderRadius: BorderRadius.circular(12),
          //   color: Color.fromARGB(255, 32, 80, 162),
          // ),
          child: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: SizedBox(
              width: 300,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),
                  Container(
                    padding: EdgeInsets.only(bottom: 10),
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'Enter the group name',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ),
                  TextFormField(
                    autofocus: false,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                    decoration: InputDecoration(
                      errorStyle:
                          const TextStyle(color: Colors.red, fontSize: 14.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      contentPadding: EdgeInsets.zero,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: Color.fromARGB(255, 40, 122, 43)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.greenAccent),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: Color.fromARGB(255, 255, 52, 37)),
                      ),
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
                  const SizedBox(height: 40),
                  Container(
                    padding: EdgeInsets.only(bottom: 10),
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'Select a league',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.left,
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
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 40, 122, 43)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  const BorderSide(color: Colors.greenAccent),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 255, 52, 37)),
                            ),
                          ),
                          child: SizedBox(
                            height: 20,
                            child: DropdownButton<Map<String, dynamic>>(
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
                    title: const Text("Public"),
                    subtitle: const Text(
                        "Anyone can join without additional verification."),
                    activeColor: const Color.fromARGB(255, 40, 122, 43),
                    groupValue: _privacySettings,
                    onChanged: (val) => setState(() {
                      _privacySettings = val!;
                    }),
                  ),
                  RadioListTile(
                    value: 'private',
                    title: const Text("Private"),
                    subtitle: const Text("To join you need an access code."),
                    activeColor: const Color.fromARGB(255, 40, 122, 43),
                    groupValue: _privacySettings,
                    onChanged: (val) => setState(() {
                      _privacySettings = val!;
                    }),
                  ),
                  const SizedBox(height: 50),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: createNewGroup,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color.fromARGB(255, 40, 122, 43),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 5.0,
                      ),
                      child: const Text(
                        'Create a group',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
