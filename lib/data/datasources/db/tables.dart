part of 'app_db.dart';
// id | created_at | updated_at | deleted_at | name | description | type | avatar_url | created_by | is_private | max_members | last_activity_at 
class Chats extends Table {
  TextColumn get id => text()(); // idChat
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get type => text()(); // 'direct','group','channel'
  TextColumn get createdBy => text().nullable()(); // 'direct','group','channel'
  TextColumn get avatarUrl => text().nullable()();
  IntColumn get maxMembers => integer()();
  DateTimeColumn get lastActivityAt => dateTime().nullable()();
  BoolColumn get isPrivate => boolean().withDefault(const Constant(false))();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// id|created_at|updated_at|deleted_at|chat_id|user_id|type|content|status|client_id|file_url|file_name|file_size|mime_type|reply_to_id 

class Messages extends Table {
  TextColumn get id => text()();
  TextColumn get chatId => text().customConstraint('NOT NULL REFERENCES chats(id)')();
  TextColumn get userId => text()();
  TextColumn get content => text().withDefault(const Constant(''))();
  TextColumn get type => text().withDefault(const Constant('text'))(); // 'text','image',...
  TextColumn get clientId => text().nullable()();
  TextColumn get status => text().nullable()();
  TextColumn get fileUrl => text().nullable()();
  TextColumn get fileName => text().nullable()();
  IntColumn get fileSize => integer().nullable()();
  TextColumn get mimeType => text().nullable()();
  TextColumn get replyToId => text().nullable()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// id|created_at|updated_at|deleted_at|chat_id|user_id|role|joined_at|last_read_message_id|is_muted|notifications_enabled 


class Participants extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get chatId => text().customConstraint('NOT NULL REFERENCES chats(id)')();
  TextColumn get role => text().withDefault(const Constant('member'))();
  BoolColumn get isMuted => boolean().withDefault(const Constant(false))();
  BoolColumn get notificationsEnabled => boolean().withDefault(const Constant(true))();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get joinedAt => dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get createdAt => dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
// id |created_at|updated_at|deleted_at|name|surname|tgname| avatar | bio | date_of_birth
class Users extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get surname => text()();
  TextColumn get tgname => text()();
  DateTimeColumn get dateOfBirth => dateTime().nullable()();
  TextColumn get bio => text().nullable()();
  TextColumn get avatarUrl => text().nullable()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class SyncMeta extends Table {
  TextColumn get key => text()();
  DateTimeColumn get value => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {key};
}
