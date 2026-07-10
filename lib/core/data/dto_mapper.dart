abstract interface class DtoMapper<TDto, TDomain> {
  TDomain toDomain(TDto dto);

  TDto toDto(TDomain domain);
}
