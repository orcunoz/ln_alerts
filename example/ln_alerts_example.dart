import 'package:flutter/material.dart';
import 'package:ln_alerts/ln_alerts.dart';
import 'package:ln_core/ln_core.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LnAlerts Example App',
      localizationsDelegates: [
        LnLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Container(
            alignment: Alignment.center,
            color: Colors.grey,
            padding: EdgeInsets.symmetric(
              vertical: 48,
              horizontal: 36,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "LnAlerts Container Bounds",
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                Flexible(
                  child: MyAlertContainer(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyAlertContainer extends StatefulWidget {
  const MyAlertContainer({super.key});

  @override
  State<MyAlertContainer> createState() => _MyAlertContainerState();
}

class _MyAlertContainerState extends State<MyAlertContainer> {
  AlertDisplayType _selectedAlertWidget = AlertDisplayType.notification;
  AlertType _selectedAlertType = AlertType.info;
  bool _brightnessDark = false;

  Widget _buildAlertWidgetDropdown(BuildContext context) {
    return DropdownButton(
      icon: Icon(Icons.arrow_drop_down_rounded),
      isExpanded: true,
      items: [
        DropdownMenuItem(
          value: AlertDisplayType.notification,
          child: Text("Notification"),
        ),
        DropdownMenuItem(
          value: AlertDisplayType.flat,
          child: Text("Flat"),
        ),
        DropdownMenuItem(
          value: AlertDisplayType.popup,
          child: Text("Popup"),
        ),
      ],
      value: _selectedAlertWidget,
      onChanged: (alertWidget) => setState(() {
        _selectedAlertWidget = alertWidget!;
      }),
    );
  }

  Widget _buildAlertTypeDropdown(BuildContext context) {
    return DropdownButton(
      icon: Icon(Icons.arrow_drop_down_rounded),
      isExpanded: true,
      items: [
        DropdownMenuItem(
          value: AlertType.info,
          child: Text("Information Alert"),
        ),
        DropdownMenuItem(
          value: AlertType.success,
          child: Text("Success Alert"),
        ),
        DropdownMenuItem(
          value: AlertType.warning,
          child: Text("Warning Alert"),
        ),
        DropdownMenuItem(
          value: AlertType.error,
          child: Text("Error Alert"),
        ),
      ],
      value: _selectedAlertType,
      onChanged: (alertType) => setState(() {
        _selectedAlertType = alertType!;
      }),
    );
  }

  Widget _buildDarkModeSwitch(BuildContext context) {
    return SpacedRow(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          "Dark Mode",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Switch(
          value: _brightnessDark,
          onChanged: (bool val) => setState(() {
            _brightnessDark = val;
          }),
        ),
      ],
    );
  }

  Widget _buildInAppThemeContext(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 3,
            color: theme.dividerColor,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
      ),
      child: LnAlertsArea.scope(
        containers: AlertDisplayType.values,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SpacedColumn(
            spacing: 8,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildAlertWidgetDropdown(context),
              _buildAlertTypeDropdown(context),
              _buildDarkModeSwitch(context),
              Center(
                child: FilledButton(
                  onPressed: () {
                    LnAlerts.of(context).show(
                      LnAlert(type: _selectedAlertType),
                      displayType: _selectedAlertWidget,
                    );
                  },
                  child: Text("Show Alert"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final brightness = _brightnessDark ? Brightness.dark : Brightness.light;
    return Theme(
      data: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          brightness: brightness,
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: true,
        extensions: {
          LnAlertsTheme(
            brightness: brightness,
            flatAlertsContainerSettings: FlatAlertsContainerSettings(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        },
      ),
      child: Builder(builder: _buildInAppThemeContext),
    );
  }
}
