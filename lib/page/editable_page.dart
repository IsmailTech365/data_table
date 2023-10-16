// ignore_for_file: library_private_types_in_public_api

import 'package:data_table/data/users.dart';
import 'package:data_table/model/user.dart';
import 'package:data_table/utils.dart';
import 'package:data_table/widget/scrollable_widget.dart';
import 'package:data_table/widget/text_dialog_widget.dart';
import 'package:flutter/material.dart';

class EditablePage extends StatefulWidget {
  const EditablePage({super.key});

  @override
  _EditablePageState createState() => _EditablePageState();
}

class _EditablePageState extends State<EditablePage> {
  late List<User> users;

  @override
  void initState() {
    super.initState();

    users = List.of(allUsers);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: ScrollableWidget(child: buildDataTable()),
      );

  Widget buildDataTable() {
    final columns = ['First Name', 'Last Name', 'Age'];

    return DataTable(
      columns: getColumns(columns),
      rows: getRows(users),
    );
  }

  List<DataColumn> getColumns(List<String> columns) {
    return columns.map((String column) {
      final isAge = column == columns[2];

      return DataColumn(
        label: Text(column),
        numeric: isAge,
      );
    }).toList();
  }

  List<DataRow> getRows(List<User> users) => users.map((User user) {
        final cells = [user.firstName, user.lastName, user.age];

        return DataRow(
          cells: Utils.modelBuilder(cells, (index, cell) {
            final showEditIcon = index == 0 || index == 1;

            return DataCell(
              Text('$cell'),
              showEditIcon: showEditIcon,
              onTap: () {
                switch (index) {
                  case 0:
                    editFirstName(user);
                    break;
                  case 1:
                    editLastName(user);
                    break;
                }
              },
            );
          }),
        );
      }).toList();

  Future editFirstName(User editUser) async {
    final firstName = await showTextDialog(
      context,
      title: 'Change First Name',
      value: editUser.firstName,
    );

    setState(() => users = users.map((user) {
          final isEditedUser = user == editUser;

          return isEditedUser ? user.copy(firstName: firstName) : user;
        }).toList());
  }

  Future editLastName(User editUser) async {
    final lastName = await showTextDialog(
      context,
      title: 'Change Last Name',
      value: editUser.lastName,
    );

    setState(() => users = users.map((user) {
          final isEditedUser = user == editUser;

          return isEditedUser ? user.copy(lastName: lastName) : user;
        }).toList());
  }
}
