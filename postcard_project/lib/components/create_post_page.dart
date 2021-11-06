import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:postcard_project/blocs/manage_post_bloc/manage_post_bloc.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({Key? key}) : super(key: key);

  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final _titleTextField = TextEditingController();
  final _descriptionTextField = TextEditingController();
  final _imgUrlTextField = TextEditingController();
  late final ManagePostBloc _managePostBloc;
  bool _submitButtonAllowStatus = false;

  @override
  void initState() {
    _managePostBloc = BlocProvider.of<ManagePostBloc>(context);
    _managePostBloc.initializeApiListen();
    _titleTextField.addListener(_ifSubmitPostCardAllow);
    _descriptionTextField.addListener(_ifSubmitPostCardAllow);
    _imgUrlTextField.addListener(_ifSubmitPostCardAllow);
    super.initState();
  }

  @override
  void dispose() {
    _titleTextField.dispose();
    _descriptionTextField.dispose();
    _imgUrlTextField.dispose();
    super.dispose();
  }

  void _ifSubmitPostCardAllow() {
    setState(() {
      if (_titleTextField.text.isNotEmpty &&
          _descriptionTextField.text.isNotEmpty &&
          _imgUrlTextField.text.isNotEmpty) {
        _submitButtonAllowStatus = true;
      } else {
        _submitButtonAllowStatus = false;
      }
    });
  }

  void _snackBarCall(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar(
        reason: SnackBarClosedReason.remove,
      )
      ..showSnackBar(snackBar);
  }

  void _postCardSubmitButton() {
    _managePostBloc.add(CreatePostEvent(_titleTextField.text,
        _descriptionTextField.text, _imgUrlTextField.text));

    // ScaffoldMessenger.of(context)
    //     .showSnackBar(snackBar)
    //     .closed
    //     .then((SnackBarClosedReason reason) {
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(builder: (context) => HomePage()),
    //   );
    // });

    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => HomePage()),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create PostCard Page'),
      ),
      body: Column(
        children: [
          Column(
            children: <Widget>[
              const Text('Title'),
              TextFormField(
                controller: _titleTextField,
                maxLines: 1,
              ),
              const Text('Description'),
              TextFormField(
                controller: _descriptionTextField,
                maxLines: 10,
              ),
              const Text('Image Url'),
              TextFormField(
                controller: _imgUrlTextField,
                maxLines: 1,
              ),
            ],
          ),
          Row(
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  //userAccBloc.add(UserSignInEvent());
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: !_submitButtonAllowStatus
                    ? null
                    : () {
                        _postCardSubmitButton();
                      },
                child: const Text('Submit Postcard'),
              ),
            ],
          ),
          BlocListener<ManagePostBloc, ManagePostState>(
            listener: (context, state) {
              if (state is CreatePostSubmittingState) {
                _snackBarCall('Submitting Postcard...');
              }
              if (state is CreatePostSucceedState) {
                _snackBarCall('Postcard Submitted.');
                Navigator.of(context).pop();
              }
              if (state is ManagePostFailedState) {
                _snackBarCall(state.toString());
              }
            },
            child: const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
