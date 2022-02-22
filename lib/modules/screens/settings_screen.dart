import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_flutter/cubit/cubit.dart';
import 'package:test_flutter/cubit/states.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          title: const Text(
            'Options',
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Use Local Database',
                      style: TextStyle(
                          fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                        'Instead using HTTP request, Please use SQLite',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey
                      ),
                    ),
                  ],
                ),
                trailing: Switch(
                  value: AppCubit.get(context).localDatabaseEnabled,
                  onChanged: (s) {
                    AppCubit.get(context).changeLocalDatabaseStatus();
                  },
                  activeColor: Colors.green,
                  inactiveThumbColor: Colors.red,
                ),
              ),
            ),
            Container(
              height: 1.0,
              width: double.infinity,
              color: Colors.grey[300],
            ),
          ],
        ),
      ),
    );
  }
}
