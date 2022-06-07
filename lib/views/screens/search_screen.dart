import 'package:flutter/material.dart';
import 'package:tiktok_clone/constants.dart';
import 'package:tiktok_clone/controllers/search_controller.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/models/user.dart';
import 'package:tiktok_clone/views/screens/profile_screen.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({Key? key}) : super(key: key);

  SearchController searchController = Get.put(SearchController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: TextFormField(
            decoration: InputDecoration(
              filled: false,
              hintStyle: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
              hintText: 'Search this',
            ),
            onFieldSubmitted: (value) => searchController.searchUser(value),
          ),
        ),
        body: searchController.searchedUsers.isEmpty
            ? Center(
                child: Text(
                  'Search for user',
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : ListView.builder(
                itemCount: searchController.searchedUsers.length,
                itemBuilder: (contex, index) {
                  User user = searchController.searchedUsers[index];
                  return InkWell(
                    onTap: () => Get.to(ProfileScreen(uid: authController.user.uid)),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          user.profilePic,
                        ),
                      ),
                      title: Text(
                        user.name,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                }),
      );
    });
  }
}
