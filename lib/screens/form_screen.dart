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

  late TextEditingController _firstNameCtrl;
  late TextEditingController _lastNameCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _usernameCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _ageCtrl;
  late TextEditingController _countryCtrl;
  late TextEditingController _titleCtrl;

  @override
  void initState() {
    super.initState();
    _firstNameCtrl = TextEditingController(text: widget.user?.firstName ?? "");
    _lastNameCtrl = TextEditingController(text: widget.user?.lastName ?? "");
    _emailCtrl = TextEditingController(text: widget.user?.email ?? "");
    _usernameCtrl = TextEditingController(text: widget.user?.username ?? "");
    _phoneCtrl = TextEditingController(text: widget.user?.phone ?? "");
    _ageCtrl = TextEditingController(text: widget.user?.age.toString() ?? "");
    _countryCtrl = TextEditingController(text: widget.user?.country ?? "");
    _titleCtrl = TextEditingController(text: widget.user?.title ?? "");
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
      gender: widget.user?.gender ?? "male",
      age: int.tryParse(_ageCtrl.text) ?? 0,
      country: _countryCtrl.text.trim(),
      title: _titleCtrl.text.trim(),
      image: widget.user?.image,
    );

    final prov = context.read<UserProvider>();

    if (widget.user == null) {
      await prov.createUser(newUser);

      if(!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Usuario creado")));
    } else {
      await prov.updateUser(newUser);

      if(!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Usuario actualizado")));
    }

    if (mounted) {
    Navigator.pushReplacement(context,
    MaterialPageRoute(builder: (context) => UsersScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.user != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? "Editar Usuario" : "Crear Usuario"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _firstNameCtrl,
                decoration: const InputDecoration(labelText: "Nombre"),
                validator: (v) => v!.isEmpty ? "Campo requerido" : null,
              ),
              TextFormField(
                controller: _lastNameCtrl,
                decoration: const InputDecoration(labelText: "Apellido"),
                validator: (v) => v!.isEmpty ? "Campo requerido" : null,
              ),
              TextFormField(
                controller: _emailCtrl,
                decoration: const InputDecoration(labelText: "Email"),
                validator: (v) => v!.isEmpty ? "Campo requerido" : null,
              ),
              TextFormField(
                controller: _usernameCtrl,
                decoration: const InputDecoration(labelText: "Username"),
              ),
              TextFormField(
                controller: _phoneCtrl,
                decoration: const InputDecoration(labelText: "Teléfono"),
              ),
              TextFormField(
                controller: _ageCtrl,
                decoration: const InputDecoration(labelText: "Edad"),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _countryCtrl,
                decoration: const InputDecoration(labelText: "País"),
              ),
              TextFormField(
                controller: _titleCtrl,
                decoration: const InputDecoration(labelText: "Título"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _onSubmit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  isEditing ? "Actualizar" : "Crear",
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
