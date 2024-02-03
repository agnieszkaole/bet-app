import 'package:bet_app/src/constants/league_names.dart';
import 'package:bet_app/src/services/api_data.dart';
import 'package:bet_app/src/services/groups.dart';
import 'package:bet_app/src/widgets/next_match_list.dart';
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

  // Map<String, dynamic> selectedLeague = {};

  // @override
  // void initState() {
  //   super.initState();
  //   if (leagueNames.isNotEmpty) {
  //     selectedLeague = leagueNames.first;
  //   }
  // }

  Future<String?> createNewGroup() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      await groups.createGroup(_groupName, _privacySettings, members);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Utworzyłeś nową grupę: $_groupName'),
        ),
      );
      Navigator.of(context).pop();
    }
    return _groupName;
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic>? selectedLeague;
    return Scaffold(
      appBar: AppBar(
        title: Text('Utwórz nową grupę'),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: SizedBox(
            width: 300,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                TextFormField(
                  autofocus: false,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    // hintText: 'Podaj nazwę grup',
                    floatingLabelAlignment: FloatingLabelAlignment.center,
                    labelText: 'Nazwa grupy',
                    hintStyle: TextStyle(color: Colors.grey),
                    errorStyle: const TextStyle(
                      color: Colors.red, // Set the color of the error message
                      fontSize: 14.0, // Set the font size of the error message
                    ),
                    border: const OutlineInputBorder(),
                    contentPadding: EdgeInsets.zero,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: Color.fromARGB(255, 40, 122, 43)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.greenAccent),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: Color.fromARGB(255, 255, 52, 37)),
                    ),
                  ),
                  initialValue: "",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Wpisz nazwę grup';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _groupName = value;
                  },
                ),
                const SizedBox(height: 20),
                const Text(
                  'Wybierz ligę',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${selectedLeague['name'] ?? 'None'}',
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 20),
                    DropdownButton(
                      isExpanded: true,
                      value: selectedLeague,
                      onChanged: (Map<String, dynamic>? newValue) {
                        setState(() {
                          selectedLeague = newValue ?? {};
                        });
                      },
                      items: leagueNames
                          .map<DropdownMenuItem<Map<String, dynamic>>>(
                              (Map<String, dynamic> value) {
                        return DropdownMenuItem<Map<String, dynamic>>(
                          value: value,
                          child: Container(
                            height: 40,
                            child: Center(
                              child: Text(value['name'].toString()),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                RadioListTile(
                  value: 'public',
                  title: const Text("Publiczna"),
                  subtitle: const Text(
                      "Każdy może dołączyć bez dodatkowej weryfikacji"),
                  activeColor: const Color.fromARGB(255, 40, 122, 43),
                  groupValue: _privacySettings,
                  onChanged: (val) => setState(() {
                    _privacySettings = val!;
                  }),
                ),
                RadioListTile(
                  value: 'private',
                  title: const Text("Prywatna"),
                  subtitle:
                      const Text("Aby dołączyć potrzebny jest kod dostępu."),
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
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 5.0,
                    ),
                    child: const Text('Utwórz grupę'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
