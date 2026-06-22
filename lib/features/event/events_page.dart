import 'package:flutter/material.dart';
import '../../data/models/models.dart';
import '../../data/repositories/event_repository_impl.dart';

class EventsPage extends StatelessWidget {
  const EventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final eventRepo = EventRepositoryImpl();

    return Scaffold(
      appBar: AppBar(title: const Text('Taro (Events)')),
      body: StreamBuilder<List<EventModel>>(
        stream: eventRepo.getEvents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (!snapshot.hasData || snapshot.data!.isEmpty) return const Center(child: Text('No events scheduled.'));

          final events = snapshot.data!;
          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text(event.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${event.location} - ${event.dateTime}'),
                  trailing: ElevatedButton(
                    onPressed: () => eventRepo.toggleRSVP(event.id, 'current_user_id'),
                    child: const Text('Nuna Buri'),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
