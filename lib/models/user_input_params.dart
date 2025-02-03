import 'package:flutter/material.dart';

class UserInputParams {
  static final UserInputParams _instance = UserInputParams._internal();

  factory UserInputParams() {
    return _instance;
  }

  UserInputParams._internal();

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
  // Method to reset all fields to default values
  void reset() {
    age = null;
    dob = null;
    height = null;
    mobileNumber = null;
    verified = null;
    about = null;
    jobTitle = null;
    preferredCountry = null;
    preferredCity = null;
    politicalViews = null;
    diet = null;
    name = null;
    preferredState = null;
    education = null;
    distanceBound = null;
    profession = null;
    locationCountry = null;
    minPreferredAge = null;
    email = null;
    locationState = null;
    smoking = null;
    drinking = null;
    company = null;
    introduction = null;
    lastActivity = null;
    instituteName = null;
    jobDescription = null;
    graduationYear = null;
    gender = null;
    interestsIn = null;
    locationCity = null;
    twoLiner = null;
    genderPronouns = null;
    lookingFor = null;
    preferToDate = null;
    lifePathNumber = null;
    sports = null;
    religion = null;
    likeToNetwork = null;
    jobRole = null;
    zodiac = null;
    familyPlans = null;
    hobbies = null;
    maxPreferredAge = null;
    images = null;
    subgender = null;
    videolink = null;
    skills = null;
    main_profession = null;
    headline = null;
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

}