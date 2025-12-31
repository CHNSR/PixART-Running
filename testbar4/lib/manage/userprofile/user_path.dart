class UserProfile{
  final Map<String,String> userProfilePath={
    "glasses":"assets/image/userProfile/3d-glasses.png",
    "cold":"assets/image/userProfile/cold.png",
    "confounded":"assets/image/userProfile/confounded.png",
    "crying":"assets/image/userProfile/crying.png",
    "face-mask":"assets/image/userProfile/face-mask.png",
    "fever":"assets/image/userProfile/fever.png",
    "joy":"assets/image/userProfile/joy.png",
    "laugh":"assets/image/userProfile/laugh.png",
    "money":"assets/image/userProfile/money.png",
    "nausea":"assets/image/userProfile/nausea.png",
    "pleading":"assets/image/userProfile/pleading.png",
    "relieved":"assets/image/userProfile/relieved.png",
    "smaile":"assets/image/userProfile/smile.png",
    "star-glasses":"assets/image/userProfile/star-glasses.png",
    "sunglasses":"assets/image/userProfile/sunglasses.png",
    "tear":"assets/image/userProfile/tear.png",
    "thinking":"assets/image/userProfile/thinking.png",
    "vomiting":"assets/image/userProfile/vomiting.png",
    "wink":"assets/image/userProfile/wink.png",
    "wounded":"assets/image/userProfile/wounded.png",
    "default":"assets/image/userProfile/default.png",
  };
  String userProfileImg(String key){
    return userProfilePath[key] ?? 'assets/image/icon/pic_error.png';
  }
  
}