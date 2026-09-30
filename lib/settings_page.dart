import 'package:flutter/material.dart';
import 'package:flutter_application_14/info_screen.dart';
import 'package:flutter_application_14/services/settings_service.dart';
import 'package:flutter_application_14/splashscreen.dart';
import 'package:flutter_application_14/theme/app_theme.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final SettingsService _settings = SettingsService.instance;

  @override
  void initState() {
    super.initState();
    _settings.addListener(_onChange);
  }

  @override
  void dispose() {
    _settings.removeListener(_onChange);
    super.dispose();
  }

  void _onChange() {
    if (mounted) setState(() {});
  }

  String get _initials {
    final String name = _settings.profileName.trim();
    if (name.isEmpty) return 'SE';
    final List<String> parts = name.split(RegExp(r'\s+'));
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }

  void _openProfileEditor() {
    final TextEditingController nameController =
        TextEditingController(text: _settings.profileName);
    final TextEditingController emailController =
        TextEditingController(text: _settings.profileEmail);
    final TextEditingController phoneController =
        TextEditingController(text: _settings.profilePhone);

    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Edit Profile'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    prefixIcon: Icon(Icons.phone),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () {
                if (nameController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    const SnackBar(content: Text('Please enter your name')),
                  );
                  return;
                }

                _settings.updateProfile(
                  name: nameController.text.trim(),
                  email: emailController.text.trim(),
                  phone: phoneController.text.trim(),
                );

                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Profile updated'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _confirmLogout() {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                Navigator.pop(dialogContext);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => const SplashScreen(),
                  ),
                  (Route<void> route) => false,
                );
              },
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showInfo(String title, List<InfoSection> sections) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => InfoScreen(title: title, sections: sections),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 6, top: 22, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.green,
        ),
      ),
    );
  }

  Widget _tile({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    Color? iconColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? Colors.green),
      title: Text(title),
      subtitle: subtitle == null ? null : Text(subtitle),
      trailing: trailing,
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool notifications = _settings.notificationsEnabled;
    final bool darkMode = _settings.darkModeEnabled;
    final String profileName = _settings.profileName.trim();
    final String profileEmail = _settings.profileEmail.trim();
    final String profilePhone = _settings.profilePhone.trim();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.gradient(context)),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            _sectionTitle('Profile'),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.green,
                      child: Text(
                        _initials,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            profileName.isEmpty
                                ? 'Shaheen Guest'
                                : profileName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            profileEmail.isEmpty
                                ? 'Add your details'
                                : profileEmail,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          if (profilePhone.isNotEmpty) ...<Widget>[
                            const SizedBox(height: 2),
                            Text(
                              profilePhone,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.green),
                      tooltip: 'Edit profile',
                      onPressed: _openProfileEditor,
                    ),
                  ],
                ),
              ),
            ),
            _sectionTitle('Preferences'),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: <Widget>[
                  _tile(
                    icon: Icons.notifications,
                    title: 'Notifications',
                    subtitle: notifications ? 'On' : 'Off',
                    trailing: Switch(
                      value: notifications,
                      activeThumbColor: Colors.green,
                      onChanged: _settings.setNotifications,
                    ),
                  ),
                  const Divider(height: 1),
                  _tile(
                    icon: Icons.dark_mode,
                    title: 'Dark Mode',
                    subtitle: darkMode ? 'On' : 'Off',
                    trailing: Switch(
                      value: darkMode,
                      activeThumbColor: Colors.green,
                      onChanged: _settings.setDarkMode,
                    ),
                  ),
                  const Divider(height: 1),
                  _tile(
                    icon: Icons.language,
                    title: 'Language',
                    subtitle: _settings.languageCode == 'ur'
                        ? 'اردو'
                        : 'English',
                    trailing: DropdownButton<String>(
                      value: _settings.languageCode,
                      underline: const SizedBox.shrink(),
                      items: const <DropdownMenuItem<String>>[
                        DropdownMenuItem<String>(
                          value: 'en',
                          child: Text('English'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'ur',
                          child: Text('اردو'),
                        ),
                      ],
                      onChanged: (String? value) {
                        if (value != null) _settings.setLanguage(value);
                      },
                    ),
                  ),
                ],
              ),
            ),
            _sectionTitle('About'),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: <Widget>[
                  _tile(
                    icon: Icons.info,
                    title: 'App Information',
                    onTap: () => _showInfo('App Information', _appInfo),
                  ),
                  const Divider(height: 1),
                  _tile(
                    icon: Icons.privacy_tip,
                    title: 'Privacy Policy',
                    onTap: () => _showInfo('Privacy Policy', _privacyPolicy),
                  ),
                  const Divider(height: 1),
                  _tile(
                    icon: Icons.description,
                    title: 'Terms & Conditions',
                    onTap: () =>
                        _showInfo('Terms & Conditions', _termsAndConditions),
                  ),
                ],
              ),
            ),
            _sectionTitle('Account'),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: _tile(
                icon: Icons.logout,
                title: 'Logout',
                iconColor: Colors.red,
                onTap: _confirmLogout,
              ),
            ),
            const SizedBox(height: 24),
            const Center(
              child: Text(
                'Shaheen Express\nVersion 1.0.0 • © 2026',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  static const List<InfoSection> _appInfo = <InfoSection>[
    InfoSection(
      'App Name',
      'Shaheen Express — your trusted travel partner for safe, comfortable '
      'and affordable bus travel across Pakistan.',
    ),
    InfoSection(
      'Version',
      'Version 1.0.0 (Build 1)',
    ),
    InfoSection(
      'Package',
      'flutter_application_14',
    ),
    InfoSection(
      'Contact',
      'support@shaheenexpress.com\n+92 300 1234567',
    ),
    InfoSection(
      'Copyright',
      '© 2026 Shaheen Express. All rights reserved.',
    ),
  ];

  static const List<InfoSection> _privacyPolicy = <InfoSection>[
    InfoSection(
      'Data We Store',
      'Shaheen Express stores the details you enter in the app, such as bus '
      'searches, seat bookings, complaints and job applications, together '
      'with your profile and preferences.',
    ),
    InfoSection(
      'Where It Is Stored',
      'All of this information is kept locally on your own device inside the '
      'app database. It is not uploaded to any external server by the app.',
    ),
    InfoSection(
      'Your Preferences',
      'Notification, dark mode and language choices are saved on your device '
      'so the app looks the way you left it every time you open it.',
    ),
    InfoSection(
      'Sharing',
      'Complaints are only shared with our support team when you personally '
      'choose to send them on WhatsApp.',
    ),
    InfoSection(
      'Your Rights',
      'You can remove the app at any time, which also removes the locally '
      'stored data from your device. For any query contact '
      'support@shaheenexpress.com.',
    ),
  ];

  static const List<InfoSection> _termsAndConditions = <InfoSection>[
    InfoSection(
      'Bookings',
      'A seat is confirmed only after the booking is successfully saved. '
      'Please check the passenger name, phone number and seat number before '
      'confirming.',
    ),
    InfoSection(
      'Arrival',
      'Passengers must arrive at least 30 minutes before departure. A valid '
      'ticket is required to travel.',
    ),
    InfoSection(
      'Luggage',
      'Each passenger may carry standard luggage. Extra baggage may require '
      'additional charges as per company policy.',
    ),
    InfoSection(
      'Refunds',
      'Ticket cancellation before departure may qualify for a partial refund '
      'depending on the timing of the cancellation.',
    ),
    InfoSection(
      'Conduct',
      'Passengers must follow staff instructions. Smoking and dangerous items '
      'are not allowed on board.',
    ),
    InfoSection(
      'Acceptance',
      'By using Shaheen Express you agree to these terms. Continued use of '
      'the app means you accept any updates to them.',
    ),
  ];
}
