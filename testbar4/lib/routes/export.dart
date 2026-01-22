// lib/routes/export.dart

// Core/NavBar
export '../widgets/navbar.dart';
export 'icon_path.dart';

// Guest/Login
export '../screens/guest/login/p1_intro.dart';
export '../screens/guest/login/p2_login.dart';
export '../screens/guest/login/p3_register.dart';
export '../screens/guest/login/p4_forgetpass.dart';
export '../screens/guest/login/p5_aftersign_inwithG.dart';
export '../screens/guest/login/components/login_compponents.dart';
export '../screens/guest/login/components/register_compponents.dart';

// Home/Main Screens
export '../screens/p1_home.dart';
// export '../services/firebase/Fire_Activity.dart'; // Moved to Services section below
export '../screens/p2_location.dart';
export '../screens/p3_run.dart';
export '../screens/p4_plan.dart';
export '../screens/p5_profile.dart';

// Services
export '../services/firebase/Fire_Activity.dart' hide firestore, auth;
export '../services/firebase/Fire_User.dart' hide firestore, auth;
export '../services/firebase/Fire_Shoes.dart' hide firestore, auth, user;
export '../services/firebase/Fire_Visit.dart' hide firestore, auth;
export '../services/firebase/Fire_UserChallenge.dart'
    hide firestore, auth, user;
export '../services/firebase/Fire_Challenge.dart' hide firestore, auth, user;
export '../services/firebase/Fire_Location.dart';

// Providers
export '../provider/provider_userData.dart';

// Layer 2 - Activity
export '../screens/layer2/activity/activity.dart';
export '../screens/layer2/activity/componente/acCpEdit.dart';
export '../screens/layer2/activity/componente/activityCP.dart';

// Layer 2 - Heatmap
export '../screens/layer2/heatmap/heatmapCP.dart';

// Layer 2 - Location
export '../screens/layer2/location/navigation.dart';
export '../screens/layer2/location/moreinfoMap.dart';
export '../screens/layer2/location/component/addlocation.dart';
export '../screens/layer2/location/component/editlocation.dart';
export '../screens/layer2/location/component/map.dart';
export '../screens/layer2/location/component/card.dart';

// Layer 2 - Shoes
export '../screens/layer2/shose/shoes.dart';
export '../screens/layer2/shose/addshoes.dart';
export '../screens/layer2/shose/components/shoescomP.dart';
export '../screens/layer2/shose/components/addshoescomP.dart'
    hide BirthdayTextField;
export '../screens/layer2/selectShoes/selectShoes.dart';

// Layer 2 - P4/P5 Children
export '../screens/layer2/p4-child/addcontanceSC.dart';
export '../screens/layer2/p4-child/cardswiper.dart';
export '../screens/layer2/p4-child/component.dart';
export '../screens/p5-child/edite_profile.dart';
export '../screens/p5-child/CPediteprofile.dart';
