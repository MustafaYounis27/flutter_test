import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_flutter/cubit/cubit.dart';
import 'package:test_flutter/cubit/states.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Users',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: BlocBuilder<AppCubit, AppStates>(
          builder: (context, state) => ConditionalBuilder(
            condition: AppCubit.get(context).localDatabaseEnabled
                ? AppCubit.get(context).localUsers.isNotEmpty
                : AppCubit.get(context).allUsers.isNotEmpty,
            builder: (context) => ListView.separated(
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 15.0,
                ),
                child: Text(
                  '${AppCubit.get(context).localDatabaseEnabled ? AppCubit.get(context).localUsers[index]['username'] : AppCubit.get(context).allUsers[index].username}',
                  style: const TextStyle(
                    fontSize: 18.0,
                  ),
                ),
              ),
              separatorBuilder: (context, index) => Container(
                height: 1.0,
                width: double.infinity,
                color: Colors.grey[300],
              ),
              itemCount: AppCubit.get(context).localDatabaseEnabled
                  ? AppCubit.get(context).localUsers.length
                  : AppCubit.get(context).allUsers.length,
            ),
            fallback: (context) =>
                const Center(child: CircularProgressIndicator()),
          ),
        ),
      ),
    );
  }
}
