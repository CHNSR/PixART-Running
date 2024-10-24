const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.deleteExpiredChallenges = functions.pubsub.schedule('every 24 hours').onRun(async (context) => {
    const now = admin.firestore.Timestamp.now();
    const expiredChallenges = [];
    
    const snapshot = await admin.firestore().collection('Challenge')
        .where('end_date', '<', now) // ฟิลด์ที่เก็บวันที่สิ้นสุดของ challenge
        .get();

    snapshot.forEach(doc => {
        expiredChallenges.push(doc.id);
    });

    // ลบ challenges ที่หมดอายุ
    const batch = admin.firestore().batch();
    expiredChallenges.forEach(id => {
        const challengeRef = admin.firestore().collection('Challenge').doc(id);
        batch.delete(challengeRef);
    });

    await batch.commit();
    console.log('Expired challenges deleted:', expiredChallenges.length);
});
