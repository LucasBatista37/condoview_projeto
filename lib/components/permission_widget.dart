import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionWidget extends StatefulWidget {
  const PermissionWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PermissionWidgetState createState() => _PermissionWidgetState();
}

class _PermissionWidgetState extends State<PermissionWidget> {
  Map<Permission, PermissionStatus> _statuses = {};

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    final statuses = await [
      Permission.camera,
      Permission.microphone,
      Permission.storage,
    ].request();

    setState(() {
      _statuses = statuses;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () async {
            await _checkPermissions();
          },
          child: const Text('Check Permissions'),
        ),
        const SizedBox(height: 20),
        Text(
            'Camera: ${_statuses[Permission.camera]?.isGranted ?? false ? 'Granted' : 'Denied'}'),
        Text(
            'Microphone: ${_statuses[Permission.microphone]?.isGranted ?? false ? 'Granted' : 'Denied'}'),
        Text(
            'Storage: ${_statuses[Permission.storage]?.isGranted ?? false ? 'Granted' : 'Denied'}'),
      ],
    );
  }
}
