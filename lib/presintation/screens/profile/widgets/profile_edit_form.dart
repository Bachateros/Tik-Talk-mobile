part of 'profile_view_form.dart';
class ProfileEditForm extends StatefulWidget {
  const ProfileEditForm({super.key});

  @override
  State<ProfileEditForm> createState() => _ProfileEditFormState();
}

class _ProfileEditFormState extends State<ProfileEditForm> {
  late final TextEditingController _avatarController;
  late final TextEditingController _nameController;
  late final TextEditingController _surnameController;
  late final TextEditingController _tgController;
  late final TextEditingController _aboutController;
  late final TextEditingController _birthController; // строковое представление даты
  DateTime? _pickedDate;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Инициализируем контроллеры пустыми, затем заполним их текущим состоянием профиля
    _avatarController = TextEditingController();
    _nameController = TextEditingController();
    _surnameController = TextEditingController();
    _tgController = TextEditingController();
    _aboutController = TextEditingController();
    _birthController = TextEditingController();

    // Берём профиль из блока и заполняем контроллеры
    final profile = context.read<ProfileBloc>().state.profile;
    if (profile != null) {
      _avatarController.text = profile.avatarUrl ?? '';
      _nameController.text = profile.name;
      _surnameController.text = profile.surname;
      _tgController.text = profile.tgUsername;
      _aboutController.text = profile.aboutMe ?? '';
      if (profile.birthdayDate != null) {
        _pickedDate = profile.birthdayDate;
        _birthController.text = DateFormat('dd.MM.yyyy').format(_pickedDate!);
      }
    }
  }

  @override
  void dispose() {
    _avatarController.dispose();
    _nameController.dispose();
    _surnameController.dispose();
    _tgController.dispose();
    _aboutController.dispose();
    _birthController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final initial = _pickedDate ?? DateTime(now.year - 20, now.month, now.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: now,
    );
    if (picked != null) {
      setState(() {
        _pickedDate = picked;
        _birthController.text = DateFormat('dd.MM.yyyy').format(picked);
      });
    }
  }

  void _openAvatarUrlDialog() {
    final tmp = TextEditingController();
    final avatar =  _avatarController.text;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('URL аватарки'),
        content: TextField(controller: tmp,style: TextStyle(color: Colors.white), decoration: const InputDecoration(hintText: 'https://...')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Отмена')),
          TextButton(
            onPressed: () {
              setState(() {
                if (tmp.text == '' || tmp.text == 'https://...')
                {
                  _avatarController.text = avatar;
                }else{
                  _avatarController.text = tmp.text;
                }
              });
              Navigator.pop(ctx);
            },
            child: const Text('ОК'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _ProfileBaseLayout(
      avatar: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed:  _openAvatarUrlDialog, 
            child: CircleAvatar(
            radius: 80,
            backgroundImage: _avatarController.text.isNotEmpty
                ? NetworkImage(_avatarController.text)
                : NetworkImage(ThemeAssets.noAvatarUser(context)),
            
            ),
          ),
          const SizedBox(height: 8),
          // ElevatedButton(onPressed:, child: const Text('Изменить')),
        ],
      ),
      nameRow: Form(
        key: _formKey,
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _nameController,
                readOnly: true,
                style: TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: 'Имя'),
                validator: (v) => v == null || v.trim().isEmpty ? 'Обязательное поле' : null,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: _surnameController,
                readOnly: true,
                style: TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: 'Фамилия'),
                validator: (v) => v == null || v.trim().isEmpty ? 'Обязательное поле' : null,
              ),
            ),
          ],
        ),
      ),
      tgRow: TextFormField(
        controller: _tgController,
        style: TextStyle(color: Colors.white),
        readOnly: true,
        decoration: const InputDecoration(labelText: 'Telegram username'),
      ),
      aboutRow: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: _aboutController,
              style: TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: 'О себе'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: TextFormField(
              controller: _birthController,
              style: TextStyle(color: Colors.white),
              readOnly: true,
              decoration: const InputDecoration(labelText: 'Дата рождения'),
              onTap: _pickDate,
            ),
          ),
        ],
      ),
      bottomRow: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                context.read<AuthBloc>().add(LogoutEvent());
              },
              icon: const Icon(Icons.logout),
              label: const Text('Выход'),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent),
            ),
            Row(
              children: [
                TextButton(onPressed: () {
                  context.read<ProfileBloc>().add(SwitchSettingProfileEvent(status: ProfileStatus.me));
                 }, 
                 child: const Text('Отмена')
                ),
                const SizedBox(width: 8),
                ElevatedButton(onPressed: () => 
                context.read<ProfileBloc>().add(UpdateUserProfileEvent(
                  aboutMe: _aboutController.text,
                  avatarUrl: _avatarController.text,
                  birthdayDate:_pickedDate,
                  ),
                
                ),child: Text('Сохранить')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}