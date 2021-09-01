// DropdownButtonFormField<ERideType>(
//   onChanged: (ERideType newValue) {
//     model.chosenRide = newValue;
//     model.notifyListeners();
//   },
//   value: model.chosenRide,
//   decoration: InputDecoration(
//     enabledBorder: customInputBorder(context),
//     border: customInputBorder(context),
//     contentPadding: EdgeInsets.symmetric(horizontal: 15.0),
//   ),
//   items: [
//     DropdownMenuItem(child: Text('Type de course', style: TextStyle(color: Colors.grey),), value: ERideType.hint),
//     DropdownMenuItem(child: Text('Course en ville'), value: ERideType.ride),
//     DropdownMenuItem(child: Text('Voyage'), value: ERideType.trip),
//   ],
// ),


// model.returnIsSameDay ? Column(
//   children: [
//     heightSpacing(),
//     GestureDetector(
//       onTap: () async {
//         TimeOfDay pickedTime = await showTimePicker(
//           initialTime: TimeOfDay(hour: 0, minute: 0),
//           cancelText: 'Annuler',
//           context: context
//         );
//         model.departureTime = pickedTime;
//         model.departureTimeController.text = model.coreService.formatTime(pickedTime);
//       },
//       child: TextFormField(
//           controller: model.departureTimeController,
//           enabled: false,
//           decoration: InputDecoration(
//             labelText: "Heure de départ",
//             prefixIcon: Icon(Icons.timelapse, color: Theme.of(context).primaryColor),
//             contentPadding: EdgeInsets.all(0),
//             enabledBorder: customInputBorder(context),
//             border: customInputBorder(context),
//             disabledBorder: customInputBorder(context),
//           )
//       ),
//     ),
//     heightSpacing(),
//     GestureDetector(
//       onTap: () async {
//         TimeOfDay pickedTime = await showTimePicker(
//           context: context,
//           initialTime: TimeOfDay(hour: 0, minute: 0),
//           cancelText: 'Annuler',
//         );
//         model.returnTime = pickedTime;
//         model.returnTimeController.text = model.coreService.formatTime(pickedTime);
//         var rideDuration = model.returnTime.hour - model.departureTime.hour;
//         model.rideDurationController.text = "${rideDuration.toString()} Heures";
//       },
//       child: TextFormField(
//           controller: model.returnTimeController,
//           enabled: false,
//           decoration: InputDecoration(
//             labelText: "Heure de retour",
//             prefixIcon: Icon(Icons.timelapse, color: Theme.of(context).primaryColor),
//             contentPadding: EdgeInsets.all(0),
//             enabledBorder: customInputBorder(context),
//             border: customInputBorder(context),
//             disabledBorder: customInputBorder(context),
//           )
//       ),
//     ),
//   ],
// ) : Container(),