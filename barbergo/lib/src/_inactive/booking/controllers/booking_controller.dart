import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/booking_repository.dart';
import '../../../domain/entities/booking_entity.dart';

part 'booking_controller.g.dart';

/// Provider que observa os agendamentos do usuário atual
@riverpod
Stream<List<BookingEntity>> userBookings(Ref ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  final bookingRepo = ref.watch(bookingRepositoryProvider);
  final currentUser = authRepo.currentUser;

  if (currentUser == null) {
    return Stream.value([]);
  }

  // Retorna agendamentos como cliente
  // TODO: Decidir se mostra também agendamentos como barbeiro
  return bookingRepo.watchClientBookings(currentUser.uid);
}

/// Provider para agendamentos futuros
@riverpod
Future<List<BookingEntity>> upcomingBookings(Ref ref) async {
  final authRepo = ref.watch(authRepositoryProvider);
  final bookingRepo = ref.watch(bookingRepositoryProvider);
  final currentUser = authRepo.currentUser;

  if (currentUser == null) {
    return [];
  }

  return bookingRepo.getUpcomingBookings(currentUser.uid);
}

/// Controller para gerenciar operações de agendamento
@riverpod
class BookingController extends _$BookingController {
  @override
  FutureOr<bool> build() async {
    // Retorna true quando pronto
    return true;
  }

  /// Cria um novo agendamento
  Future<void> createBooking({
    required String barberId,
    required String barberName,
    String? barberAvatarUrl,
    required String serviceType,
    required DateTime dateTime,
    required double price,
    int durationMinutes = 60,
    String? notes,
  }) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final authRepo = ref.read(authRepositoryProvider);
      final bookingRepo = ref.read(bookingRepositoryProvider);
      final currentUser = authRepo.currentUser;

      if (currentUser == null) {
        throw Exception('Usuário não autenticado');
      }

      // Gerar ID único
      final bookingId = DateTime.now().millisecondsSinceEpoch.toString();

      final booking = BookingEntity(
        id: bookingId,
        barberId: barberId,
        barberName: barberName,
        barberAvatarUrl: barberAvatarUrl,
        clientId: currentUser.uid,
        clientName: currentUser.displayName ?? 'Cliente',
        clientAvatarUrl: currentUser.photoURL,
        serviceType: serviceType,
        dateTime: dateTime,
        durationMinutes: durationMinutes,
        price: price,
        notes: notes,
        createdAt: DateTime.now(),
      );

      await bookingRepo.createBooking(booking);

      // Invalidar cache de agendamentos
      ref.invalidate(userBookingsProvider);
      ref.invalidate(upcomingBookingsProvider);
    });
  }

  /// Cancela um agendamento
  Future<void> cancelBooking(String bookingId, String reason) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final authRepo = ref.read(authRepositoryProvider);
      final bookingRepo = ref.read(bookingRepositoryProvider);
      final currentUser = authRepo.currentUser;

      if (currentUser == null) {
        throw Exception('Usuário não autenticado');
      }

      await bookingRepo.cancelBooking(bookingId, currentUser.uid, reason);

      // Invalidar cache
      ref.invalidate(userBookingsProvider);
      ref.invalidate(upcomingBookingsProvider);
    });
  }

  /// Confirma um agendamento (apenas barbeiro)
  Future<void> confirmBooking(String bookingId) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final bookingRepo = ref.read(bookingRepositoryProvider);
      await bookingRepo.confirmBooking(bookingId);

      // Invalidar cache
      ref.invalidate(userBookingsProvider);
      ref.invalidate(upcomingBookingsProvider);
    });
  }

  /// Marca agendamento como concluído (apenas barbeiro)
  Future<void> completeBooking(String bookingId) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final bookingRepo = ref.read(bookingRepositoryProvider);
      await bookingRepo.completeBooking(bookingId);

      // Invalidar cache
      ref.invalidate(userBookingsProvider);
      ref.invalidate(upcomingBookingsProvider);
    });
  }

  /// Busca agendamentos do barbeiro para uma data específica
  Future<List<BookingEntity>> getBarberBookingsByDate(String barberId, DateTime date) async {
    final bookingRepo = ref.read(bookingRepositoryProvider);
    return bookingRepo.getBarberBookingsByDate(barberId, date);
  }
}
