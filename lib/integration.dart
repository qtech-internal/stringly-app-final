import 'package:agent_dart/agent_dart.dart';

final chatListItem = IDL.Record({
  'content' : IDL.Text,
  'name' : IDL.Text,
  'timestamp' : IDL.Nat64,
  'image' : IDL.Vec(IDL.Text),
  'chat_id' : IDL.Text,
});

final result = IDL.Variant({
  'Ok' : IDL.Vec(chatListItem),
  'Err' : IDL.Text,
});

final userInputParams = IDL.Record({
  'age' : IDL.Opt(IDL.Nat64),
  'dob' : IDL.Opt(IDL.Text),
  'height' : IDL.Opt(IDL.Text),
  'mobile_number' : IDL.Opt(IDL.Text),
  'verified' : IDL.Opt(IDL.Bool),
  'about' : IDL.Opt(IDL.Text),
  'job_title' : IDL.Opt(IDL.Text),
  'preferred_country' : IDL.Opt(IDL.Text),
  'preferred_city' : IDL.Opt(IDL.Text),
  'main_profession' : IDL.Opt(IDL.Vec(IDL.Text)),
  'political_views' : IDL.Opt(IDL.Text),
  'diet' : IDL.Opt(IDL.Text),
  'headline' : IDL.Opt(IDL.Text),
  'name' : IDL.Opt(IDL.Text),
  'preferred_state' : IDL.Opt(IDL.Text),
  'education' : IDL.Opt(IDL.Text),
  'distance_bound' : IDL.Opt(IDL.Nat64),
  'profession' : IDL.Opt(IDL.Text),
  'location_country' : IDL.Opt(IDL.Text),
  'min_preferred_age' : IDL.Opt(IDL.Nat64),
  'email' : IDL.Opt(IDL.Text),
  'subgender' : IDL.Opt(IDL.Text),
  'location_state' : IDL.Opt(IDL.Text),
  'smoking' : IDL.Opt(IDL.Text),
  'drinking' : IDL.Opt(IDL.Text),
  'videolink' : IDL.Opt(IDL.Text),
  'company' : IDL.Opt(IDL.Text),
  'introduction' : IDL.Opt(IDL.Text),
  'last_activity' : IDL.Opt(IDL.Nat64),
  'institute_name' : IDL.Opt(IDL.Text),
  'job_description' : IDL.Opt(IDL.Text),
  'graduation_year' : IDL.Opt(IDL.Nat64),
  'gender' : IDL.Opt(IDL.Text),
  'interests_in' : IDL.Opt(IDL.Text),
  'location_city' : IDL.Opt(IDL.Text),
  'two_liner' : IDL.Opt(IDL.Text),
  'gender_pronouns' : IDL.Opt(IDL.Text),
  'looking_for' : IDL.Opt(IDL.Text),
  'prefer_to_date' : IDL.Opt(IDL.Text),
  'life_path_number' : IDL.Opt(IDL.Text),
  'sports' : IDL.Opt(IDL.Vec(IDL.Text)),
  'religion' : IDL.Opt(IDL.Text),
  'like_to_network' : IDL.Opt(IDL.Text),
  'skills' : IDL.Opt(IDL.Vec(IDL.Text)),
  'job_role' : IDL.Opt(IDL.Text),
  'zodiac' : IDL.Opt(IDL.Text),
  'family_plans' : IDL.Opt(IDL.Text),
  'hobbies' : IDL.Opt(IDL.Vec(IDL.Text)),
  'max_preferred_age' : IDL.Opt(IDL.Nat64),
  'images' : IDL.Opt(IDL.Vec(IDL.Text)),
});

final result_1 = IDL.Variant({ 'Ok' : IDL.Text, 'Err' : IDL.Text });

final notificationType = IDL.Variant({ 'Like' : IDL.Null });

final notification = IDL.Record({
  'receiver_id' : IDL.Text,
  'notification_type' : notificationType,
  'sender_id' : IDL.Text,
});

