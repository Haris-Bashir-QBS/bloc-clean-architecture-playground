import 'package:bloc_api_integration/src/features/user_profile/domain/entities/user.dart';
import 'package:bloc_api_integration/src/features/user_profile/presentation/bloc/user_event.dart';
import 'package:bloc_api_integration/src/features/user_profile/presentation/bloc/user_state.dart';
import 'package:bloc_api_integration/src/features/user_profile/presentation/widgets/user_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/user_bloc.dart';

class UsersListScreen extends StatefulWidget {
  const UsersListScreen({super.key});

  @override
  UsersListScreenState createState() => UsersListScreenState();
}

class UsersListScreenState extends State<UsersListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchUsers();
    _scrollController.addListener(_onScroll);
  }

  Future<void> fetchUsers() async {
    context.read<UserBloc>().add(FetchUsersEvent(1));
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      final userBloc = context.read<UserBloc>();
      if (!userBloc.isFetching && userBloc.currentPage <= userBloc.totalPages) {
        userBloc.add(FetchUsersEvent(userBloc.currentPage));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Users List')),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoading && state is! UserListingLoaded) {
            return Center(child: CircularProgressIndicator());
          } else if (state is UserError) {
            return Center(child: Text(state.message));
          } else if (state is UserListingLoaded) {
            final users = state.userListing.users;
            return _usersListView(users);
          }
          return Center(child: Text('No users available'));
        },
      ),
    );
  }

  Widget _usersListView(List<UserEntity>? users) {
    return RefreshIndicator(
      //  onRefresh: fetchUsers,
      onRefresh: () async {
        await fetchUsers();
      },
      child: ListView.separated(
        controller: _scrollController,
        itemCount: (users?.length ?? 0) + 1,
        physics: AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          if (index == users?.length) {
            return (context.read<UserBloc>().currentPage <=
                    context.read<UserBloc>().totalPages)
                ? Center(child: CircularProgressIndicator())
                : SizedBox();
          }
          final user = users?[index];
          return UserCard(user: user!);
        },
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(height: 10);
        },
      ),
    );
  }

  void _navigateToProfileDetailsScreen(BuildContext context, UserEntity? user) {
    //     Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (_) => UserProfileScreen(userId: user.id)),
    // );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
