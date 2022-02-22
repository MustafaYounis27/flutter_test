import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:test_flutter/cubit/cubit.dart';
import 'package:test_flutter/cubit/states.dart';

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({Key? key}) : super(key: key);

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  var formKey = GlobalKey<FormState>();
  var usernameController = TextEditingController();
  var passwordController = TextEditingController();
  var emailController = TextEditingController();

  bool isVisible = false;
  IconData passwordIcon = Icons.visibility;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          title: const Text(
            'Add User',
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      AppCubit.get(context).getUserImage();
                    },
                    child: AppCubit.get(context).userImage != null
                        ? CircleAvatar(
                            radius: 60.0,
                            backgroundImage: FileImage(
                              AppCubit.get(context).userImage!,
                            ),
                          )
                        : InkWell(
                            onTap: () {
                              AppCubit.get(context).getUserImage();
                            },
                            child: const CircleAvatar(
                                radius: 60.0,
                                child: Icon(
                                  Icons.camera_alt,
                                  size: 50.0,
                                )),
                          ),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  const Text(
                    'Select Image',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 40.0,
                  ),
                  TextFormField(
                    controller: usernameController,
                    keyboardType: TextInputType.name,
                    maxLines: null,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'username',
                    ),
                    validator: (String? s) {
                      if (s == null || s.isEmpty) {
                        return 'username must not be empty';
                      }
                    },
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  TextFormField(
                    controller: passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: !isVisible,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'password',
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            changePasswordVisibility();
                          });
                        },
                        icon: Icon(
                          passwordIcon,
                        ),
                      ),
                    ),
                    validator: (String? s) {
                      if (s == null || s.isEmpty) {
                        return 'password must not be empty';
                      } else if (s.length < 8) {
                        return 'password must have minimum 8 chars';
                      }
                    },
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    maxLines: null,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'email',
                    ),
                    validator: (String? s) {
                      if (s == null || s.isEmpty) {
                        return 'email must not be empty';
                      } else if (!EmailValidator.validate(s)) {
                        return 'email incorrect';
                      }
                    },
                  ),
                  const SizedBox(
                    height: 60.0,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30.0,
                    ),
                    width: double.infinity,
                    height: 40.0,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          if (AppCubit.get(context).userImage == null) {
                            Fluttertoast.showToast(
                              msg: 'please select an Image',
                              toastLength: Toast.LENGTH_SHORT,
                            );
                          } else {
                            if (AppCubit.get(context).localDatabaseEnabled) {
                              AppCubit.get(context).insertUserToDatabase(
                                username: usernameController.text,
                                password: passwordController.text,
                                email: emailController.text,
                              );
                              Fluttertoast.showToast(
                                msg: 'Note added successfully',
                                toastLength: Toast.LENGTH_SHORT,
                              );
                              Navigator.pop(context);
                            } else {
                              await AppCubit.get(context)
                                  .addNewUser(
                                username: usernameController.text,
                                password: passwordController.text,
                                email: emailController.text,
                              )
                                  .then((value) {
                                if (value == 200) {
                                  Fluttertoast.showToast(
                                    msg: 'Note added successfully',
                                    toastLength: Toast.LENGTH_SHORT,
                                  );
                                  Navigator.pop(context);
                                } else {
                                  Fluttertoast.showToast(
                                    msg: 'some Error Happened',
                                    toastLength: Toast.LENGTH_SHORT,
                                  );
                                }
                              });
                            }
                          }
                        }
                      },
                      child: const Text(
                        'save',
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
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

  void changePasswordVisibility() {
    isVisible = !isVisible;
    if (passwordIcon == Icons.visibility) {
      passwordIcon = Icons.visibility_off;
    } else {
      passwordIcon = Icons.visibility;
    }
  }
}
