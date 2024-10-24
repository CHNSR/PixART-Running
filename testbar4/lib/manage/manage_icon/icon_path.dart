class IconPath {
  final Map<String, String> iconImg = {
    //home icons
    "home_outline": "assets/image/icon/home_outline.png",
    "home_select": "assets/image/icon/home_select.png",
    //location icons
    "location_outline": "assets/image/icon/location_outline.png",
    "location_select": "assets/image/icon/location_select.png",
    //profile icons
    "profile_outline": "assets/image/icon/profile_outline.png",
    "profile_select": "assets/image/icon/profile_select.png",
    //run icons
    "run_outline": "assets/image/icon/run_outline.png",
    "run_select": "assets/image/icon/run_select.png",
    //setting icons
    "setting_outline": "assets/image/icon/setting_outline.png",
    "setting_select": "assets/image/icon/setting_select.png",
    //plan icons
    "plan_outline": "assets/image/icon/plan_outline.png",
    "plan_select": "assets/image/icon/plan_select.png",
    //lock icon
    "lock_outline": "assets/image/icon/lock_outline.png",
    "lock_select": "assets/image/icon/lock_select.png",
    //google icon
    "google_outline": "assets/image/icon/google_outline.png",
    //facebook
    "facebook_outline": "assets/image/icon/facebook_outline.png",
    //logout icon
    "logout_outline": "assets/image/icon/logout_outline.png",
    "logout_select": "assets/image/icon/logout_select.png",
    //register
    "register_outline": "assets/image/icon/register_outline.png",
    "register_select": "assets/image/icon/register_select.png",
    //arrow
    "arrowR_outline": "assets/image/icon/arrowR_outline.png",
    //shoes
    "shoes_outline": "assets/image/icon/shoes_outline.png",
    "shoes_select": "assets/image/icon/shoes_select.png",
    //running pic
    "running_img": "assets/image/icon/running_img.png",
    //add
    "add_select": "assets/image/icon/add_select.png",
    "add_outline": "assets/image/icon/add_outline.png",
    //moreinfor
    "moreInfo_outline": "assets/image/icon/moreInfo_outline.png",
    //document
    "document_outline": "assets/image/icon/document_outline.png",
    //delete
    "delete_outline": "assets/image/icon/delete_outline.png",
    "delete_select": "assets/image/icon/delete_select.png",
    "deleteDoc_outline": "assets/image/icon/deleteDoc_outline.png",
    //navigator
    "navigation_outline": "assets/image/icon/navigation_outline.png",
    "navigation_select": "assets/image/icon/navigation_select.png",
    //add location button
    "addLocationPR_outline": "assets/image/icon/addLocationPR_outline.png",
    "addLocationPL_outline": "assets/image/icon/addLocationPR_outline.png",
    //coin
    "coin_outline": "assets/image/icon/coin_outline.png",
    //distance
    "distance_outline": "assets/image/icon/distance_outline.png",
    //clock
    "clock_outline": "assets/image/icon/clock_outline.png",
    //best
    "best_outline": "assets/image/icon/best_outline.png",
    //fast 
    "fast_outline": "assets/image/icon/fast_outline.png",
    //letsGo
    "letsGo_outline": "assets/image/icon/letsGo_outline.png",
    //finish
    "finish_outline": "assets/image/icon/finish_outline.png",
    //square
    "square_outline":"assets/image/icon/square_outline.png",
    //stop
    "stop_outline":"assets/image/icon/stop_outline.png",
    //select shoes to track running
    "shoesSelection_outline":"assets/image/icon/shoesSelection_outline.png",
    "shoesSelection_select":"assets/image/icon/shoesSelection_select.png",
    //all marker
    "pin_black":"assets/image/icon/pin_black.png",
    "pin_red":"assets/image/icon/pin_red.png",
    "pin_green":"assets/image/icon/pin_green.png",
    "pin_red_pixel":"assets/image/icon/pin_red_pixel.png",
    //play
    "play-button_outline":"assets/image/icon/play-button_outline.png",
    //end
    "the-end_outline":"assets/image/icon/the-end_outline.png",
    //pause
    "pause_outline":"assets/image/icon/pause_outline.png",
    //user profile defult
    "userprofile_defult":"assets/image/icon/userprofile_defult.png",

    
  };

  String appBarIcon(String type) {
    return iconImg[type] ?? 'assets/image/icon/pic_error.png';
  }
}
