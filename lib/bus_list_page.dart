import 'package:flutter/material.dart';
import 'package:flutter_application_14/bus_detail_page.dart';
import 'package:flutter_application_14/models/bus.dart';
import 'package:flutter_application_14/services/bus_service.dart';

class BusListPage extends StatefulWidget {
  const BusListPage({super.key, this.origin, this.destination});

  final String? origin;
  final String? destination;

  @override
  State<BusListPage> createState() => _BusListPageState();
}

class _BusListPageState extends State<BusListPage> {
  late Future<List<Bus>> _busesFuture;
  bool _showAll = false;

  bool get _hasFilter =>
      (widget.origin ?? '').trim().isNotEmpty ||
      (widget.destination ?? '').trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _busesFuture = _load();
  }

  Future<List<Bus>> _load() {
    return BusService.instance.getBuses(
      origin: _showAll ? null : widget.origin,
      destination: _showAll ? null : widget.destination,
    );
  }

  void _refresh() {
    setState(() {
      _busesFuture = _load();
    });
  }

  void _showBusDeletedSnack() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Bus route deleted'),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> _confirmDelete(Bus bus) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Delete Bus'),
          content: Text(
            'Remove "${bus.name}" from ${bus.from} to ${bus.to}?',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true || bus.routeId == null) return;
    if (!mounted) return;

    final bool deleted =
        await BusService.instance.deleteRoute(bus.routeId!);
    if (!mounted) return;

    _refresh();
    if (deleted) _showBusDeletedSnack();
  }

  Widget _emptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(
              Icons.directions_bus,
              size: 70,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              _hasFilter && !_showAll
                  ? 'No buses found for this route'
                  : 'No buses available right now',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            if (_hasFilter && !_showAll)
              ElevatedButton(
                style:
                    ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: () {
                  setState(() {
                    _showAll = true;
                    _busesFuture = _load();
                  });
                },
                child: const Text(
                  'Show all buses',
                  style: TextStyle(color: Colors.white),
                ),
              )
            else
              ElevatedButton(
                style:
                    ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: () async {
                  await BusService.instance.restoreDefaultBuses();
                  if (!mounted) return;
                  _refresh();
                },
                child: const Text(
                  'Restore default buses',
                  style: TextStyle(color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Available Buses"),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: FutureBuilder<List<Bus>>(
        future: _busesFuture,
        builder: (BuildContext context, AsyncSnapshot<List<Bus>> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          final List<Bus> busList = snapshot.data ?? const <Bus>[];

          if (busList.isEmpty) {
            return _emptyState();
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: busList.length,
            itemBuilder: (context, index) {
              final Bus bus = busList[index];

              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: const CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Icon(
                      Icons.directions_bus,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    bus.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        "${bus.from} ➜ ${bus.to}",
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Time: ${bus.time}",
                      ),
                    ],
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        bus.price,
                        style: const TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.green,
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BusDetailPage(
                          bus: bus,
                        ),
                      ),
                    );
                  },
                  onLongPress: () => _confirmDelete(bus),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
