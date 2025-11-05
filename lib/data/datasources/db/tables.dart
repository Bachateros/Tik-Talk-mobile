part of 'app_db.dart';


class Chats extends Table {
  TextColumn get id => text()();            // idChat
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get type => text()();          // 'direct','group','channel'
  TextColumn get avatarUrl => text().nullable()();
  BoolColumn get isPrivate => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class Messages extends Table {
  TextColumn get id => text()();
  TextColumn get chatId => text().customConstraint('NOT NULL REFERENCES chats(id)')();
  TextColumn get userId => text()();
  TextColumn get content => text().withDefault(const Constant(''))();
  TextColumn get type => text().withDefault(const Constant('text'))(); // 'text','image',...
  TextColumn get replyToId => text().nullable()();
  TextColumn get fileUrl => text().nullable()();
  TextColumn get fileName => text().nullable()();
  IntColumn get fileSize => integer().nullable()();
  TextColumn get mimeType => text().nullable()();
  DateTimeColumn get createdAt => dateTime().clientDefault(() => DateTime.now())();

  @override
  Set<Column> get primaryKey => {id};
}

class Participants extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get chatId => text().customConstraint('NOT NULL REFERENCES chats(id)')();
  TextColumn get role => text().withDefault(const Constant('member'))();
  DateTimeColumn get joinedAt => dateTime().clientDefault(() => DateTime.now())();

  @override
  Set<Column> get primaryKey => {id};
}

// tiny sync metadata
class SyncMeta extends Table {
  TextColumn get key => text()();
  DateTimeColumn get value => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {key};
}
