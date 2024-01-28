import 'package:chat_app/domain/bloc/search_bloc.dart';
import 'package:chat_app/domain/event/search_event.dart';
import 'package:chat_app/domain/state/search_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchC = TextEditingController();

  @override
  void dispose() {
    _searchC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
          child: Column(
            children: [
              TextFormField(
                controller: _searchC,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    hintText: "Search"),
                onEditingComplete: () {
                  context
                      .read<SearchBloc>()
                      .add(SearchUserEvent(_searchC.text));
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(child: BlocBuilder<SearchBloc, SearchState>(
                builder: (context, state) {
                  if (state is LoadingSearchUser) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  } else if (state is SuccessGetSearchUser) {
                    if (state.users.isEmpty) {
                      return Center(
                        child: Text(
                          "Sorry, ${_searchC.text} not found, please make sure user is already exist!",
                          textAlign: TextAlign.center,
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: state.users.length,
                      itemBuilder: (context, index) {
                        final user = state.users[index];
                        return ListTile(
                          title: Text(user.userName ?? ""),
                          subtitle: Text(user.email ?? ""),
                        );
                      },
                    );
                  }
                  return const Center(
                    child: Text("Search someone to start chat..."),
                  );
                },
              )),
            ],
          ),
        ),
      ),
    );
  }
}
