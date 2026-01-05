const admin = require('firebase-admin');
const path = require('path');

// Initialize Firebase Admin SDK
const serviceAccountPath = path.join(__dirname, 'studio-2837415731-5df0e-firebase-adminsdk-fbsvc-1b54822015.json');
const serviceAccount = require(serviceAccountPath);

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  projectId: 'studio-2837415731-5df0e'
});

const db = admin.firestore();

async function addTestOrder() {
  try {
    // Get users from Firebase Auth
    const auth = admin.auth();
    const usersResult = await auth.listUsers(1);
    
    if (usersResult.users.length === 0) {
      console.error('❌ No users found in Firebase Auth. Please create a user first.');
      process.exit(1);
    }
    
    const userId = usersResult.users[0].uid;
    
    const orderData = {
      id: 'order1',
      date: admin.firestore.Timestamp.now(),
      pickupOption: 'delivery',
      deliveryStatus: 'upcoming',
      deliveryId: '',
      userId: userId,
      address: 'Test Address',
      addressDetails: '',
      geoPoint: new admin.firestore.GeoPoint(0, 0),
      userName: 'Test User',
      userPhone: '123456789',
      paymentMethod: 'cash',
      userImage: '',
      userNote: '',
      employeeCancelNote: null,
      deliveryGeoPoint: null,
      addressModel: {
        state: 'Test State',
        city: 'Test City',
        street: 'Test Street',
        mobile: '123456789',
        geoPoint: new admin.firestore.GeoPoint(26.3389, 31.8917)
      }
    };

    // Add document to orders collection
    await db.collection('orders').doc('order1').set(orderData);
    
    console.log('✅ Document added successfully!');
    console.log('Collection: orders');
    console.log('Document ID: order1');
    console.log('User ID:', userId);
    console.log('\nData added:');
    console.log(JSON.stringify(orderData, null, 2));
    
    process.exit(0);
  } catch (error) {
    console.error('❌ Error adding document:', error.message);
    process.exit(1);
  }
}

addTestOrder();
