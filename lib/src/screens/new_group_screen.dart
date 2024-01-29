import 'package:bet_app/src/services/groups.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NewGroupScreen extends StatefulWidget {
  NewGroupScreen({super.key});

  @override
  State<NewGroupScreen> createState() => _NewGroupScreenState();
}

class _NewGroupScreenState extends State<NewGroupScreen> {
  final _formKey = GlobalKey<FormState>();
  Groups groups = Groups();
  List<Map<String, dynamic>> members = [];
  String? _groupName;
  // String? _groupId;

  Future<String?> createNewGroup() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      await groups.createGroup(_groupName, members);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Utworzyłeś nową grupę $_groupName'),
        ),
      );
      Navigator.of(context).pop();
    }
    return _groupName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              TextFormField(
                autofocus: false,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: '?',
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
                    borderSide: const BorderSide(color: Colors.red),
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
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: createNewGroup,
                  style: ElevatedButton.styleFrom(
                    foregroundColor:
                        Colors.white, //change background color of button
                    backgroundColor: const Color.fromARGB(
                        255, 40, 122, 43), //change text color of button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 5.0,
                  ),
                  child: const Text('Zapisz'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
