const admin = require("firebase-admin");
const functions = require("firebase-functions");

admin.initializeApp();

const fcm = admin.messaging();
const db = admin.firestore();

exports.senddevices = functions.firestore
  .document("orders/{id}")
  .onUpdate((change, context) => {
    const data = change.after.data();
    const previousData = change.before.data();

    const topic = "general";
    const pickupOption = data.pickupOption;
    const deliveryStatus = data.deliveryStatus;
    const previousDeliveryStatus = previousData.deliveryStatus;

    if(pickupOption=="delivery" && deliveryStatus=="upcoming" && previousDeliveryStatus=="pending"){
        const userName = data.userName;
        const message = {
              notification: {
                title: "New Order!",
                body: "New Delivery Order from \"" + userName + "\" has been added.",
              },
              data: {"routeLocation": "/home"},
            };

        return fcm.sendToTopic(topic, message);
    }
  });

// Update store rating when a review is added
exports.onReviewCreated = functions.firestore
  .document("store_reviews/{reviewId}")
  .onCreate(async (snap, context) => {
    const review = snap.data();
    const storeId = review.storeId;
    
    if (!storeId) return null;
    
    return updateStoreRating(storeId);
  });

// Update store rating when a review is updated
exports.onReviewUpdated = functions.firestore
  .document("store_reviews/{reviewId}")
  .onUpdate(async (change, context) => {
    const review = change.after.data();
    const storeId = review.storeId;
    
    if (!storeId) return null;
    
    return updateStoreRating(storeId);
  });

// Update store rating when a review is deleted
exports.onReviewDeleted = functions.firestore
  .document("store_reviews/{reviewId}")
  .onDelete(async (snap, context) => {
    const review = snap.data();
    const storeId = review.storeId;
    
    if (!storeId) return null;
    
    return updateStoreRating(storeId);
  });

// Helper function to recalculate and update store rating
async function updateStoreRating(storeId) {
  try {
    const reviewsSnapshot = await db
      .collection("store_reviews")
      .where("storeId", "==", storeId)
      .get();
    
    let totalRatings = 0;
    let ratingSum = 0;
    
    reviewsSnapshot.docs.forEach((doc) => {
      const rating = doc.data().rating;
      if (typeof rating === "number") {
        ratingSum += rating;
        totalRatings++;
      }
    });
    
    const averageRating = totalRatings > 0 ? ratingSum / totalRatings : 0;
    
    await db.collection("stores").doc(storeId).update({
      rating: averageRating,
      totalRatings: totalRatings,
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });
    
    console.log(`Updated store ${storeId} rating: ${averageRating} (${totalRatings} reviews)`);
    return null;
  } catch (error) {
    console.error(`Error updating store ${storeId} rating:`, error);
    return null;
  }
}