final userProfileParams = IDL.Record({
  'age' : IDL.Opt(IDL.Nat64),
  'dob' : IDL.Opt(IDL.Text),
  'height' : IDL.Opt(IDL.Text),
  'mobile_number' : IDL.Opt(IDL.Text),
  'verified' : IDL.Opt(IDL.Bool),
  'about' : IDL.Opt(IDL.Text),
  'job_title' : IDL.Opt(IDL.Text),
  'preferred_country' : IDL.Opt(IDL.Text),
  'preferred_city' : IDL.Opt(IDL.Text),
  'notifications' : IDL.Opt(IDL.Vec(notification)),
  'main_profession' : IDL.Opt(IDL.Vec(IDL.Text)),
  'political_views' : IDL.Opt(IDL.Text),
  'diet' : IDL.Opt(IDL.Text),
  'headline' : IDL.Opt(IDL.Text),
  'name' : IDL.Opt(IDL.Text),
  'preferred_state' : IDL.Opt(IDL.Text),
  'education' : IDL.Opt(IDL.Text),
  'distance_bound' : IDL.Opt(IDL.Nat64),
  'profession' : IDL.Opt(IDL.Text),
  'location_country' : IDL.Opt(IDL.Text),
  'min_preferred_age' : IDL.Opt(IDL.Nat64),
  'user_id' : IDL.Opt(IDL.Text),
  'email' : IDL.Opt(IDL.Text),
  'subgender' : IDL.Opt(IDL.Text),
  'location_state' : IDL.Opt(IDL.Text),
  'smoking' : IDL.Opt(IDL.Text),
  'drinking' : IDL.Opt(IDL.Text),
  'likes' : IDL.Opt(IDL.Vec(IDL.Text)),
  'videolink' : IDL.Opt(IDL.Text),
  'company' : IDL.Opt(IDL.Text),
  'introduction' : IDL.Opt(IDL.Text),
  'matches' : IDL.Opt(IDL.Vec(IDL.Text)),
  'last_activity' : IDL.Opt(IDL.Nat64),
  'institute_name' : IDL.Opt(IDL.Text),
  'job_description' : IDL.Opt(IDL.Text),
  'gender' : IDL.Opt(IDL.Text),
  'interests_in' : IDL.Opt(IDL.Text),
  'location_city' : IDL.Opt(IDL.Text),
  'two_liner' : IDL.Opt(IDL.Text),
  'gender_pronouns' : IDL.Opt(IDL.Text),
  'looking_for' : IDL.Opt(IDL.Text),
  'prefer_to_date' : IDL.Opt(IDL.Text),
  'life_path_number' : IDL.Opt(IDL.Text),
  'sports' : IDL.Opt(IDL.Vec(IDL.Text)),
  'religion' : IDL.Opt(IDL.Text),
  'like_to_network' : IDL.Opt(IDL.Text),
  'skills' : IDL.Opt(IDL.Vec(IDL.Text)),
  'gradutation_year' : IDL.Opt(IDL.Nat64),
  'job_role' : IDL.Opt(IDL.Text),
  'chat_list' : IDL.Opt(IDL.Vec(IDL.Text)),
  'zodiac' : IDL.Opt(IDL.Text),
  'family_plans' : IDL.Opt(IDL.Text),
  'hobbies' : IDL.Opt(IDL.Vec(IDL.Text)),
  'max_preferred_age' : IDL.Opt(IDL.Nat64),
  'images' : IDL.Opt(IDL.Vec(IDL.Text)),
});

final userProfileCreationInfo = IDL.Record({
  'daily_checkin_count' : IDL.Nat64,
  'profile_completed' : IDL.Bool,
  'status' : IDL.Bool,
  'referrals' : IDL.Nat64,
  'successful_matches' : IDL.Nat64,
  'created_at' : IDL.Nat64,
  'user_id' : IDL.Text,
  'reward_points' : IDL.Nat64,
  'first_match' : IDL.Bool,
  'creator_principal' : IDL.Principal,
  'params' : userProfileParams,
  'first_message' : IDL.Bool,
  'feedback_given' : IDL.Bool,
});

final result_2 = IDL.Variant({
  'Ok' : IDL.Tuple([
    IDL.Nat64,
    IDL.Vec(IDL.Tuple([IDL.Text, userProfileCreationInfo])),
  ]),
  'Err' : IDL.Text,
});

final paginatedProfiles = IDL.Record({
  'total_matches' : IDL.Nat64,
  'error_message' : IDL.Opt(IDL.Text),
  'paginated_profiles' : IDL.Vec(userProfileCreationInfo),
});

