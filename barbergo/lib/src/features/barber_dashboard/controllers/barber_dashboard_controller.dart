import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'barber_dashboard_controller.g.dart';

class BarberStats {
  final int totalClients;
  final int todayBookings;
  final double todayRevenue;
  final double weekRevenue;
  final double monthRevenue;
  final double averageRating;
  final int totalReviews;
  final List<RevenueByDay> revenueChart;

  BarberStats({
    required this.totalClients,
    required this.todayBookings,
    required this.todayRevenue,
    required this.weekRevenue,
    required this.monthRevenue,
    required this.averageRating,
    required this.totalReviews,
    required this.revenueChart,
  });
}

class RevenueByDay {
  final String day;
  final double amount;

  RevenueByDay({required this.day, required this.amount});
}

@riverpod
class BarberDashboardController extends _$BarberDashboardController {
  @override
  Future<BarberStats> build() async {
    return _loadStats('current-barber-id');
  }

  Future<BarberStats> _loadStats(String barberId) async {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final weekStart = now.subtract(Duration(days: 7));
    final monthStart = DateTime(now.year, now.month, 1);

    // Total clients
    final clientsSnapshot = await FirebaseFirestore.instance
        .collection('bookings')
        .where('barberId', isEqualTo: barberId)
        .get();

    final uniqueClients = clientsSnapshot.docs.map((doc) => doc.data()['userId']).toSet().length;

    // Today's bookings
    final todayBookings = await FirebaseFirestore.instance
        .collection('bookings')
        .where('barberId', isEqualTo: barberId)
        .where('date', isGreaterThanOrEqualTo: todayStart)
        .get();

    final todayRevenue = todayBookings.docs.fold<double>(0, (sum, doc) => sum + (doc.data()['price'] ?? 0).toDouble());

    // Week revenue
    final weekBookings = await FirebaseFirestore.instance
        .collection('bookings')
        .where('barberId', isEqualTo: barberId)
        .where('date', isGreaterThanOrEqualTo: weekStart)
        .get();

    final weekRevenue = weekBookings.docs.fold<double>(0, (sum, doc) => sum + (doc.data()['price'] ?? 0).toDouble());

    // Month revenue
    final monthBookings = await FirebaseFirestore.instance
        .collection('bookings')
        .where('barberId', isEqualTo: barberId)
        .where('date', isGreaterThanOrEqualTo: monthStart)
        .get();

    final monthRevenue = monthBookings.docs.fold<double>(0, (sum, doc) => sum + (doc.data()['price'] ?? 0).toDouble());

    // Ratings
    final reviewsSnapshot = await FirebaseFirestore.instance
        .collection('barbers')
        .doc(barberId)
        .collection('reviews')
        .get();

    final avgRating = reviewsSnapshot.docs.isEmpty
        ? 0.0
        : reviewsSnapshot.docs.fold<double>(0, (sum, doc) => sum + (doc.data()['rating'] ?? 0).toDouble()) /
              reviewsSnapshot.docs.length;

    // Revenue chart (last 7 days)
    final chart = <RevenueByDay>[];
    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dayStart = DateTime(date.year, date.month, date.day);
      final dayEnd = dayStart.add(const Duration(days: 1));

      final dayBookings = weekBookings.docs.where((doc) {
        final bookingDate = (doc.data()['date'] as Timestamp).toDate();
        return bookingDate.isAfter(dayStart) && bookingDate.isBefore(dayEnd);
      });

      final dayRevenue = dayBookings.fold<double>(0, (sum, doc) => sum + (doc.data()['price'] ?? 0).toDouble());

      chart.add(RevenueByDay(day: '${date.day}/${date.month}', amount: dayRevenue));
    }

    return BarberStats(
      totalClients: uniqueClients,
      todayBookings: todayBookings.docs.length,
      todayRevenue: todayRevenue,
      weekRevenue: weekRevenue,
      monthRevenue: monthRevenue,
      averageRating: avgRating,
      totalReviews: reviewsSnapshot.docs.length,
      revenueChart: chart,
    );
  }
}
