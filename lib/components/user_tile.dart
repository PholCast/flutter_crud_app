import 'package:flutter/material.dart';
import 'package:flutter_crud_app/models/user_model.dart';
import 'package:flutter_crud_app/screens/user_detail_screen.dart';

class UserTile extends StatelessWidget {
  const UserTile({super.key, required this.user, required this.onDelete});
  final User user;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                child: ListTile(
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
                  minTileHeight: 100,
                  trailing: IconButton(onPressed: onDelete, icon: Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.red,
                    size: 35,
                  ),) ,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => UserDetailScreen(user: user)),
            ),
                ),
              ),
            );
  }
}