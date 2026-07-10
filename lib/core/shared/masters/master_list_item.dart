import 'package:equatable/equatable.dart';

class MasterListItem extends Equatable {
  const MasterListItem({
    required this.id,
    required this.title,
    required this.subtitle,
    this.status,
    this.isActive = true,
  });

  final String id;
  final String title;
  final String subtitle;
  final String? status;
  final bool isActive;

  @override
  List<Object?> get props => <Object?>[id, title, subtitle, status, isActive];
}
