class UserSelection {
  String language;
  String role;

  UserSelection(this.language, this.role);

  // Function that checks if the user has made a selection for each variable:
  bool validateSelection() {
    bool isEmpty = (language == 'empty' || role == 'empty') ? false : true;
    return isEmpty;
  }
}