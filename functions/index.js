const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

const firestore = admin.firestore();

exports.onUserStatusChange = functions.database
    .ref("/{phonenum}/presence")
    .onUpdate(async (change, context) => {
      const isOnline = change.after.val();


      const userStatusFirestoreRef =
      firestore.doc(`users/${context.params.phonenum}`);
      console.log(`status: ${isOnline}`);

      // Update the values on Firestore
      return userStatusFirestoreRef.update({
        presence: isOnline,
        last_seen: Date.now(),
      });
    });
