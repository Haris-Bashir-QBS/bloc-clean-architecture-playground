import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/user_bloc.dart';
import '../bloc/user_event.dart';
import '../bloc/user_state.dart';
import '../../domain/entities/user.dart';

class UserProfileView extends StatelessWidget {
  final String userId;

  const UserProfileView({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("User Profile")),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserInitial) {
            context.read<UserBloc>().add(FetchUserProfileEvent(userId));
          }
          if (state is UserLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UserLoaded) {
            return _buildUserProfile(state.user);
          } else if (state is UserError) {
            return _buildErrorMessage(state.message, context);
          }
          return const Center(child: Text("No User Data"));
        },
      ),
    );
  }

  /// Widget for displaying the user's profile details
  Widget _buildUserProfile(UserProfileEntity user) {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        margin: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(user.avatar),
              ),
              const SizedBox(height: 12),
              Text(
                user.firstName + user.lastName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                user.email,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Widget for displaying error messages
  Widget _buildErrorMessage(String message, BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Error: $message",
            style: const TextStyle(color: Colors.red, fontSize: 18),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed:
                () =>
                    context.read<UserBloc>().add(FetchUserProfileEvent(userId)),
            child: const Text("Retry"),
          ),
        ],
      ),
    );
  }
}
