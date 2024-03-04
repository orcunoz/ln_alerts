part of 'container.dart';

class LnAlertsController with ChangeNotifier {
  LnAlertsController();

  final Map<Object, AlertRegistry> _alerts = {};
  final Set<Object> _progressUniques = <Object>{};
  final ValueNotifier<bool> _progressNotifier = ValueNotifier(false);
  ValueListenable<bool> get progressListenable => _progressNotifier;

  bool get inProgress => progressListenable.value;

  final Set<_AlertsContainerState> _registeredContainers = {};

  _AlertsContainerState? _primaryContainer;

  void _refreshPrimaryContainer() {
    _primaryContainer =
        _registeredContainers.where((c) => c.widget.primary).lastOrNull;
  }

  void _register(_AlertsContainerState state) {
    _registeredContainers.add(state);
    _refreshPrimaryContainer();

    final targetContainers = _registeredContainers
        .where((c) => c.widget.displayType == state.widget.displayType);

    if (targetContainers.length > 1) {
      final rootContainer = targetContainers.firstWhere((c) => c.widget.root);

      rootContainer.rebuild(() {
        rootContainer.enabled = false;
      });
    }
  }

  void _unregister(_AlertsContainerState state) {
    _registeredContainers.remove(state);
    _refreshPrimaryContainer();

    final targetContainers = _registeredContainers
        .where((c) => c.widget.displayType == state.widget.displayType);

    if (targetContainers.length == 1) {
      final rootContainer = targetContainers.first;
      rootContainer.rebuild(() {
        rootContainer.enabled = true;
      });
    }
  }

  List<AlertRegistry> _alertsOf(_AlertsContainerState containerState) {
    final typesWillShow = [
      if (containerState == _primaryContainer) null,
      containerState.widget.displayType,
    ];

    return _alerts.values
        .where((a) => typesWillShow.contains(a.displayType))
        .toList();
  }

  bool notifyProgressing(bool progress, Object unique) {
    bool result = progress
        ? _progressUniques.add(unique)
        : _progressUniques.remove(unique);

    if (result) {
      LnSchedulerCallbacks.endOfFrame(() {
        _progressNotifier.value = _progressUniques.isNotEmpty;
      });
    }

    return result;
  }

  LnAlert? removeAlert(Object unique) {
    var removedRegistry = _alerts.remove(unique);
    if (removedRegistry != null) {
      LnSchedulerCallbacks.endOfFrame(notifyListeners);
    }

    return removedRegistry?.alert;
  }

  void show(
    final LnAlert alert, {
    final Duration? duration = const Duration(seconds: 10),
    final AlertDisplayType? displayType,
    final Object? unique,
    final List<LnAlertActionButton> buttons = const [
      LnAlertActionButton.remove()
    ],
  }) {
    _show(
      alert,
      duration: duration,
      displayType: displayType,
      unique: unique ?? UniqueKey(),
      buttons: buttons,
    );
  }

  bool _show(
    final LnAlert alert, {
    required final Duration? duration,
    required final AlertDisplayType? displayType,
    required final Object unique,
    required final List<LnAlertActionButton> buttons,
  }) {
    //assert(displayType != null || _primaryContainer != null);
    assert(displayType == null ||
        _registeredContainers.any((c) => c.widget.displayType == displayType));
    _alerts[unique] = AlertRegistry(
      displayType: displayType,
      alert: alert,
      buttons: [
        for (final button in buttons)
          if (button.removeButton)
            button.copyWith(onPressed: () => removeAlert(unique))
          else
            button
      ],
    );

    LnSchedulerCallbacks.endOfFrame(notifyListeners);

    if (duration != null && duration != Duration.zero) {
      Future.delayed(duration, () {
        removeAlert(unique);
      });
    }

    return true;
  }

  void errorHandler(Object error, StackTrace stackTrace) => handleError(error);

  void handleError(Object error) => show(LnAlert.errorAutoDetect(error));

  @override
  void dispose() {
    super.dispose();

    _progressNotifier.dispose();
  }
}

class AlertRegistry {
  const AlertRegistry({
    required this.alert,
    required this.displayType,
    required this.buttons,
  });

  final LnAlert alert;
  final AlertDisplayType? displayType;
  final List<LnAlertActionButton> buttons;
}