final result_3 = IDL.Variant({ 'Ok' : paginatedProfiles, 'Err' : IDL.Text });

final result_4 = IDL.Variant({
  'Ok' : IDL.Vec(userProfileCreationInfo),
  'Err' : IDL.Text,
});

final swipeRecord = IDL.Record({
  'user_id' : IDL.Text,
  'swipe_type' : IDL.Text,
});

final result_5 = IDL.Variant({
  'Ok' : IDL.Vec(swipeRecord),
  'Err' : IDL.Text,
});

final profileWithContext = IDL.Record({
  'context' : IDL.Text,
  'profile' : userProfileCreationInfo,
});

final result_6 = IDL.Variant({
  'Ok' : IDL.Vec(profileWithContext),
  'Err' : IDL.Text,
});

final result_7 = IDL.Variant({
  'Ok' : userProfileCreationInfo,
  'Err' : IDL.Text,
});

final pagination = IDL.Record({ 'page' : IDL.Nat64, 'size' : IDL.Nat64 });

final result_8 = IDL.Variant({ 'Ok' : IDL.Nat64, 'Err' : IDL.Text });

final userProfiler = IDL.Record({
  'age' : IDL.Opt(IDL.Nat64),
  'dob' : IDL.Opt(IDL.Text),
  'height' : IDL.Opt(IDL.Text),
  'mobile_number' : IDL.Opt(IDL.Text),
  'verified' : IDL.Opt(IDL.Bool),
  'about' : IDL.Opt(IDL.Text),
  'job_title' : IDL.Opt(IDL.Text),
  'preferred_country' : IDL.Opt(IDL.Text),
  'preferred_city' : IDL.Opt(IDL.Text),
  'main_profession' : IDL.Opt(IDL.Vec(IDL.Text)),
  'political_views' : IDL.Opt(IDL.Text),
  'diet' : IDL.Opt(IDL.Text),
  'headline' : IDL.Opt(IDL.Text),
  'name' : IDL.Opt(IDL.Text),
  'preferred_state' : IDL.Opt(IDL.Text),
  'education' : IDL.Opt(IDL.Text),
  'distance_bound' : IDL.Opt(IDL.Nat64),
  'profession' : IDL.Opt(IDL.Text),
  'location_country' : IDL.Opt(IDL.Text),
  'min_preferred_age' : IDL.Opt(IDL.Nat64),
  'user_id' : IDL.Text,
  'email' : IDL.Opt(IDL.Text),
  'subgender' : IDL.Opt(IDL.Text),
  'location_state' : IDL.Opt(IDL.Text),
  'smoking' : IDL.Opt(IDL.Text),
  'drinking' : IDL.Opt(IDL.Text),
  'videolink' : IDL.Opt(IDL.Text),
  'company' : IDL.Opt(IDL.Text),
  'introduction' : IDL.Opt(IDL.Text),
  'last_activity' : IDL.Opt(IDL.Nat64),
  'institute_name' : IDL.Opt(IDL.Text),
  'job_description' : IDL.Opt(IDL.Text),
  'gender' : IDL.Opt(IDL.Text),
  'interests_in' : IDL.Opt(IDL.Text),
  'location_city' : IDL.Opt(IDL.Text),
  'two_liner' : IDL.Opt(IDL.Text),
  'gender_pronouns' : IDL.Opt(IDL.Text),
  'looking_for' : IDL.Opt(IDL.Text),
  'prefer_to_date' : IDL.Opt(IDL.Text),
  'life_path_number' : IDL.Opt(IDL.Text),
  'sports' : IDL.Opt(IDL.Vec(IDL.Text)),
  'religion' : IDL.Opt(IDL.Text),
  'like_to_network' : IDL.Opt(IDL.Text),
  'skills' : IDL.Opt(IDL.Vec(IDL.Text)),
  'gradutation_year' : IDL.Opt(IDL.Nat64),
  'job_role' : IDL.Opt(IDL.Text),
  'zodiac' : IDL.Opt(IDL.Text),
  'family_plans' : IDL.Opt(IDL.Text),
  'hobbies' : IDL.Opt(IDL.Vec(IDL.Text)),
  'max_preferred_age' : IDL.Opt(IDL.Nat64),
  'images' : IDL.Opt(IDL.Vec(IDL.Text)),
});

