import 'package:flutter/material.dart';
import 'package:flutter_crud_app/models/user_model.dart';
import 'package:flutter_crud_app/screens/user_detail_screen.dart';

class UserTile extends StatelessWidget {
  const UserTile({super.key, required this.user, required this.onDelete});
  final User user;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return ListTile(
                  leading: CircleAvatar(
                    radius: 40,
                    backgroundImage: 
                        user.image != null && user.image!.isNotEmpty 
                        ? NetworkImage(user.image!) 
                        : AssetImage('assets/images/blue-circle.jpg'),
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${user.firstName} ${user.lastName}'),
                      Text(
                        user.title,
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ],
                  ),
                  minTileHeight: 90,
                  trailing: IconButton(onPressed: onDelete, icon: Icon(
                    Icons.close_outlined,
                    color: Colors.red,
                    size: 25,
                  ),) ,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => UserDetailScreen(user: user)),
            ),
                );
  }
}