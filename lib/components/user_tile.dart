import 'package:flutter/material.dart';
import 'package:flutter_crud_app/models/user_model.dart';

class UserTile extends StatelessWidget {
  const UserTile({super.key, required this.user});
  final User user;

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
                borderRadius: BorderRadius.circular(12), // borde redondeado
              ),
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/images/blue-circle.jpg'), //!agregar un if para ver si tiene imagen o no
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
                  minTileHeight: 120,
                  trailing: IconButton(onPressed: ()=>{print('borrando usuario...')}, icon: Icon( //!hay que cambiar este onpressed
                    Icons.delete,
                    color: Colors.red,
                    size: 35,
                  ),) ,
                  onTap: () => print('ListTile tapped'),
                ),
              ),
            );
  }
}