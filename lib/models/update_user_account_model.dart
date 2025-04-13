import 'package:flutter/material.dart';

class UpdateUserAccountModel {

  int? age;
  String? dob;
  String? height;
  String? mobileNumber;
  bool? verified;
  String? about;
  String? jobTitle;
  String? preferredCountry;
  String? preferredCity;
  String? politicalViews;
  String? diet;
  String? name;
  String? preferredState;
  String? education;
  int? distanceBound;
  String? profession;
  String? locationCountry;
  int? minPreferredAge;
  String? email;
  String? locationState;
  String? smoking;
  String? drinking;
  String? company;
  String? introduction;
  int? lastActivity;
  String? instituteName;
  String? jobDescription;
  int? graduationYear;
  String? gender;
  String? interestsIn;
  String? locationCity;
  String? twoLiner;
  String? genderPronouns;
  String? lookingFor;
  String? preferToDate;
  String? lifePathNumber;
  List<String>? sports;
  String? religion;
  String? likeToNetwork;
  String? jobRole;
  String? zodiac;
  String? familyPlans;
  List<String>? hobbies;
  int? maxPreferredAge;
  List<String>? images;
  String? subgender;
  String? videolink;
  List<String>? skills;
  List<String>? main_profession;
  String? headline;

  // Method to update a field by key
  void updateField(String key, dynamic value) {
    final fieldMap = {
      'age': (val) => age = val,
      'dob': (val) => dob = val,
      'height': (val) => height = val,
      'mobileNumber': (val) => mobileNumber = val,
      'verified' : (val) => verified = val,
      'about': (val) => about = val,
      'jobTitle': (val) => jobTitle = val,
      'preferredCountry': (val) => preferredCountry = val,
      'preferredCity': (val) => preferredCity = val,
      'politicalViews': (val) => politicalViews = val,
      'diet': (val) => diet = val,
      'name': (val) => name = val,
      'preferredState': (val) => preferredState = val,
      'education': (val) => education = val,
      'distanceBound': (val) => distanceBound = val,
      'profession': (val) => profession = val,
      'locationCountry': (val) => locationCountry = val,
      'minPreferredAge': (val) =>
      minPreferredAge = val,
      'email': (val) => email = val,
      'locationState': (val) => locationState = val,
      'smoking': (val) => smoking = val,
      'drinking': (val) => drinking = val,
      'company': (val) => company = val,
      'introduction': (val) => introduction = val,
      'lastActivity': (val) => lastActivity = val,
      'instituteName': (val) => instituteName = val,
      'jobDescription': (val) => jobDescription = val,
      'graduationYear': (val) => graduationYear = val,
      'gender': (val) => gender = val,
      'interestsIn': (val) => interestsIn = val,
      'locationCity': (val) => locationCity = val,
      'twoLiner': (val) => twoLiner = val,
      'genderPronouns': (val) => genderPronouns = val,
      'lookingFor': (val) => lookingFor = val,
      'preferToDate': (val) => preferToDate = val,
      'lifePathNumber': (val) => lifePathNumber = val,
      'sports': (val) => sports = List<String>.from(val ?? []),
      'religion': (val) => religion = val,
      'likeToNetwork': (val) => likeToNetwork = val,
      'jobRole': (val) => jobRole = val,
      'zodiac': (val) => zodiac = val,
      'familyPlans': (val) => familyPlans = val,
      'hobbies': (val) => hobbies = List<String>.from(val ?? []),
      'maxPreferredAge': (val) =>
      maxPreferredAge = val,
      'images': (val) => images = List<String>.from(val ?? []),
      'subgender': (val) => subgender = val,
      'videolink': (val) => videolink = val,
      'skills': (val) => skills = List<String>.from(val ?? []),
      'main_profession': (val) => main_profession= List<String>.from(val ?? []),
      'headline': (val) => headline =val,
    };

    if (fieldMap.containsKey(key)) {
      fieldMap[key]?.call(value);
    } else {
      debugPrint('Invalid field name: $key');
    }
  }

