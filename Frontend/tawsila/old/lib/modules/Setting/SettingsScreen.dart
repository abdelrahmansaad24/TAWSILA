import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tawsila/modules/log-in/SignInScreen.dart';
import 'package:toast/toast.dart';
import '../../shared/components/Components.dart';
import '../home-page/HomePage.dart';
import '../signup/cubit/SignUpCubit.dart';
import '../signup/cubit/SignUpStates.dart';

import 'dart:io';

class SettingsScreen extends StatelessWidget {
  var language = "";

  SettingsScreen({super.key, required this.language});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: language == "English"? TextDirection.ltr: TextDirection.rtl,
      child: BlocProvider(
        create: (context) =>
        SignUpCubit()
          ..setLanguage(l: language)
          ..readJson('settings'),
        child: BlocConsumer<SignUpCubit, SignUpStates>(
            listener: (context, state) {},
            builder: (context, state) {
              var signUpCubit = SignUpCubit.get(context);
              return Scaffold(
                appBar: AppBar(
                  elevation: 1,
                  leading: IconButton(
                    onPressed: () {
                      navigateAndFinish(context: context, screen: EditProfilePageState(language: language,edit: false,));
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                ),
                body: Container(
                    padding: const EdgeInsets.only(left: 16, top: 25, right: 16),
                    child: ListView(
                        children: [
                          Text(
                            "${signUpCubit.items['settings']??''}",
                            style: const TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.person,
                                color: Colors.blue,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                "${signUpCubit.items['account']??''}",
                                style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const Divider(
                            height: 15,
                            thickness: 2,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            onTap: (){
                              navigateTo(context: context, screen: EditProfilePage(language: language, edit: true));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${signUpCubit.items['edit profile']??''}",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[600]
                                  ),
                                ),
                                const Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30,),
                          GestureDetector(
                            onTap: (){
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("${signUpCubit.items['language']??''}"),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextButton(
                                              onPressed: () {
                                                language = "العربية";
                                                Navigator.of(context).push(MaterialPageRoute(
                                                    builder: (BuildContext context) => SettingsScreen(language: language)));
                                              },
                                              child: const Text("العربية",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                ),)),
                                          const SizedBox(height: 10,),
                                          TextButton(
                                              onPressed: () {
                                                language = "English";
                                                Navigator.of(context).push(MaterialPageRoute(
                                                    builder: (BuildContext context) => SettingsScreen(language: language)));
                                              },
                                              child: const Text("English",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                ),
                                              )),
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("${signUpCubit.items['close']??''}",
                                              style: const TextStyle(
                                                fontSize: 20,
                                              ),
                                            )),
                                      ],
                                    );
                                  });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${signUpCubit.items['language']??''}",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[600]
                                  ),
                                ),
                                const Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 65,
                          ),
                          Center(
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 40),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                              ),
                              onPressed: () {
                                navigateAndFinish(context: context, screen: SignInScreen(language: language));
                              },
                              child: Text(
                                  "${signUpCubit.items['signout']??''}",
                                  style: const TextStyle(
                                      fontSize: 16, letterSpacing: 2.2, color: Colors.black)),
                            ),
                          )
                        ]
                    )
                ),
              );
            }
        ),
      ),
    );
  }
}

class EditProfilePage extends StatefulWidget {
  var language = "";
  bool edit = false;
  EditProfilePage({super.key ,required this.language,required this.edit});
  @override
  EditProfilePageState createState() => EditProfilePageState(language: language,edit: false,);
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

class EditProfilePageState extends State<EditProfilePage> {
  bool edit = true;
  var fName = "";
  var lName = "";
  var email = "";
  var phone = "";
  var city = "";
  var language = "";
  PickedFile _imageFile = PickedFile("");
  final ImagePicker _picker = ImagePicker();
  EditProfilePageState({ required this.language, required this.edit });
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: language == "English"? TextDirection.ltr: TextDirection.rtl,
      child: BlocProvider(
        create: (context) => SignUpCubit()..setLanguage(l: language)..readJson('SignUp'),
        child: BlocConsumer<SignUpCubit, SignUpStates>(
            listener: (context, state) {},
            builder: (context, state) {
              var signUpCubit = SignUpCubit.get(context);
              return Scaffold(
                appBar: bar(context,),
                body: Container(
                  padding: const EdgeInsets.only(left: 16, top: 25, right: 16),
                  child: GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                    },
                    child: ListView(
                      children: [
                        header(context, signUpCubit),
                        const SizedBox(
                          height: 15,
                        ),
                        Center(
                          child: Stack(
                            children: [
                              Container(
                                width: 130,
                                height: 130,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 4,
                                        color: Theme.of(context).scaffoldBackgroundColor),
                                    boxShadow: [
                                      BoxShadow(
                                          spreadRadius: 2,
                                          blurRadius: 10,
                                          color: Colors.black.withOpacity(0.1),
                                          offset: const Offset(0, 10))
                                    ],
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      // image: NetworkImage(
                                      //   "link returned from server",
                                      // )
                                      image: _imageFile.path==""? AssetImage('assets/images/owner.png') : FileImage(File(_imageFile.path)) as ImageProvider,
                                    )
                                ),
                              ),
                              Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        width: 4,
                                        color: Theme.of(context).scaffoldBackgroundColor,
                                      ),
                                      color: Colors.blue,
                                    ),
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        //upload photo
                                        showModalBottomSheet(
                                            context: context,
                                            builder: (builder) => bottomSheet(context,signUpCubit),
                                        );
                                      },

                                    ),
                                  )),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 35,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children:<Widget> [
                            Flexible(
                              child:TextField(
                                enableInteractiveSelection: edit, // will disable paste operation
                                focusNode: (edit)? null : AlwaysDisabledFocusNode(),
                                onChanged: (value){
                                  fName = value;
                                },
                                decoration: InputDecoration(
                                    labelText: signUpCubit.items['Fname']??"",
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                    // hintText: "first name returned from server"
                                    hintText: "user",

                                    hintStyle: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black
                                    )
                                ),
                              ),
                            ),
                            const SizedBox(width: 15,),
                            Flexible(
                              child:TextField(
                                enableInteractiveSelection: edit, // will disable paste operation
                                focusNode: (edit)? null : AlwaysDisabledFocusNode(),
                                onChanged: (value){
                                  lName = value;
                                },
                                decoration: InputDecoration(
                                    labelText: signUpCubit.items['Lname']??"",
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                    // hintText: "last name returned from server"
                                    hintText: "name",
                                    hintStyle: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black
                                    )
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10,),
                        TextField(
                          enableInteractiveSelection: edit, // will disable paste operation
                          focusNode: (edit)? null : AlwaysDisabledFocusNode(),
                          onChanged: (value){
                            email = value;
                          },
                          decoration: InputDecoration(
                              labelText: signUpCubit.items['email']??"",
                              prefixIcon: const Icon(Icons.email),
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              // hintText: "email returned from server"
                              hintText: "joe@example.com",
                              hintStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black
                              )
                          ),
                        ),
                        const SizedBox(height: 10,),
                        TextField(
                          enableInteractiveSelection: edit, // will disable paste operation
                          focusNode: (edit)? null : AlwaysDisabledFocusNode(),
                          keyboardType: TextInputType.phone,
                          onChanged: (value){
                            phone = value;
                          },
                          decoration: InputDecoration(
                              labelText: signUpCubit.items['phone']??"",
                              prefixIcon: const Icon(Icons.phone),
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              // hintText: "phone returned from server"
                              hintText: "+201234567891",
                              hintStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black
                              )
                          ),
                        ),
                        const SizedBox(height: 10,),
                        TextField(
                          enableInteractiveSelection: edit, // will disable paste operation
                          focusNode: (edit)? null : AlwaysDisabledFocusNode(),
                          onChanged: (value){
                            city = value;
                          },
                          decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.location_city),
                              labelText: signUpCubit.items['city']??"",
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              // hintText: "email returned from server"
                              hintText: "alexandria",

