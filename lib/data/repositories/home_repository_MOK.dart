import 'dart:async';
import 'package:tik_talk/domain/entities/chat_entitie.dart';
import 'package:tik_talk/domain/entities/home_entitie.dart';
import 'package:tik_talk/domain/entities/messege_entitie.dart';
import 'package:tik_talk/domain/entities/participant_entitie.dart';
import 'package:tik_talk/domain/entities/user_entitie.dart';
import 'package:tik_talk/domain/repositories/home_repository.dart';

class MockHomeRepository implements HomeRepository {
  final List<ChatEntitie> _chats = [];
  final List<MessegeEntitie> _messages = [];
  final List<ParticipantEntitie> _participiants = [];
  final List<UserEntity?> _users = [];

 MockHomeRepository() {
  // Добавим тестовые данные
final now = DateTime.now();
    
    // Создаем 10 пользователей
  _users.addAll([
    // Основной пользователь (id 30)
    UserEntity(
      userId: '30',
      tgUsername: '2',
      name: 'Антон',
      surname: 'Круг',
      profile: Profile(
        avatarUrl: 'https://example.com/avatars/anton.jpg',
        aboutMe: 'Flutter разработчик',
        birthdayDate: DateTime(1990, 5, 15),
      ),
    ),
    // Пользователи которые БУДУТ в контактах у id30 (есть общие чаты)
    UserEntity(
      userId: '1',
      tgUsername: 'alex_dev',
      name: 'Алексей',
      surname: 'Петров',
      profile: Profile(
        avatarUrl: 'https://example.com/avatars/alex.jpg',
        aboutMe: 'Backend разработчик',
      ),
    ),
    UserEntity(
      userId: '2', 
      tgUsername: 'maria_design',
      name: 'Мария',
      surname: 'Иванова',
      profile: Profile(
        avatarUrl: 'https://example.com/avatars/maria.jpg',
        birthdayDate: DateTime(1992, 8, 22),
      ),
    ),
    UserEntity(
      userId: '3',
      tgUsername: 'sergey_lead',
      name: 'Сергей', 
      surname: 'Сидоров',
      profile: Profile(
        aboutMe: 'Team Lead',
      ),
    ),
    UserEntity(
      userId: '4',
      tgUsername: 'ekaterina_qa',
      name: 'Екатерина',
      surname: 'Козлова',
      profile: Profile(
        avatarUrl: 'https://example.com/avatars/ekaterina.jpg',
        birthdayDate: DateTime(1991, 3, 10),
      ),
    ),
    UserEntity(
      userId: '5',
      tgUsername: 'dmitry_mobile',
      name: 'Дмитрий',
      surname: 'Федоров',
    ),
    // Пользователи которые НЕ БУДУТ в контактах у id30 (нет общих чатов)
    UserEntity(
      userId: '6',
      tgUsername: 'olga_analyst',
      name: 'Ольга',
      surname: 'Новикова',
      profile: Profile(
        avatarUrl: 'https://example.com/avatars/olga.jpg',
        aboutMe: 'Бизнес-аналитик',
      ),
    ),
    UserEntity(
      userId: '7',
      tgUsername: 'ivan_manager', 
      name: 'Иван',
      surname: 'Васильев',
      profile: Profile(
        birthdayDate: DateTime(1988, 12, 5),
      ),
    ),
    UserEntity(
      userId: '8',
      tgUsername: 'natalia_hr',
      name: 'Наталья',
      surname: 'Павлова',
      profile: Profile(
        avatarUrl: 'https://example.com/avatars/natalia.jpg',
        aboutMe: 'HR специалист',
      ),
    ),
    UserEntity(
      userId: '9',
      tgUsername: 'artem_ceo',
      name: 'Артем',
      surname: 'Громов',
    ),
  ]);

  // Создаем чаты
  _chats.addAll([
    // Direct чат (только 2 пользователя)
    ChatEntitie(
      idChat: 'direct_1',
      nameChat: '', // Пустое название для direct чата
      typeChat: ChatType.direct,
      isPrivate: true,
      createdAt: now.subtract(const Duration(days: 15)),
      updatedAt: now.subtract(const Duration(hours: 2)),
    ),
    // Group чаты (с пользователем 30)
    ChatEntitie(
      idChat: 'group_1',
      nameChat: 'Flutter Development',
      descriptionChat: 'Обсуждаем Flutter проекты',
      typeChat: ChatType.group,
      isPrivate: true,
      createdAt: now.subtract(const Duration(days: 30)),
      updatedAt: now.subtract(const Duration(minutes: 15)),
    ),
    ChatEntitie(
      idChat: 'group_2', 
      nameChat: 'Team Meetings',
      descriptionChat: 'Ежедневные стендапы',
      typeChat: ChatType.group,
      isPrivate: true,
      createdAt: now.subtract(const Duration(days: 20)),
      updatedAt: now.subtract(const Duration(hours: 1)),
    ),
    // Group чаты (БЕЗ пользователя 30)
    ChatEntitie(
      idChat: 'group_3',
      nameChat: 'Analytics Team',
      descriptionChat: 'Чат аналитиков и менеджеров',
      typeChat: ChatType.group, 
      isPrivate: true,
      createdAt: now.subtract(const Duration(days: 25)),
      updatedAt: now.subtract(const Duration(minutes: 45)),
    ),
    // Channel
    ChatEntitie(
      idChat: 'channel_1',
      nameChat: 'Company News',
      descriptionChat: 'Официальные новости компании',
      typeChat: ChatType.channel,
      isPrivate: false,
      createdAt: now.subtract(const Duration(days: 100)),
      updatedAt: now.subtract(const Duration(days: 1)),
    ),
  ]);

  // Создаем участников чатов
  _participiants.addAll([
    // Direct чат: пользователь 30 и пользователь 1
    ParticipantEntitie(
      idPartic: 'p_direct_1',
      userId: '30',
      chatId: 'direct_1',
      role: 'member',
      joinedAt: now.subtract(const Duration(days: 15)).toIso8601String(),
    ),
    ParticipantEntitie(
      idPartic: 'p_direct_2',
      userId: '1', 
      chatId: 'direct_1',
      role: 'member',
      joinedAt: now.subtract(const Duration(days: 15)).toIso8601String(),
    ),

    // Group 1 (Flutter Development): пользователи 30, 1, 2, 3
    ParticipantEntitie(
      idPartic: 'p_group1_1',
      userId: '30',
      chatId: 'group_1',
      role: 'admin',
      joinedAt: now.subtract(const Duration(days: 30)).toIso8601String(),
    ),
    ParticipantEntitie(
      idPartic: 'p_group1_2',
      userId: '1',
      chatId: 'group_1', 
      role: 'member',
      joinedAt: now.subtract(const Duration(days: 28)).toIso8601String(),
    ),
    ParticipantEntitie(
      idPartic: 'p_group1_3',
      userId: '2',
      chatId: 'group_1',
      role: 'member',
      joinedAt: now.subtract(const Duration(days: 25)).toIso8601String(),
    ),
    ParticipantEntitie(
      idPartic: 'p_group1_4',
      userId: '3',
      chatId: 'group_1',
      role: 'member',
      joinedAt: now.subtract(const Duration(days: 22)).toIso8601String(),
    ),

    // Group 2 (Team Meetings): пользователи 30, 2, 4, 5
    ParticipantEntitie(
      idPartic: 'p_group2_1',
      userId: '30',
      chatId: 'group_2',
      role: 'member',
      joinedAt: now.subtract(const Duration(days: 20)).toIso8601String(),
    ),
    ParticipantEntitie(
      idPartic: 'p_group2_2',
      userId: '2',
      chatId: 'group_2',
      role: 'admin',
      joinedAt: now.subtract(const Duration(days: 20)).toIso8601String(),
    ),
    ParticipantEntitie(
      idPartic: 'p_group2_3',
      userId: '4',
      chatId: 'group_2',
      role: 'member',
      joinedAt: now.subtract(const Duration(days: 18)).toIso8601String(),
    ),
    ParticipantEntitie(
      idPartic: 'p_group2_4',
      userId: '5',
      chatId: 'group_2',
      role: 'member',
      joinedAt: now.subtract(const Duration(days: 16)).toIso8601String(),
    ),

    // Group 3 (Analytics Team - БЕЗ пользователя 30): пользователи 6, 7, 8
    ParticipantEntitie(
      idPartic: 'p_group3_1',
      userId: '6',
      chatId: 'group_3',
      role: 'admin',
      joinedAt: now.subtract(const Duration(days: 25)).toIso8601String(),
    ),
    ParticipantEntitie(
      idPartic: 'p_group3_2',
      userId: '7',
      chatId: 'group_3',
      role: 'member',
      joinedAt: now.subtract(const Duration(days: 24)).toIso8601String(),
    ),
    ParticipantEntitie(
      idPartic: 'p_group3_3',
      userId: '8',
      chatId: 'group_3',
      role: 'member',
      joinedAt: now.subtract(const Duration(days: 23)).toIso8601String(),
    ),

    // Channel (все пользователи)
    ParticipantEntitie(
      idPartic: 'p_channel_1',
      userId: '30',
      chatId: 'channel_1',
      role: 'member',
      joinedAt: now.subtract(const Duration(days: 100)).toIso8601String(),
    ),
    ParticipantEntitie(
      idPartic: 'p_channel_2',
      userId: '1',
      chatId: 'channel_1',
      role: 'member',
      joinedAt: now.subtract(const Duration(days: 95)).toIso8601String(),
    ),
    // ... остальные пользователи в channel
  ]);

  // Создаем сообщения (по 5 в каждом чате)
  _createMessagesForChat('direct_1', ['30', '1'], now);
  _createMessagesForChat('group_1', ['30', '1', '2', '3'], now);
  _createMessagesForChat('group_2', ['30', '2', '4', '5'], now);
  _createMessagesForChat('group_3', ['6', '7', '8'], now);
  _createMessagesForChat('channel_1', ['30', '1'], now); // В канале сообщения только от админов
}

void _createMessagesForChat(String chatId, List<String> participantIds, DateTime baseTime) {
  final messages = [
    MessegeEntitie(
      idMessege: '${chatId}_m1',
      idChat: chatId,
      idUser: participantIds[0],
      content: _getMessageContent(chatId, 1),
      typeMessage: MessegeType.text,
      createdAt: baseTime.subtract(const Duration(days: 2, hours: 3)),
    ),
    MessegeEntitie(
      idMessege: '${chatId}_m2',
      idChat: chatId,
      idUser: participantIds[1 % participantIds.length],
      content: _getMessageContent(chatId, 2),
      typeMessage: MessegeType.text,
      createdAt: baseTime.subtract(const Duration(days: 1, hours: 5)),
    ),
    MessegeEntitie(
      idMessege: '${chatId}_m3',
      idChat: chatId,
      idUser: participantIds[2 % participantIds.length],
      content: _getMessageContent(chatId, 3),
      typeMessage: MessegeType.text,
      createdAt: baseTime.subtract(const Duration(hours: 12)),
    ),
    MessegeEntitie(
      idMessege: '${chatId}_m4',
      idChat: chatId,
      idUser: participantIds[0],
      content: _getMessageContent(chatId, 4),
      typeMessage: MessegeType.text,
      createdAt: baseTime.subtract(const Duration(hours: 2)),
    ),
    MessegeEntitie(
      idMessege: '${chatId}_m5',
      idChat: chatId,
      idUser: participantIds[1 % participantIds.length],
      content: _getMessageContent(chatId, 5),
      typeMessage: MessegeType.text,
      createdAt: baseTime.subtract(const Duration(minutes: 30)),
    ),
  ];
  
  _messages.addAll(messages);
}

String _getMessageContent(String chatId, int messageNum) {
  final contents = {
    'direct_1': [
      'Привет! Как дела?',
      'Нормально, работаю над проектом. Ты как?',
      'Тоже всё ок. Завтра на митанг будешь?',
      'Да, обязательно приду',
      'Отлично, тогда до завтра!'
    ],
    'group_1': [
      'Всем привет! Кто обновил Flutter до последней версии?',
      'Я пока на 3.13, стоит обновляться?',
      'Да, в 3.16 много крутых фич',
      'Есть проблемы с совместимостью пакетов?',
      'Вроде нет, всё стабильно работает'
    ],
    'group_2': [
      'Сегодня стендап в 11:00',
      'Я опоздаю на 15 минут',
      'Ок, начнем без тебя',
      'По итогам вчерашнего: что по срокам?',
      'Успеваем в срок, все по плану'
    ],
    'group_3': [
      'Проанализировали требования от клиента',
      'Есть вопросы по функциональности',
      'Нужно уточнить детали',
      'Запланируем созвон с заказчиком',
      'Готовлю презентацию с анализом'
    ],
    'channel_1': [
      'Важное обновление: меняется политика компании',
      'Напоминаем о корпоративе в пятницу',
      'Обновлен регламент удаленной работы',
      'Запускаем новый проект с следующей недели',
      'Поздравляем с днем рождения сотрудников этой недели!'
    ],
  };
  
  return contents[chatId]?[messageNum - 1] ?? 'Тестовое сообщение $messageNum';
}
 
