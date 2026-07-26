import '../mappers/rep_event_mapper.dart';
import '../../domain/models/rep_event.dart';

class RepEventDto {
  const RepEventDto(this.json);
  final Map<String, Object?> json;
  factory RepEventDto.fromDomain(RepEvent event) =>
      RepEventDto(RepEventMapper.toApiJson(event));
}
