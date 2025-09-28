import 'package:flutter/material.dart';

class ErrorTile extends StatelessWidget {
  const ErrorTile({super.key, required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      margin: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
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
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('An error has ocurred while loading users', style: TextStyle(color: Colors.red, fontSize: 16),),
            SizedBox(height: 8,),
            Text(message,maxLines: 3,overflow: TextOverflow.ellipsis,),
            SizedBox(height: 8),
            Align(
              alignment: Alignment.center,
              child: OutlinedButton.icon(onPressed: onRetry, label: Text('Reintentar'), icon: Icon(Icons.refresh) ),
            )
          ]        
        )
      ),
    );
  }
}