                              hintStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black
                              )
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        buttons(context, signUpCubit),
                      ],
                    ),
                  ),
                ),
              );
            }
        ),
      ),
    );
  }
  Text header(BuildContext context,var signUpCubit){
    if(edit) {
      return Text(
        "${signUpCubit.items['edit profile']??''}",
        style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
      );
    }
    return Text(
      "${signUpCubit.items['profile']??''}",
      style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
    );
  }
  AppBar bar(BuildContext context){
    if(edit){
      return AppBar(
        elevation: 1,
        leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              navigateTo(
                  context: context, screen: SettingsScreen(language: language));
            }
        ),
      );
    }
    return AppBar(
      elevation: 1,
      leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            navigateAndFinish(
                context: context, screen: HomePageScreen(language: language));
          }
      ),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.settings,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => SettingsScreen(language: language)));
          },
        ),
      ],
    );
  }
  Row buttons(BuildContext context,var signUpCubit){
    ToastContext toast = ToastContext();
    if(edit) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          OutlinedButton(
            onPressed: (){
              navigateAndFinish(context: context, screen: SettingsScreen(language: language));
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            ),
            child: Text(
                "${signUpCubit.items['cancel']??""}",
                style: const TextStyle(
                    fontSize: 14,
                    letterSpacing: 2.2,
                    color: Colors.black)),
          ),
          ElevatedButton(
            onPressed: () {
              bool error = false;
              if(email != "" ){
                if((!EmailValidator.validate(email, true))) {
                  error = true;
                  toast.init(context);
                  Toast.show("${signUpCubit.items['emailError']??""}",
                      duration: Toast.lengthShort, backgroundColor: Colors.red
                  );
                }
              }
              if(!error && (phone != "")){
                if(phone.length != 13) {
                  error = true;
                  toast.init(context);
                  Toast.show("${signUpCubit.items['phoneError']??""}",
                      duration: Toast.lengthShort, backgroundColor: Colors.red
                  );
                }
              }
              if(!error&& (email!="" || phone!="" || fName != "" || lName != "" || city != "")){
                toast.init(context);
                Toast.show("${signUpCubit.items['profileEdited']??""}",
                    duration: Toast.lengthShort, backgroundColor: Colors.green
                );
              }
              if(!error){
                navigateAndFinish(context: context, screen: SettingsScreen(language: language));
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(horizontal: 50),
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            ),
            child: Text(
              "${signUpCubit.items['save']??""}",
              style: const TextStyle(
                  fontSize: 14,
                  letterSpacing: 2.2,
                  color: Colors.white),
            ),

          )
        ],
      );
    } else {
      return Row();
    }
  }
  Widget bottomSheet(BuildContext context,var signUpCubit) {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          Text(
            "${signUpCubit.items['choosePicture']??""}",
            style: const TextStyle(
              fontSize: 20.0,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            TextButton(onPressed: () {takePhoto(ImageSource.camera);}, child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                const Icon(Icons.camera),
                Text("${signUpCubit.items['camera']??""}"),
              ],
            )),
            const SizedBox(width: 50,),
            TextButton(onPressed: () {takePhoto(ImageSource.gallery);}, child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                const Icon(Icons.image),
                Text("${signUpCubit.items['gallery']??""}"),
              ],
            )),
          ])
        ],
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.getImage(
      source: source,
    );
    setState(() {
      _imageFile = pickedFile!;
    });
  }
}