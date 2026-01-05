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

async function updateOrdersWithGeoPoint() {
  try {
    // Get all orders
    const ordersSnapshot = await db.collection('orders').get();
    
    console.log(`Found ${ordersSnapshot.size} orders`);
    
    for (const doc of ordersSnapshot.docs) {
      const data = doc.data();
      console.log(`\nOrder: ${doc.id}`);
      console.log('Current address:', JSON.stringify(data.address || data.addressModel, null, 2));
      
      // Check if address needs geoPoint
      const address = data.address || data.addressModel;
      
      if (!address || !address.geoPoint) {
        // Add a test geoPoint (Gerga, Egypt - from screenshot)
        const updatedAddress = {
          state: address?.state || 'Sohag',
          city: address?.city || 'Gerga',
          street: address?.street || 'Main Street',
          mobile: address?.mobile || '01234567890',
          geoPoint: new admin.firestore.GeoPoint(26.3389, 31.8917) // Gerga coordinates
        };
        
        await db.collection('orders').doc(doc.id).update({
          address: updatedAddress
        });
        
        console.log(`✅ Updated order ${doc.id} with geoPoint:`, updatedAddress.geoPoint);
      } else {
        console.log(`✓ Order ${doc.id} already has geoPoint:`, address.geoPoint);
      }
    }
    
    console.log('\n✅ All orders updated!');
    process.exit(0);
  } catch (error) {
    console.error('❌ Error:', error.message);
    process.exit(1);
  }
}

updateOrdersWithGeoPoint();
