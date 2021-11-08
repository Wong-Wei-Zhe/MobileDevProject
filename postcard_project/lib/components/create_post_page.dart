import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:postcard_project/blocs/manage_post_bloc/manage_post_bloc.dart';
import 'package:postcard_project/blocs/postcard_bloc/postcard_bloc.dart';

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
  late final PostcardBloc _postcardBloc;
  bool _submitButtonAllowStatus = false;

  @override
  void initState() {
    _managePostBloc = BlocProvider.of<ManagePostBloc>(context);
    _postcardBloc = BlocProvider.of<PostcardBloc>(context);
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New PostCard'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0),
                      boxShadow: const [
                        BoxShadow(
                            offset: Offset(0, 3),
                            blurRadius: 5,
                            color: Colors.grey)
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _titleTextField,
                        maxLines: 1,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintText: 'Enter Title of Postcard',
                          labelText: 'PostCard Title',
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0),
                      boxShadow: const [
                        BoxShadow(
                            offset: Offset(0, 3),
                            blurRadius: 5,
                            color: Colors.grey)
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _descriptionTextField,
                        maxLines: 10,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintText: 'Enter Description of Postcard',
                          labelText: 'PostCard Description',
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0),
                      boxShadow: const [
                        BoxShadow(
                            offset: Offset(0, 3),
                            blurRadius: 5,
                            color: Colors.grey)
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _imgUrlTextField,
                        maxLines: 1,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintText: 'Enter Image Link',
                          labelText: 'PostCard Image',
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      alignment: WrapAlignment.spaceBetween,
                      spacing: 30,
                      direction: Axis.horizontal,
                      children: [
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
                  ),
                ],
              ),
            ),
            BlocListener<ManagePostBloc, ManagePostState>(
              listener: (context, state) {
                if (state is CreatePostSubmittingState) {
                  _snackBarCall('Submitting Postcard...');
                }
                if (state is CreatePostSucceedState) {
                  _snackBarCall('Postcard Submitted.');
                  _postcardBloc.add(const PostCardFetchEvent(
                      status: PostFetchStatus.refresh));
                  Navigator.of(context).pop(true);
                }
                if (state is ManagePostFailedState) {
                  _snackBarCall(state.toString());
                }
              },
              child: const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
