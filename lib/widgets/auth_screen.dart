import 'package:flutter/material.dart';

import 'package:animated_text_kit/animated_text_kit.dart';

enum AuthMode { SignUp, Login }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth_screen';
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(255, 77, 210, 1).withOpacity(0.5),
                  Color.fromRGBO(255, 77, 210, 1).withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20.0),
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 50.0),

                      // ..translate(-10.0),
                      child: ColorizeAnimatedTextKit(
                          onTap: () {
                            print("Tap Event");
                          },
                          text: [
                            "HNIN Warehouse",
                          ],
                          repeatForever: true,
                          speed: Duration(seconds: 1),
                          textStyle: TextStyle(
                              fontSize: 30.0,
                              fontFamily: "Lato",
                              fontWeight: FontWeight.bold),
                          colors: [
                            Colors.purple,
                            Colors.blue,
                            Colors.yellow,
                            Colors.red,
                          ],
                          textAlign: TextAlign.start,
                          alignment: AlignmentDirectional
                              .topStart // or Alignment.topLeft
                          ),
                      // child: TextLiquidFill(
                      //   text: 'HNIN Warehouse',
                      //   waveColor: Colors.blueAccent,
                      //   boxBackgroundColor: Colors.pinkAccent,
                      //   boxHeight: 100,
                      //   textStyle: TextStyle(
                      //     fontSize: 30.0,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: AuthCard(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  AuthMode _authMode = AuthMode.Login;
  AnimationController _animationController;
  Animation<Offset> _slideAnimation;
  Animation<double> _opacityAnimation;
  TextEditingController _passwordEditingController;
  FocusNode _passwordFocusNode = FocusNode();
  FocusNode _confirmFocusNode = FocusNode();
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  final GlobalKey<FormState> _formKey = GlobalKey();
  var _isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _slideAnimation = Tween<Offset>(begin: Offset(0, -0.15), end: Offset(0, 0))
        .animate(CurvedAnimation(
            parent: _animationController, curve: Curves.linear));
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.linear));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _animationController.dispose();
    _passwordFocusNode.dispose();
    _confirmFocusNode.dispose();
    _passwordEditingController.dispose();
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.SignUp;
      });
      _animationController.forward();
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
      _animationController.reverse();
    }
  }

  void _submit() {}
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.linear,
        height: _authMode == AuthMode.SignUp ? 320 : 260,
        constraints:
            BoxConstraints(minHeight: _authMode == AuthMode.SignUp ? 320 : 260),
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                  ),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value.isEmpty || !value.contains('@')) {
                      return 'Invalid Email';
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_passwordFocusNode);
                  },
                  onSaved: (value) {
                    _authData['email'] = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Password',
                  ),
                  focusNode: _passwordFocusNode,
                  textInputAction: _authMode == AuthMode.SignUp
                      ? TextInputAction.next
                      : TextInputAction.done,
                  controller: _passwordEditingController,
                  validator: (value) {
                    if (value.isEmpty || value.length < 5) {
                      return 'Password is too short!';
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_confirmFocusNode);
                  },
                  onSaved: (value) {
                    _authData['password'] = value;
                  },
                ),
                if (_authMode == AuthMode.SignUp)
                  AnimatedContainer(
                    constraints: BoxConstraints(
                      minHeight: _authMode == AuthMode.SignUp ? 60 : 0,
                      maxHeight: _authMode == AuthMode.SignUp ? 120 : 0,
                    ),
                    duration: Duration(milliseconds: 300),
                    curve: Curves.linear,
                    child: FadeTransition(
                      opacity: _opacityAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: TextFormField(
                          decoration:
                              InputDecoration(labelText: 'Confirm Password'),
                          focusNode: _confirmFocusNode,
                          enabled: _authMode == AuthMode.SignUp,
                        ),
                      ),
                    ),
                  ),
                SizedBox(
                  height: 10,
                ),
                if (_isLoading)
                  CircularProgressIndicator()
                else
                  RaisedButton.icon(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    onPressed: _submit,
                    icon: _authMode == AuthMode.Login
                        ? Icon(Icons.login)
                        : Icon(Icons.account_circle),
                    textColor: Colors.white,
                    elevation: 10,
                    label: Text(
                        _authMode == AuthMode.Login ? 'LOG IN' : 'SIGN UP'),
                    color: Color.fromRGBO(255, 77, 210, 1),
                  ),
                FlatButton.icon(
                  onPressed: _switchAuthMode,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  icon: _authMode == AuthMode.Login
                      ? Icon(Icons.account_circle)
                      : Icon(Icons.login),
                  textColor: Colors.black,
                  label: Text(
                      '${_authMode == AuthMode.Login ? 'SIGN UP' : 'LOG IN'} INSTEAD'),
                  //color: Color.fromRGBO(255, 77, 210, 1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
