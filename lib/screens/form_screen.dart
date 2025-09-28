import 'package:flutter/material.dart';
import 'package:flutter_crud_app/screens/users_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_crud_app/models/user_model.dart';
import 'package:flutter_crud_app/providers/user_provider.dart';

class FormScreen extends StatefulWidget {
  final User? user;

  const FormScreen({super.key, this.user});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _gender;

  late TextEditingController _firstNameCtrl;
  late TextEditingController _lastNameCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _usernameCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _ageCtrl;
  late TextEditingController _countryCtrl;
  late TextEditingController _titleCtrl;

  InputDecoration _inputDecoration(String label, {IconData? icon}) {
    return InputDecoration(
      prefixIcon: icon != null ? Icon(icon) : null,
      prefixIconColor: const Color.fromRGBO(0, 75, 254, 1),
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: Color.fromRGBO(0, 75, 254, 1),
          width: 2.5,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _firstNameCtrl = TextEditingController(text: widget.user?.firstName ?? "");
    _lastNameCtrl = TextEditingController(text: widget.user?.lastName ?? "");
    _emailCtrl = TextEditingController(text: widget.user?.email ?? "");
    _usernameCtrl = TextEditingController(text: widget.user?.username ?? "");
    _phoneCtrl = TextEditingController(text: widget.user?.phone ?? "");
    _ageCtrl = TextEditingController(text: widget.user?.age != null ? widget.user!.age.toString() : "",);
    _countryCtrl = TextEditingController(text: widget.user?.country ?? "");
    _titleCtrl = TextEditingController(text: widget.user?.title ?? "");

    _gender = widget.user?.gender ?? "male";
  }

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _emailCtrl.dispose();
    _usernameCtrl.dispose();
    _phoneCtrl.dispose();
    _ageCtrl.dispose();
    _countryCtrl.dispose();
    _titleCtrl.dispose();
    super.dispose();
  }

  void _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final newUser = User(
      id: widget.user?.id ?? DateTime.now().millisecondsSinceEpoch,
      firstName: _firstNameCtrl.text.trim(),
      lastName: _lastNameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      username: _usernameCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      gender: _gender ?? 'male',
      age: int.tryParse(_ageCtrl.text) ?? 0,
      country: _countryCtrl.text.trim(),
      title: _titleCtrl.text.trim(),
      image: widget.user?.image,
    );

    final prov = context.read<UserProvider>();

    if (widget.user == null) {
      await prov.createUser(newUser);

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("User Created")));
    } else {
      await prov.updateUser(newUser);

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("User information updated")));
    }

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => UsersScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.user != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? "Edit User" : "Create User")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(height: 14),
              TextFormField(
                cursorColor: Color.fromRGBO(0, 75, 254, 1),
                controller: _firstNameCtrl,
                decoration: _inputDecoration('First Name', icon: Icons.person),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'First name is required';
                  if (v.trim().length < 2) return 'At least 2 characters';
                  if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(v)) return 'Only letters allowed';
                  return null;
                },
              ),
              SizedBox(height: 24),
              TextFormField(
                cursorColor: Color.fromRGBO(0, 75, 254, 1),
                controller: _lastNameCtrl,
                decoration: _inputDecoration(
                  'Last name',
                  icon: Icons.person_outline,
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Last name is required';
                  if (v.trim().length < 2) return 'At least 2 characters';
                  if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(v)) return 'Only letters allowed';
                  return null;
                },
              ),
              SizedBox(height: 24),
              TextFormField(
                cursorColor: Color.fromRGBO(0, 75, 254, 1),
                controller: _emailCtrl,
                decoration: _inputDecoration('Email', icon: Icons.email),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Email is required';
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v)) return 'Invalid email';
                  return null;
                },
              ),
              SizedBox(height: 24),
              TextFormField(
                cursorColor: Color.fromRGBO(0, 75, 254, 1),
                controller: _usernameCtrl,
                decoration: _inputDecoration(
                  'Username',
                  icon: Icons.account_circle_outlined,
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Username is required';
                  if (v.contains(' ')) return 'No spaces allowed';
                  if (v.length < 4) return 'At least 4 characters';
                  return null;
                },
              ),
              SizedBox(height: 24),
              TextFormField(
                cursorColor: Color.fromRGBO(0, 75, 254, 1),
                controller: _phoneCtrl,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration('Phone', icon: Icons.phone),
                validator: (v) => v == null || v.trim().isEmpty
                    ? 'Phone number is required'
                    : null,
              ),
              SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _gender,
                      decoration: _inputDecoration("Gender", icon: Icons.wc),
                      items: const [
                        DropdownMenuItem(value: "male", child: Text("Male")),
                        DropdownMenuItem(value: "female", child: Text("Female")),
                      ],
                      onChanged: (val) {
                        setState(() {
                          _gender = val;
                        });
                      },
                      validator: (val) {
                        if (val == null || val.isEmpty) return "Gender is required";
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 16,),
                  Expanded(
                    child: TextFormField(
                      cursorColor: Color.fromRGBO(0, 75, 254, 1),
                      controller: _ageCtrl,
                      decoration: _inputDecoration('Age', icon: Icons.cake),
                      keyboardType: TextInputType.number,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Age is required';
                        final age = int.tryParse(v);
                        if (age == null) return 'Must be a number';
                        if (age <= 0 || age > 120) return 'Invalid age';
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              TextFormField(
                cursorColor: Color.fromRGBO(0, 75, 254, 1),
                controller: _countryCtrl,
                decoration: _inputDecoration('Country', icon: Icons.flag),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Country is required';
                  if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(v)) return 'Only letters allowed';
                  return null;
                },
              ),
              SizedBox(height: 24),
              TextFormField(
                cursorColor: Color.fromRGBO(0, 75, 254, 1),
                controller: _titleCtrl,
                decoration: _inputDecoration('Title', icon: Icons.work),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Title is required';
                  if (v.trim().length < 2) return 'At least 2 characters';
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
          color: Colors.white,
        ),
        padding: EdgeInsets.only(left: 16, right: 16, bottom: 30, top: 5),
        child: ElevatedButton.icon(
          onPressed: _onSubmit,
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromRGBO(0, 75, 254, 1),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          icon: Icon(Icons.save, color: Colors.white),
          label: Text(
            isEditing ? "Update" : "Create",
            style: const TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
