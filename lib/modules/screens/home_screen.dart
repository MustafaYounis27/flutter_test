import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_flutter/cubit/cubit.dart';
import 'package:test_flutter/cubit/states.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Notes',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/add/user');
                },
                icon: const Icon(
                  Icons.person_add,
                  color: Colors.white,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/options');
                },
                icon: const Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
              ),
              IconButton(
                onPressed: () {
                  AppCubit.get(context).getUsers();
                  Navigator.pushNamed(context, '/users');
                },
                icon: const Icon(
                  Icons.sort,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(
              15.0,
            ),
            child: Column(
              children: [
                buildSearchRow(),
                const SizedBox(
                  height: 15.0,
                ),
                Expanded(
                  child: ConditionalBuilder(
                    condition: AppCubit.get(context).localDatabaseEnabled
                        ? AppCubit.get(context).localNotes.isNotEmpty
                        : AppCubit.get(context).allNotes.isNotEmpty,
                    builder: (context) => ListView.separated(
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 15.0,
                        ),
                        child: Text(
                          '${AppCubit.get(context).localDatabaseEnabled ? AppCubit.get(context).localNotes[index]['text'] : AppCubit.get(context).allNotes[index].noteText}',
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
                          ? AppCubit.get(context).localNotes.length
                          : AppCubit.get(context).allNotes.length,
                    ),
                    fallback: (context) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/add/note');
            },
            child: const Icon(
              Icons.add,
            ),
          ),
        );
      },
    );
  }

  buildSearchRow() => Row(
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search,
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsetsDirectional.only(
                start: 10.0,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  10.0,
                ),
                border: Border.all(
                  width: 1.0,
                  color: Colors.grey,
                ),
              ),
              child: TextFormField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'search',
                  suffixIcon: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.close,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
}
