import 'package:flutter/material.dart';

import 'Reuseable Widget/CustomDropDown.dart';
import 'Reuseable Widget/gradienttextfield.dart';

class NewUserCheckForm extends StatefulWidget {
  const NewUserCheckForm({super.key});

  @override
  State<NewUserCheckForm> createState() => _NewUserCheckFormState();
}

class _NewUserCheckFormState extends State<NewUserCheckForm> {
  final GlobalKey dialog1Key = GlobalKey();
  final GlobalKey dialog2Key = GlobalKey();
  List<String> items = [
    'Technology & Software Development',
    'Arts & Entertainment',
    'Media & Journalism',
    'Music & Performing Arts',
    'Banking & Finance',
    'Consulting',
    'Marketing & Advertising',
    'Healthcare & Medicine',
    'Education & Research',
    'Business & Management'
  ];
  List<String> selectedItems = [];

  void _showPopupForm(BuildContext context, GlobalKey key) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          key: key,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6), // No rounded corners
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                      onTap: () {
                        // StorageService.write('newUserToShowForm', 'No');
                        // setState(() {
                        //   toggleStatus = null;
                        //   newUserToShowForm = true;
                        // });
                        Navigator.of(context).pop(false);
                      },
                      child: const Icon(Icons.close, size: 18, color: Colors.grey,)),),
                const SizedBox(height: 20,),
                const Stack(
                  children: [
                    Positioned(
                      top: -4,
                      child: Text(
                        'Headline', // Persistent label
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    TextField(
                      // controller: headLineController,
                      decoration: InputDecoration(
                        hintText: 'Type something',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
                        border: InputBorder.none, // No outer border
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ), // Bottom border when enabled
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ), // Bottom border when focused
                        ),
                        contentPadding: EdgeInsets.only(bottom: -8),  // Remove extra padding inside the field
                      ),
                      style: TextStyle(fontSize: 16), // Optional: Adjust font size
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const Stack(
                  children: [
                    Positioned(
                      top: -4,
                      child: Text(
                        'What are you exactly looking for?', // Persistent label
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    TextField(
                      // controller: whatAreYouLookingForController,
                      decoration: InputDecoration(
                        hintText: 'Type something',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
                        border: InputBorder.none, // No outer border
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ), // Bottom border when enabled
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ), // Bottom border when focused
                        ),
                        contentPadding: EdgeInsets.only(bottom: -8),  // Remove extra padding inside the field
                      ),
                      style: TextStyle(fontSize: 16), // Optional: Adjust font size
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () async {
                    _showScrollablePopupFormProfession(context, dialog2Key);
                  },
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                      border: Border.all(color: Colors.grey),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Wrap Flexible directly around the Text widget
                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.0),
                            child: Text(
                              'What is your main professional focus?',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis, // Handle overflow
                              style: TextStyle(color: Colors.black, fontSize: 14),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: Icon(Icons.keyboard_arrow_right, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomGradientdropdownTextField(
                  height: 49.5,
                  hintText: 'Specify your interest',
                  items: const ['Painting', 'Journaling', 'Dancing', 'Writing Poems'],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        // _educationController = value?.value;
                        // debugPrint('$_educationController');
                      });
                    }
                  },
                  label: const Text('Skills'),
                ),
                const SizedBox(height: 40,),
                SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    onPressed: () {
                      // StorageService.write('newUserToShowForm', 'No');
                      // setState(() {
                      //   toggleStatus = null;
                      //   newUserToShowForm = true;
                      // });
                      // updateUserInfoWithShowPopupForm();
                      // Navigator.of(context).pop(false);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6), // Adjust the radius as needed
                        ),
                        disabledBackgroundColor: Colors.black,
                        disabledForegroundColor: Colors.black),
                    child: const Text(
                      'Done',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showScrollablePopupFormProfession(BuildContext context, GlobalKey key) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          key: key,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6), // No rounded corners
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: StatefulBuilder(
                builder: (context, setState) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: const Icon(Icons.close, size: 18, color: Colors.grey,),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'What is your main professional focus?',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      // List of professions with scroll
                      Column(
                        children: items.map((item) {
                          bool isSelected = selectedItems.contains(item);
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  selectedItems.remove(item);
                                } else {
                                  selectedItems.add(item);
                                }
                              });
                            },
                            child: Container(
                              width: double.infinity, // Takes maximum width
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                gradient: isSelected
                                    ? const LinearGradient(
                                  colors: [Colors.purple, Colors.blue],
                                )
                                    : null,
                                color: isSelected ? null : Colors.white,
                                border: Border.all(color: Colors.grey),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                              child: Text(
                                item,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),
                      // Done button
                      SizedBox(
                        height: 50,
                        width: double.infinity, // Make the button take full width
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close dialog after selecting
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6), // Adjust the radius as needed
                            ),
                          ),
                          child: const Text('Done'),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              _showPopupForm(context, dialog1Key);
            },
            child: const Text('Show Form')),
      ),
    );
  }
}




