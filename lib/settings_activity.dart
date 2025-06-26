import 'package:flutter/material.dart';
import 'base_activity.dart';

class SettingsActivity extends StatefulWidget {
  @override
  _SettingsActivityState createState() => _SettingsActivityState();
}

class _SettingsActivityState extends State<SettingsActivity> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return BaseActivity(
      title: 'Settings',
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8), // Semi-transparent white
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            ListTile(
              title: Text('Profile'),
              subtitle: Text('Update your account info'),
              leading: Icon(Icons.person),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Navigate to Profile Page
              },
            ),
            Divider(),
            SwitchListTile(
              title: Text('Notifications'),
              subtitle: Text('Receive updates and reminders'),
              value: _notificationsEnabled,
              onChanged: (val) {
                setState(() {
                  _notificationsEnabled = val;
                });
              },
              secondary: Icon(Icons.notifications_active),
            ),
            SwitchListTile(
              title: Text('Dark Mode'),
              subtitle: Text('Enable darker UI theme'),
              value: _darkModeEnabled,
              onChanged: (val) {
                setState(() {
                  _darkModeEnabled = val;
                });
                // Optional: apply dark mode logic here
              },
              secondary: Icon(Icons.dark_mode),
            ),
            Divider(),
            ListTile(
              title: Text('About'),
              subtitle: Text('Learn more about this app'),
              leading: Icon(Icons.info),
              onTap: () {
                // Navigate to About screen
              },
            ),
            ListTile(
              title: Text('Privacy Policy'),
              leading: Icon(Icons.privacy_tip),
              onTap: () {
                // Open privacy policy link or page
              },
            ),
            ListTile(
              title: Text('Log Out'),
              leading: Icon(Icons.logout),
              onTap: () {
                // Handle logout logic
              },
            ),
          ],
        ),
      ),
    );
  }
}
