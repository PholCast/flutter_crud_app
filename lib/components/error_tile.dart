import 'package:flutter/material.dart';

class ErrorTile extends StatelessWidget {
  const ErrorTile({super.key, required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Text('Ha ocurrido un error', style: TextStyle(color: Colors.red, fontSize: 16),),
          SizedBox(height: 8,),
          Text(message,maxLines: 3,overflow: TextOverflow.ellipsis,),
          SizedBox(height: 8),
          Align(
            alignment: Alignment.center,
            child: OutlinedButton.icon(onPressed: onRetry, label: Text('Reintentar'), icon: Icon(Icons.refresh) ),
          )
        ]        
      )
    );
  }
}