// Function to show the dialog
// void _showPopupForm(BuildContext context) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: Align(
//             alignment: Alignment.topRight,
//             child: GestureDetector(
//                 onTap: () {
//                   StorageService.write('newUserToShowForm', 'No');
//                   setState(() {
//                     toggleStatus = null;
//                     newUserToShowForm = true;
//                   });
//                   Navigator.of(context).pop(false);
//                 },
//                 child: const Icon(Icons.close))),
//         content: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.max,
//             children: [
//               TextField(
//                 controller: headLineController,
//                 decoration: InputDecoration(
//                   labelText: 'Headline',
//                   hintText: 'Type something',
//                   labelStyle: const TextStyle(color: Colors.black),
//                   border: OutlineInputBorder(
//                     borderSide: const BorderSide(color: Colors.grey),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: const BorderSide(color: Colors.grey),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: const BorderSide(color: Colors.grey),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//               ),
//               const SizedBox(
//                 height: 16,
//               ),
//               TextField(
//                 controller: whatAreYouLookingForController,
//                 decoration: InputDecoration(
//                   labelText: 'What are you exactly looking for?',
//                   hintText: 'Type something',
//                   labelStyle: const TextStyle(color: Colors.black),
//                   border: OutlineInputBorder(
//                     borderSide: const BorderSide(color: Colors.grey),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: const BorderSide(color: Colors.grey),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: const BorderSide(color: Colors.grey),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//               ),
//               const SizedBox(
//                 height: 16,
//               ),
//               DropDownTextField(
//                 controller: _mainProfessionController,
//                 clearOption: true,
//                 dropDownItemCount: 6,
//                 dropDownList: yourMainProfessionItems.map((item) {
//                   return DropDownValueModel(name: item, value: item);
//                 }).toList(),
//                 onChanged: (value) {
//                   setState(() {
//                     yourMainProfession =
//                         value.value; // Update the selected value
//                   });
//                 },
//                 textFieldDecoration: InputDecoration(
//                     labelText: 'What is your main professional focus?',
//                     labelStyle: const TextStyle(color: Colors.grey),
//                     border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10)),
//                     hintText: 'Select profession',
//                     hintStyle: const TextStyle(color: Colors.grey)),
//               ),
//               const SizedBox(
//                 height: 16,
//               ),
//               TextField(
//                 controller: skillsController,
//                 decoration: InputDecoration(
//                   labelText: 'Skills',
//                   hintText: 'Type something',
//                   labelStyle: const TextStyle(color: Colors.black),
//                   border: OutlineInputBorder(
//                     borderSide: const BorderSide(color: Colors.grey),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: const BorderSide(color: Colors.grey),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: const BorderSide(color: Colors.grey),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         actions: [
//           SizedBox(
//             width: 300,
//             child: ElevatedButton(
//               onPressed: () {
//                 StorageService.write('newUserToShowForm', 'No');
//                 setState(() {
//                   toggleStatus = null;
//                   newUserToShowForm = true;
//                 });
//                 updateUserInfoWithShowPopupForm();
//                 Navigator.of(context).pop(false);
//               },
//               style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.black,
//                   foregroundColor: Colors.black,
//                   disabledBackgroundColor: Colors.black,
//                   disabledForegroundColor: Colors.black),
//               child: const Text(
//                 'Done',
//                 style: TextStyle(color: Colors.white),
//               ),
//             ),
//           ),
//         ],
//       );
//     },
//   );
// }