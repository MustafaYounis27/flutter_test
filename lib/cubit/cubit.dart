import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqflite/sqflite.dart';
import 'package:test_flutter/constant/strings.dart';
import 'package:test_flutter/models/note_model.dart';
import 'package:test_flutter/models/user_model.dart';
import 'package:test_flutter/shared/dio_helper.dart';

import 'states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  late Database database;

  void createDatabase() {
    openDatabase(
      'app.db',
      version: 1,
      onCreate: (database, version) {
        print('database created');
        database
            .execute(
            'CREATE TABLE notes (noteId  INTEGER PRIMARY KEY, text TEXT, date TEXT)')
            .then((value) {
              database.execute('CREATE TABLE users (username  , password TEXT, email TEXT, image TEXT, intrestId TEXT, userID INTEGER PRIMARY KEY)').then((value) {
                print('table created');
              });
        }).catchError((error) {
          print('Error When Creating Table ${error.toString()}');
        });
      },
      onOpen: (database) {
        getNotesFromDatabase(database);
        getUsersFromDatabase(database);
        print('database opened');
      },
    ).then((value) {
      database = value;
    });
  }

  List<Map> localNotes = [];

  void getNotesFromDatabase(database) {

    database.rawQuery('SELECT * FROM notes').then((value) {

      localNotes = value;

      emit(AppGetAllNotesState());
    });
  }

  List<Map> localUsers = [];

  void getUsersFromDatabase(database) {

    database.rawQuery('SELECT * FROM users').then((value) {

      localUsers = value;

      emit(AppGetAllUsersState());
    });
  }

  Future<void> insertUserToDatabase({
    required String username,
    required String password,
    required String email,
  }) async {

    await database.transaction((txn) {
      return txn
          .rawInsert(
        'INSERT INTO users(username, password, email, image, intrestId) VALUES("$username", "$password", "$email", "$userImage", "1")',
      )
          .then((value) {
        print('$value inserted successfully');

        getUsersFromDatabase(database);
        userImage = null;
      }).catchError((error) {
        print('Error When Inserting New Record ${error.toString()}');
      });
    });
  }

  Future<void> insertNotesToDatabase({
    required String text,
  }) async {
    String getDate = DateTime.now().toIso8601String();

    await database.transaction((txn) {
      return txn
          .rawInsert(
        'INSERT INTO notes(text, date) VALUES("$text", "$getDate")',
      )
          .then((value) {
        print('$value inserted successfully');

        getNotesFromDatabase(database);
      }).catchError((error) {
        print('Error When Inserting New Record ${error.toString()}');
      });
    });
  }

  List<UserModel> allUsers = [];

  void getUsers() async {
    allUsers.clear();
    await DioHelper.getData(
      url: getAllUsers,
    ).then((value) {
      value.data.forEach((element) {
        allUsers.add(UserModel.fromJson(element));
      });
      emit(AppGetAllUsersState());
    }).catchError((e) {
      print(e);
    });
  }

  List<NoteModel> allNotes = [];

  void getNotesFromServer() async {
    allNotes.clear();
    await DioHelper.getData(
      url: getAllNotes,
    ).then((value) {
      value.data.forEach((element) {
        allNotes.add(NoteModel.fromJson(element));
      });
      emit(AppGetAllNotesState());
    }).catchError((e) {
      print(e);
    });
  }

  var picker = ImagePicker();

  File? userImage;

  Future<void> getUserImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      userImage = File(pickedFile.path);
      emit(AppGetPictureState());
    } else {
      emit(AppGetPictureState());
    }
  }

  Future<int> addNewUser({
    required String username,
    required String password,
    required String email,
  }) async {
    int code = 0;
    await DioHelper.postData(
      url: insertUser,
      data: {
        "Username": username,
        "Password": password,
        "Email": email,
        "ImageAsBase64": userImage.toString(),
        "IntrestId": "1",
      },
    ).then((value) {
      getUsers();
      userImage = null;
      code = 200;
    }).catchError((e){
      print(e);
      code = 400;
    });
    return code;
  }

  Future<int> addNewNotes({
    required String text,
  }) async {
    int code = 0;
    await DioHelper.postData(
      url: insertNote,
      data: {
        "Text": text,
        "PlaceDateTime": DateTime.now().toIso8601String(),
      },
    ).then((value) {
      getNotesFromServer();
      code = 200;
    }).catchError((e){
      print(e);
      code = 400;
    });
    return code;
  }

  bool localDatabaseEnabled = false;

  void changeLocalDatabaseStatus()
  {
    localDatabaseEnabled = !localDatabaseEnabled;
    emit(AppChangeLocalDatabaseStatusState());
  }

}
