import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/booking_entity.dart';

part 'booking_repository.g.dart';

/// Repositório para gerenciar agendamentos no Firestore
class BookingRepository {
  final FirebaseFirestore _firestore;

  BookingRepository(this._firestore);

  /// Collection reference para bookings
  CollectionReference<Map<String, dynamic>> get _bookingsCollection => _firestore.collection('bookings');

  /// Cria um novo agendamento
  Future<void> createBooking(BookingEntity booking) async {
    await _bookingsCollection.doc(booking.id).set(booking.toMap());
  }

  /// Busca um agendamento por ID
  Future<BookingEntity?> getBookingById(String bookingId) async {
    final doc = await _bookingsCollection.doc(bookingId).get();
    if (!doc.exists) return null;
    return BookingEntity.fromMap({'id': doc.id, ...doc.data()!});
  }

  /// Lista agendamentos do barbeiro (stream em tempo real)
  Stream<List<BookingEntity>> watchBarberBookings(String barberId) {
    return _bookingsCollection
        .where('barberId', isEqualTo: barberId)
        .orderBy('dateTime', descending: false)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return BookingEntity.fromMap({'id': doc.id, ...doc.data()});
          }).toList();
        });
  }

  /// Lista agendamentos do cliente (stream em tempo real)
  Stream<List<BookingEntity>> watchClientBookings(String clientId) {
    return _bookingsCollection
        .where('clientId', isEqualTo: clientId)
        .orderBy('dateTime', descending: false)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return BookingEntity.fromMap({'id': doc.id, ...doc.data()});
          }).toList();
        });
  }

  /// Lista agendamentos futuros do barbeiro para uma data específica
  Future<List<BookingEntity>> getBarberBookingsByDate(String barberId, DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final snapshot = await _bookingsCollection
        .where('barberId', isEqualTo: barberId)
        .where('dateTime', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('dateTime', isLessThan: Timestamp.fromDate(endOfDay))
        .where('status', whereIn: [BookingStatus.pending.name, BookingStatus.confirmed.name])
        .orderBy('dateTime')
        .get();

    return snapshot.docs.map((doc) {
      return BookingEntity.fromMap({'id': doc.id, ...doc.data()});
    }).toList();
  }

  /// Atualiza o status de um agendamento
  Future<void> updateBookingStatus(
    String bookingId,
    BookingStatus newStatus, {
    String? cancellationReason,
    String? cancelledBy,
  }) async {
    final updates = <String, Object>{'status': newStatus.name, 'updatedAt': FieldValue.serverTimestamp()};

    if (newStatus == BookingStatus.cancelled && cancellationReason != null && cancelledBy != null) {
      updates['cancellationReason'] = cancellationReason;
      updates['cancelledBy'] = cancelledBy;
    }

    await _bookingsCollection.doc(bookingId).update(updates);
  }

  /// Cancela um agendamento
  Future<void> cancelBooking(String bookingId, String cancelledBy, String reason) async {
    await updateBookingStatus(bookingId, BookingStatus.cancelled, cancellationReason: reason, cancelledBy: cancelledBy);
  }

  /// Confirma um agendamento (barbeiro aceita)
  Future<void> confirmBooking(String bookingId) async {
    await updateBookingStatus(bookingId, BookingStatus.confirmed);
  }

  /// Marca agendamento como concluído
  Future<void> completeBooking(String bookingId) async {
    await updateBookingStatus(bookingId, BookingStatus.completed);
  }

  /// Deleta um agendamento (apenas para admin/debug)
  Future<void> deleteBooking(String bookingId) async {
    await _bookingsCollection.doc(bookingId).delete();
  }

  /// Lista próximos agendamentos do usuário (como barbeiro ou cliente)
  Future<List<BookingEntity>> getUpcomingBookings(String userId) async {
    final now = Timestamp.now();

    // Buscar como barbeiro
    final barberSnapshot = await _bookingsCollection
        .where('barberId', isEqualTo: userId)
        .where('dateTime', isGreaterThanOrEqualTo: now)
        .orderBy('dateTime')
        .limit(10)
        .get();

    // Buscar como cliente
    final clientSnapshot = await _bookingsCollection
        .where('clientId', isEqualTo: userId)
        .where('dateTime', isGreaterThanOrEqualTo: now)
        .orderBy('dateTime')
        .limit(10)
        .get();

    final bookings = <BookingEntity>[];

    for (final doc in barberSnapshot.docs) {
      bookings.add(BookingEntity.fromMap({'id': doc.id, ...doc.data()}));
    }

    for (final doc in clientSnapshot.docs) {
      bookings.add(BookingEntity.fromMap({'id': doc.id, ...doc.data()}));
    }

    // Ordenar por data
    bookings.sort((a, b) => a.dateTime.compareTo(b.dateTime));

    return bookings;
  }
}

/// Provider para BookingRepository
@riverpod
BookingRepository bookingRepository(Ref ref) {
  return BookingRepository(FirebaseFirestore.instance);
}
