
import 'package:firebase_chatapp/widgets/iMage_picker/iMage_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class AuthForM extends StatefulWidget{
  final Future<bool> Function(String eMail, String password, String userNaMe, bool isLogin, File? iMage) subMitFn;
  AuthForM({required this.subMitFn});
  @override
  State<AuthForM> createState() {
    return _AuthForMState();
  }
}
class _AuthForMState extends State<AuthForM>{
  var _forMKey = GlobalKey<FormState>();
  String _eMail = "";
  String _password = "";
  String _userNaMe = "";
  bool _isLogin = false;
  bool _isLoading = false;
  File? _iMage;

  void _subMit(){
    final bool valid = _forMKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if(!valid){
      return;
    }
    if(_isLogin){
      _forMKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      widget.subMitFn(
          _eMail.trim(), _password.trim(), _userNaMe.trim(), _isLogin, _iMage).then((
          value) {
        setState(() {
          _isLoading = value;
        });
      });
    }
    else {
      if (_iMage != null) {
        _forMKey.currentState!.save();
        setState(() {
          _isLoading = true;
        });
        widget.subMitFn(
            _eMail.trim(), _password.trim(), _userNaMe.trim(), _isLogin,
            _iMage!).then((value) {
          setState(() {
            _isLoading = value;
          });
        });
      }
      else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Please subMit iMage")));
      }
    }
  }
  void subMitIMage(File? iMage){
      this._iMage = iMage;
  }
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: Color.fromARGB(190, 250, 200, 110),
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _forMKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if(!_isLogin)
                  UserImagePicker(subMitIMage: this.subMitIMage,),
                TextFormField(
                  key: ValueKey("eMail"),
                  decoration: InputDecoration(
                    labelText: "EMail"
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value){
                    if(value!.isEmpty || !value.contains("@")){
                      return "Please enter eMail";
                    }
                  },
                  onSaved: (value){
                    _eMail = value!;
                  },
                ),
                if(!_isLogin)
                  TextFormField(
                    key: ValueKey("UsernaMe"),
                  decoration: InputDecoration(
                    labelText: "UsernaMe"
                  ),
                  validator: (value){
                    if(value!.isEmpty){
                      return "Please enter usernaMe";
                    }
                  },
                  onSaved: (value){
                    _userNaMe = value!;
                  },
                ),
                TextFormField(
                  key: ValueKey("password"),
                  decoration: InputDecoration(
                    labelText: "Password"
                  ),
                  obscureText: true,
                  validator: (value){
                    if(value!.isEmpty || value.length < 6){
                      return "Invalid password";
                    }
                  },
                  onSaved: (value){
                    _password = value!;
                  },
                ),
                SizedBox(height: 12,),
                if(_isLoading)
                  CircularProgressIndicator()
                else
                ElevatedButton(onPressed: _subMit, child: Text(_isLogin ? "Login" : "Signup"),
                ),
                if(!_isLoading)
                TextButton(onPressed: (){
                  setState(() {
                    _isLogin = !_isLogin;
                  });
                },
                child: Text(_isLogin ? "Create new account" : "I already have an account"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}