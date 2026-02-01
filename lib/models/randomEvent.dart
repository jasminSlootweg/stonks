import 'user.dart';

class EventOption {
  final String label;
  final Function(User user) onSelected;

  EventOption({required this.label, required this.onSelected});
}

class RandomEvent {
  final String title;
  final String description;
  final List<EventOption> options;

  RandomEvent({
    required this.title,
    required this.description,
    required this.options,
  });
}