import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:test_flutter/cubit/cubit.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({Key? key}) : super(key: key);

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {

  var formKey = GlobalKey<FormState>();
  var textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Notes',
        ),
        actions: [
          IconButton(
            onPressed: () async
            {
              if(formKey.currentState!.validate()) {
                if(AppCubit.get(context).localDatabaseEnabled){
                  AppCubit.get(context).insertNotesToDatabase(text: textController.text).then((value){
                    Fluttertoast.showToast(
                      msg: 'Note added successfully',
                      toastLength: Toast.LENGTH_SHORT,
                    );
                    Navigator.pop(context);
                  });
                } else{
                  await AppCubit.get(context).addNewNotes(text: textController.text).then((value){
                    if(value == 200) {
                      Fluttertoast.showToast(
                        msg: 'Note added successfully',
                        toastLength: Toast.LENGTH_SHORT,
                      );
                      Navigator.pop(context);
                    } else{
                      Fluttertoast.showToast(
                        msg: 'some Error Happened',
                        toastLength: Toast.LENGTH_SHORT,
                      );
                    }
                  });
                }
              }
            },
            icon: const Icon(
              Icons.save,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Expanded(
                child: TextFormField(
                  controller: textController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Notes',
                  ),
                  validator: (String? s)
                  {
                    if(s == null || s.isEmpty){
                      return 'must not be empty';
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
