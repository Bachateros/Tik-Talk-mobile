import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tik_talk/domain/bloc/create_chat_bloc/create_chat_bloc.dart';
import 'package:tik_talk/presintation/screens/chat_create/widget/create_chat_direct_form.dart';
import 'package:tik_talk/presintation/screens/chat_create/widget/create_chat_form.dart';
import 'package:tik_talk/presintation/widgets/failed_load_view.dart';

class CreateChatView extends StatelessWidget {
  const CreateChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateChatBloc,CreateChatState>(
      buildWhen: (previous, current) => current.status !=previous.status,
      builder:(context, state) {
        if (state.status == CreateChatStatus.createDirect){
            return CreateChatDirectForm();
        } else if(state.status == CreateChatStatus.createChanel){
            return CreateChatForm(isGroup: false);
        } else if(state.status ==CreateChatStatus.createGroup){
            return CreateChatForm(isGroup: true);
        }else
          return FailedLoadView();
        }
    ); 
  }
}