  // Convert to Map for passing to the IDL method
  Map<String, dynamic> toMap() {
    Map<String, dynamic> userData = {
      "age": age != null ? [age] : [],
      "dob": dob != null ? [dob] : [],
      "height": height != null ? [height] : [],
      "mobile_number": mobileNumber != null ? [mobileNumber] : [],
      "verified": verified != null ? [verified] : [],
      "about": about != null ? [about] : [],
      "job_title": jobTitle != null ? [jobTitle] : [],
      "preferred_country": preferredCountry != null ? [preferredCountry] : [],
      "preferred_city": preferredCity != null ? [preferredCity] : [],
      "main_profession": main_profession!= null ? [main_profession]: [],
      "political_views": politicalViews != null ? [politicalViews] : [],
      "diet": diet != null ? [diet] : [],
      "headline": headline != null ? [headline]: [],
      "name": name != null ? [name] : [],
      "preferred_state": preferredState != null ? [preferredState] : [],
      "education": education != null ? [education] : [],
      "distance_bound": distanceBound != null ? [distanceBound] : [],
      "profession": profession != null ? [profession] : [],
      "location_country": locationCountry != null ? [locationCountry] : [],
      "min_preferred_age": minPreferredAge != null ? [minPreferredAge] : [],
      "email": email != null ? [email] : [],
      "subgender": subgender!= null ? [subgender]: [],
      "location_state": locationState != null ? [locationState] : [],
      "smoking": smoking != null ? [smoking] : [],
      "drinking": drinking != null ? [drinking] : [],
      "videolink": videolink != null ? [videolink]: [],
      "company": company != null ? [company] : [],
      "introduction": introduction != null ? [introduction] : [],
      "last_activity": lastActivity != null ? [lastActivity] : [],
      "institute_name": instituteName != null ? [instituteName] : [],
      "job_description": jobDescription != null ? [jobDescription] : [],
      "graduation_year": graduationYear != null ? [graduationYear] : [],
      "gender": gender != null ? [gender] : [],
      "interests_in": interestsIn != null ? [interestsIn] : [],
      "location_city": locationCity != null ? [locationCity] : [],
      "two_liner": twoLiner != null ? [twoLiner] : [],
      "gender_pronouns": genderPronouns != null ? [genderPronouns] : [],
      "looking_for": lookingFor != null ? [lookingFor] : [],
      "prefer_to_date": preferToDate != null ? [preferToDate] : [],
      "life_path_number": lifePathNumber != null ? [lifePathNumber] : [],
      "sports": sports != null ? [sports] : [], // Change this line
      "religion": religion != null ? [religion] : [],
      "like_to_network": likeToNetwork != null ? [likeToNetwork] : [],
      "skills": skills != null ? [skills]: [],
      "job_role": jobRole != null ? [jobRole] : [],
      "zodiac": zodiac != null ? [zodiac] : [],
      "family_plans": familyPlans != null ? [familyPlans] : [],
      "hobbies": hobbies != null ? [hobbies] : [], // Change this line
      "max_preferred_age": maxPreferredAge != null ? [maxPreferredAge] : [],
      "images": images != null ? [images] : [], // Change this line
    };
    return userData;
  }

  UpdateUserAccountModel();
  // Factory constructor to initialize from JSON-like map
  factory UpdateUserAccountModel.fromMap(Map<dynamic, dynamic> data) {
    return UpdateUserAccountModel()
      ..age = _extractInt(data['age'])
      ..dob = _extractString(data['dob'])
      ..height = _extractString(data['height'])
      ..mobileNumber = _extractString(data['mobile_number'])
      ..verified = _extractBool(data['verified'])
      ..about = _extractString(data['about'])
      ..jobTitle = _extractString(data['job_title'])
      ..preferredCountry = _extractString(data['preferred_country'])
      ..preferredCity = _extractString(data['preferred_city'])
      ..politicalViews = _extractString(data['political_views'])
      ..diet = _extractString(data['diet'])
      ..name = _extractString(data['name'])
      ..preferredState = _extractString(data['preferred_state'])
      ..education = _extractString(data['education'])
      ..distanceBound = _extractInt(data['distance_bound'])
      ..profession = _extractString(data['profession'])
      ..locationCountry = _extractString(data['location_country'])
      ..minPreferredAge = _extractInt(data['min_preferred_age'])
      ..email = _extractString(data['email'])
      ..locationState = _extractString(data['location_state'])
      ..smoking = _extractString(data['smoking'])
      ..drinking = _extractString(data['drinking'])
      ..company = _extractString(data['company'])
      ..introduction = _extractString(data['introduction'])
      ..lastActivity = _extractInt(data['last_activity'])
      ..instituteName = _extractString(data['institute_name'])
      ..jobDescription = _extractString(data['job_description'])
      ..graduationYear = _extractInt(data['gradutation_year'])
      ..gender = _extractString(data['gender'])
      ..interestsIn = _extractString(data['interests_in'])
      ..locationCity = _extractString(data['location_city'])
      ..twoLiner = _extractString(data['two_liner'])
      ..genderPronouns = _extractString(data['gender_pronouns'])
      ..lookingFor = _extractString(data['looking_for'])
      ..preferToDate = _extractString(data['prefer_to_date'])
      ..lifePathNumber = _extractString(data['life_path_number'])
      ..sports = _extractList(data['sports'])
      ..religion = _extractString(data['religion'])
      ..likeToNetwork = _extractString(data['like_to_network'])
      ..jobRole = _extractString(data['job_role'])
      ..zodiac = _extractString(data['zodiac'])
      ..familyPlans = _extractString(data['family_plans'])
      ..hobbies = _extractList(data['hobbies'])
      ..maxPreferredAge = _extractInt(data['max_preferred_age'])
      ..images = _extractList(data['images'])
      ..videolink = _extractString(['videolink'])
      ..main_profession = _extractList(['main_profession'])
      ..skills = _extractList(['skills'])
      ..headline = _extractString(['headline'])
       ..subgender = _extractString(data['subgender']);
  }

  static int? _extractInt(dynamic value) {
    if (value is List && value.isNotEmpty) {
      return int.tryParse(value[0].toString());
    }
    return null;
  }

  static String? _extractString(dynamic value) {
    if (value is List && value.isNotEmpty) {
      return value[0].toString();
    }
    return null;
  }

  static List<String>? _extractList(dynamic value) {
    if (value is List) {
      // Flatten the list if it's nested
      List<String> result = [];
      for (var item in value) {
        if (item is List) {
          result.addAll(item.map((e) => e.toString())); // Flatten nested lists
        } else {
          result.add(item.toString()); // Convert non-list items to string
        }
      }
      return result.isNotEmpty ? result : null; // Return null if the result is empty
    }
    return null;
  }
  static bool? _extractBool(dynamic value) {
    if (value is List && value.isNotEmpty) {
      final intValue = int.tryParse(value[0].toString());
      if (intValue != null) {
        return intValue != 0; // 0 -> false, non-zero -> true
      }
    }
    return null; // Return null if value is not parsable
  }
}