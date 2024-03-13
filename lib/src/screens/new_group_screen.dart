import 'package:bet_app/src/constants/league_names.dart';
import 'package:bet_app/src/services/groups.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

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
  String? _groupRules;
  // String? _groupId;
  String? _privacySettings = 'public';

  late Map<String, dynamic>? selectedLeague;

  @override
  void initState() {
    super.initState();
    selectedLeague = leagueNames[0];
    // selectedLeague = null;
  }

  String generateGroupAccessCode(int length) {
    var uuid = const Uuid();
    String groupAccessCode = uuid.v4();
    if (groupAccessCode.length > length) {
      groupAccessCode = groupAccessCode.substring(0, length);
    }
    return groupAccessCode;
  }

  Future<String?> createNewGroup() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      String groupAccessCode = generateGroupAccessCode(8);
      await groups.createGroup(_groupName, _privacySettings, selectedLeague, members, groupAccessCode, _groupRules);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('You have created a new group: $_groupName'),
        ),
      );

      Navigator.of(context).pop(true);
    }
    return _groupName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create a new group'),
        leading: Container(
          child: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      body: Container(
        // constraints: BoxConstraints(maxWidth: kIsWeb ? 700.0 : MediaQuery.of(context).size.width),
        child: SingleChildScrollView(
          child: Center(
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: SizedBox(
                width: 310,
                child: Column(
                  children: [
                    const SizedBox(height: 50),
                    Container(
                      padding: EdgeInsets.only(bottom: 10),
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Enter the group name',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ),
                    TextFormField(
                      autofocus: false,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                      decoration: InputDecoration(
                        errorStyle: const TextStyle(color: Colors.red, fontSize: 14.0),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        contentPadding: EdgeInsets.all(10.0),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color.fromARGB(255, 40, 122, 43)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.greenAccent),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color.fromARGB(255, 255, 52, 37)),
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
                    const SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.only(bottom: 10),
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Enter the group rules',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ),
                    TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      autofocus: false,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                      decoration: InputDecoration(
                        errorStyle: const TextStyle(color: Colors.red, fontSize: 14.0),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        contentPadding: EdgeInsets.all(10.0),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color.fromARGB(255, 40, 122, 43)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.greenAccent),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color.fromARGB(255, 255, 52, 37)),
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
                        _groupRules = value;
                      },
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.only(bottom: 10),
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Select a league',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
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
                                borderSide: const BorderSide(color: Color.fromARGB(255, 40, 122, 43)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Colors.greenAccent),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Color.fromARGB(255, 255, 52, 37)),
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
                      title: const Text("Public"),
                      subtitle: const Text("Any user can join without additional conditions."),
                      activeColor: const Color.fromARGB(255, 40, 122, 43),
                      groupValue: _privacySettings,
                      onChanged: (val) => setState(() {
                        _privacySettings = val!;
                      }),
                    ),
                    RadioListTile(
                      value: 'private',
                      title: const Text("Private"),
                      subtitle: const Text("The user have to enter an access code to join the group."),
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
      ),
    );
  }
}
