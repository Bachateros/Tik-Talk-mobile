abstract class BaseMapper<Response, DTO, Entity , DbModel> {
  DTO fromResponse(Response response);
  Response toResponse(DTO dto);

  Entity toEntity(DTO dto);
  DTO fromEntity(Entity entity);

  DTO toDTO(DbModel companion); 
}