  @override
  Future<List<ChatEntitie?>> getChats(String userId) async {
    // Получаем все ID чатов где участвует пользователь
    final userChatIds = _participiants
        .where((participant) => participant.userId == userId)
        .map((participant) => participant.chatId)
        .toSet();

    // Находим чаты по ID
    return _chats
        .where((chat) => userChatIds.contains(chat.idChat))
        .toList();
  }




  @override
  Future<List<ChatWithLastMessegeEntitie?>> getLastMessages(List<ChatEntitie?> chats) async {
    List<ChatWithLastMessegeEntitie> lastMesseges = [];
    if (chats.isEmpty){ 
      return lastMesseges;
      }
    for (final chat in chats){
       final chatMessages = _messages.where((m)=> m.idChat == chat!.idChat).toList()..sort((a, b) => a.createdAt.compareTo(b.createdAt));
       lastMesseges.add(ChatWithLastMessegeEntitie(chat: chat!,lastMessege: chatMessages.isEmpty ? null : chatMessages.last));
    }
    return lastMesseges;
  }

  @override
  Future<List<ParticipantEntitie?>> getParticipant(List<ChatEntitie?> chats) async => _participiants;
  

  @override
  Future<List<UserEntity?>> getUsers() async => _users;
}


// Результат:
// Контакты пользователя id30 (Антон Круг):
// Алексей Петров (direct + 2 group чата)

// Мария Иванова (2 group чата)

// Сергей Сидоров (1 group чат)

// Екатерина Козлова (1 group чат)

// Дмитрий Федоров (1 group чат)

// Пользователи БЕЗ общих чатов с id30:
// Ольга Новикова (только Analytics Team)

// Иван Васильев (только Analytics Team)

// Наталья Павлова (только Analytics Team)

// Артем Громов (нет чатов)

// Все данные логично связаны, соблюдены уникальности и условия по распределению чатов!