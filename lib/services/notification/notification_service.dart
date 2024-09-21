import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  String userId;
  String userType;
  List<String>? plateNumbers;
  DateTime? lastFetchedViolation;
  DateTime? lastFetchedAnnouncement;

  NotificationService({required this.userId, required this.userType});

  // Initialize listeners
  void init() async {
    // Fetch plate numbers and set up listeners
    await _fetchUserData();
    _loadLastFetchedTimes();
    _listenForViolations();
    _listenForAnnouncements();
  }

  Future<void> _loadLastFetchedTimes() async {
    final prefs = await SharedPreferences.getInstance();
    lastFetchedViolation =
        DateTime.tryParse(prefs.getString('lastViolationFetchTime') ?? '');
    lastFetchedAnnouncement =
        DateTime.tryParse(prefs.getString('lastAnnouncementFetchTime') ?? '');
  }

  Future<void> _saveLastFetchedTimes(
      DateTime lastViolation, DateTime lastAnnouncement) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'lastViolationFetchTime', lastViolation.toIso8601String());
    await prefs.setString(
        'lastAnnouncementFetchTime', lastAnnouncement.toIso8601String());
  }

  Future<void> _fetchUserData() async {
    try {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('User').doc(userId).get();
      final plateNoField = userDoc['plateNo'];
      plateNumbers = (plateNoField is List)
          ? plateNoField.map((plate) => plate.toString()).toList()
          : (plateNoField != null ? [plateNoField.toString()] : null);
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  void _listenForViolations() {
    FirebaseFirestore.instance
        .collection('Violation Ticket')
        .where('plate_number', whereIn: plateNumbers)
        .snapshots()
        .listen((snapshot) {
      DateTime latestViolationTime =
          lastFetchedViolation ?? DateTime(1970); // Initialize with old time

      for (var doc in snapshot.docs) {
        final ticket = doc.data();
        final timestamp = (ticket['timestamp'] as Timestamp).toDate();

        // Check if this ticket is newer than the last fetched violation
        if (timestamp.isAfter(latestViolationTime)) {
          latestViolationTime = timestamp; // Update to the latest timestamp
          _triggerViolationNotification(ticket);
        }
      }

      // Update the last fetched time after processing all tickets
      _saveLastFetchedTimes(
          latestViolationTime, lastFetchedAnnouncement ?? DateTime.now());
    });
  }

  void _listenForAnnouncements() {
    FirebaseFirestore.instance
        .collection('Announcement')
        .snapshots()
        .listen((snapshot) {
      DateTime latestAnnouncementTime =
          lastFetchedAnnouncement ?? DateTime(1970); // Initialize with old time

      for (var doc in snapshot.docs) {
        final announcement = doc.data();
        final timestamp = (announcement['createdAt'] as Timestamp).toDate();

        // Ensure the announcement is for the correct userType and it's new
        if ((announcement['userType'] == userType ||
                announcement['userType'] == 'Everyone') &&
            timestamp.isAfter(latestAnnouncementTime)) {
          latestAnnouncementTime = timestamp; // Update to the latest timestamp
          _triggerAnnouncementNotification(announcement);
        }
      }

      // Update the last fetched time after processing all announcements
      _saveLastFetchedTimes(
          lastFetchedViolation ?? DateTime.now(), latestAnnouncementTime);
    });
  }

  void _triggerViolationNotification(Map<String, dynamic> ticket) {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 10, // Unique notification ID
        channelKey: 'violations_channel',
        title: 'Oh no! Seems like you have committed a violation!',
        body: 'Go to your violation record to see further details.',
        notificationLayout: NotificationLayout.Default,
      ),
    );
  }

  void _triggerAnnouncementNotification(Map<String, dynamic> announcement) {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 11, // Unique notification ID
        channelKey: 'announcements_channel',
        title: announcement['title'],
        body: announcement['details'],
        notificationLayout: NotificationLayout.Default,
      ),
    );
  }
}
