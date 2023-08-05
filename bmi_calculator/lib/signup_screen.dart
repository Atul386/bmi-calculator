import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';

class SignUp extends StatefulWidget {
  final String email;
  final String name;
  final String password;
  final String confirmpassword;
  final String homeAddress;
  final String postcode;
  final String mobileNumber;

  SignUp({
    this.email = '',
    this.name = '',
    this.password = '',
    this.confirmpassword = '',
    this.homeAddress = '',
    this.postcode = '',
    this.mobileNumber = '',
  });

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  List<Map<String, String>> usersData = [];
  int _currentStep = 0;
  StepperType stepperType = StepperType.vertical;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _homeAddressController = TextEditingController();
  final TextEditingController _postcodeController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.name;
    _emailController.text = widget.email;
    _passwordController.text = widget.password;
    _confirmPasswordController.text = widget.confirmpassword;
    _homeAddressController.text = widget.homeAddress;
    _postcodeController.text = widget.postcode;
    _mobileNumberController.text = widget.mobileNumber;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Flutter BMI Demo'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Container(
          child: Column(
            children: [
              Expanded(
                child: Stepper(
                  type: stepperType,
                  physics: ScrollPhysics(),
                  currentStep: _currentStep,
                  onStepTapped: (step) => tapped(step),
                  onStepContinue: continued,
                  onStepCancel: cancel,
                  steps: <Step>[
                    Step(
                      title: Text('Account'),
                      content: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: _nameController,
                            decoration: const InputDecoration(labelText: 'Enter Name'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(labelText: 'Email Address'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              // Add more email validation if needed
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _passwordController,
                            decoration: const InputDecoration(labelText: 'Password'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a password';
                              }
                              // Add more password validation if needed
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _confirmPasswordController,
                            decoration: const InputDecoration(labelText: 'Confirm Password'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please confirm your password';
                              } else if (value != _passwordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                      isActive: _currentStep >= 0,
                      state: _currentStep >= 0 ? StepState.complete : StepState.disabled,
                    ),
                    Step(
                      title: const Text('Address'),
                      content: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: _homeAddressController,
                            decoration: const InputDecoration(labelText: 'Home Address'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your home address';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _postcodeController,
                            decoration: const InputDecoration(labelText: 'Postcode'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your postcode';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                      isActive: _currentStep >= 0,
                      state: _currentStep >= 1 ? StepState.complete : StepState.disabled,
                    ),
                    Step(
                      title: const Text('Mobile Number'),
                      content: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: _mobileNumberController,
                            decoration: const InputDecoration(labelText: 'Mobile Number'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your mobile number';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                      isActive: _currentStep >= 0,
                      state: _currentStep >= 2 ? StepState.complete : StepState.disabled,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    const Text("Already have an account?"),
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to login page
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      child: const Text("Sign In"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  switchStepsType() {
    setState(() => stepperType == StepperType.vertical
        ? stepperType = StepperType.horizontal
        : stepperType = StepperType.vertical);
  }

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  continued() async {
    if (_currentStep < 2) {
      setState(() => _currentStep += 1);
    } else {
      // If it's the last step, save data and navigate to the login page
      if (_formKey.currentState!.validate()) {
        saveDataToSharedPreferences();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      }
    }
  }

  cancel() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }

  // Save data to SharedPreferences
  Future<void> saveDataToSharedPreferences() async {
    final newUser = {
      'email': _emailController.text,
      'name': _nameController.text,
      'password': _passwordController.text,
      'homeAddress': _homeAddressController.text,
      'postcode': _postcodeController.text,
      'mobileNumber': _mobileNumberController.text,
    };

    usersData.add(newUser);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('usersData', jsonEncode(usersData));
  }
}
