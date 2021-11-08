import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:postcard_project/blocs/user_account_bloc/user_account_bloc.dart';
import 'package:postcard_project/components/post_main_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _userNameField = TextEditingController();
  late final UserAccountBloc userAccBloc;

  @override
  void initState() {
    userAccBloc = BlocProvider.of<UserAccountBloc>(context);
    userAccBloc.initializeApiListen();
    super.initState();
  }

  @override
  void dispose() {
    _userNameField.dispose();
    userAccBloc.add(UserClosedEvent());
    super.dispose();
  }

  void _snackBarCall(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar(
        reason: SnackBarClosedReason.remove,
      )
      ..showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                height: MediaQuery.of(context).size.width * 0.6,
                child: LayoutBuilder(builder: (context, constraint) {
                  return Icon(Icons.local_post_office_rounded,
                      size: constraint.biggest.height);
                }),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(35.0),
                  boxShadow: const [
                    BoxShadow(
                        offset: Offset(0, 3), blurRadius: 5, color: Colors.grey)
                  ],
                ),
                width: MediaQuery.of(context).size.width * 0.9,
                child: TextFormField(
                  controller: _userNameField,
                  decoration: const InputDecoration(
                    icon: Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Icon(Icons.person),
                    ),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintText: 'Enter your author name',
                    labelText: 'Author Name',
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: ElevatedButton(
                  onPressed: () {
                    userAccBloc.add(UserSignInEvent(_userNameField.text));
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Sign In',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              BlocListener<UserAccountBloc, UserAccountState>(
                listener: (context, state) {
                  if (state is UserSignInProgressingState) {
                    _snackBarCall('Logging In...');
                  }
                  if (state is UserSignInSuccessState) {
                    _snackBarCall('Success!');
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                PostMainPage(_userNameField.text)));
                  }
                  if (state is UserSignInFailedState) {
                    _snackBarCall(state.toString());
                  }
                },
                child: const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