final result_9 = IDL.Variant({ 'Ok' : userProfiler, 'Err' : IDL.Text });

final swipeInput = IDL.Record({
  'receiver_id' : IDL.Text,
  'context' : IDL.Text,
  'sender_id' : IDL.Text,
});

final userMatchResult = IDL.Record({
  'user_id' : IDL.Text,
  'match_score' : IDL.Float64,
});

final result_10 = IDL.Variant({
  'Ok' : IDL.Vec(notification),
  'Err' : IDL.Text,
});

final result_11 = IDL.Variant({ 'Ok' : IDL.Null, 'Err' : IDL.Text });

// Abstract FieldsMethod Service
abstract class FieldsMethod {
  static const add_user_to_chatlist = 'add_user_to_chatlist'; // used this function
  static const check_user_match = 'check_user_match'; // used this function
  static const create_an_account = 'create_an_account'; // used this function
  static const get_added_user_chatlist = 'get_added_user_chatlist'; // used this function
  static const get_all = 'get_all'; // used this function
  static const get_all_accounts = 'get_all_accounts'; // used this function
  static const get_an_account = 'get_an_account'; // used this function
  static const get_user_id_by_principal = 'get_user_id_by_principal'; // used this function
  static const leftswipe = 'leftswipe'; // used this function
  static const rightswipe = 'rightswipe'; // used this function
  static const update_add_rightswipe = 'update_add_rightswipe';
  static const update_an_account = 'update_an_account'; // used this function
  static const update_remove_rightswipe = 'update_remove_rightswipe'; // used this function
  static const verify_account_for_caller = 'verify_account_for_caller'; // used this function
  static const update_superlike = 'update_superlike'; // used this function
  static const whoAmI = 'whoami'; // used this function
  static const  unmatch_user = 'unmatch_user'; // used this function
  static const hide_user = 'hide_user'; // used this function
  static const get_allrightswipes = 'get_allrightswipes';
  static const get_match_queue = 'get_match_queue';
  static const delete_an_account = 'delete_an_account';
  static final ServiceClass idl = IDL.Service({
    FieldsMethod.add_user_to_chatlist : IDL.Func([IDL.Text], [result], []),
    FieldsMethod.check_user_match : IDL.Func([IDL.Text, IDL.Text], [IDL.Bool], []),
    FieldsMethod.create_an_account : IDL.Func([userInputParams], [result_1], []),
    FieldsMethod.get_added_user_chatlist : IDL.Func([IDL.Text], [result], ['query']),
    FieldsMethod.get_all : IDL.Func([], [result_2], ['query']),
    FieldsMethod.get_all_accounts : IDL.Func([IDL.Text, IDL.Nat64, IDL.Nat64], [result_3], ['query']),
    FieldsMethod.get_an_account : IDL.Func([IDL.Text], [result_7], ['query']),
    FieldsMethod.get_user_id_by_principal : IDL.Func([], [result_1], ['query']),
    FieldsMethod.leftswipe : IDL.Func([swipeInput], [IDL.Text], []),
    FieldsMethod.rightswipe : IDL.Func([swipeInput], [IDL.Text], []),
    FieldsMethod.update_add_rightswipe : IDL.Func([IDL.Text, IDL.Text], [result_1], []),
    FieldsMethod.update_an_account : IDL.Func([IDL.Text, userInputParams], [result_1], []),
    FieldsMethod.update_remove_rightswipe : IDL.Func([IDL.Text, IDL.Text], [result_1], []),
    FieldsMethod.verify_account_for_caller : IDL.Func([], [result_1], ['query']),
    FieldsMethod.update_superlike : IDL.Func([IDL.Text, IDL.Text], [result_1], []),
    FieldsMethod.whoAmI : IDL.Func([], [IDL.Text], ['query']),
    FieldsMethod.unmatch_user : IDL.Func([IDL.Text, IDL.Text], [result_1], []),
    FieldsMethod.hide_user : IDL.Func([IDL.Text, IDL.Text], [result_1], []),
    FieldsMethod.get_allrightswipes: IDL.Func([IDL.Text], [result_6], ['query']),
    FieldsMethod.get_match_queue: IDL.Func([IDL.Text], [result_6], ['query']),
    FieldsMethod.delete_an_account: IDL.Func([IDL.Text], [result_1], []),
  });
}
