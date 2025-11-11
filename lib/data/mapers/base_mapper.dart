abstract class BaseMapper<Response, DTO, Entity> {
  DTO fromResponse(Response response);
  Response toResponse(DTO dto);

  Entity toEntity(DTO dto);
  DTO fromEntity(Entity entity);
}
