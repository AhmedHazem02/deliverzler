const admin = require('firebase-admin');
const path = require('path');

// Initialize Firebase Admin SDK
const serviceAccountPath = path.join(__dirname, 'studio-2837415731-5df0e-firebase-adminsdk-fbsvc-1b54822015.json');
const serviceAccount = require(serviceAccountPath);

if (!admin.apps.length) {
    admin.initializeApp({
        credential: admin.credential.cert(serviceAccount),
        projectId: 'studio-2837415731-5df0e'
    });
}

const db = admin.firestore();

async function seedOrders() {
    try {
        const orders = [
            {
                id: 'order_test_1',
                date: Date.now(),
                pickupOption: 'delivery',
                paymentMethod: 'cash',
                addressModel: {
                    state: 'Sohag',
                    city: 'Girga',
                    street: 'El Mahatta Street', // Popular street in Girga
                    mobile: '01012345678',
                    geoPoint: new admin.firestore.GeoPoint(26.3419, 31.8895) // Coordinates for Girga, Sohag
                },
                userModel: {
                    id: 'user_test_1',
                    name: 'Ahmed Mohamed',
                    email: 'ahmed.mohamed@example.com',
                    phone: '01012345678',
                    image: 'https://i.pravatar.cc/150?u=a042581f4e29026024d'
                },
                items: [
                    {
                        productId: 'prod_1',
                        name: 'Grilled Chicken Meal',
                        quantity: 2,
                        price: 150,
                        image: 'https://www.themealdb.com/images/media/meals/sutysw1468247559.jpg',
                        category: 'Main Courses',
                        description: 'Delicious grilled chicken with rice'
                    }
                ],
                orderStatus: 'upcoming',
                total: 300,
                subTotal: 300,
                deliveryImage: '',
                description: 'Please deliver to the 2nd floor.',
                note: 'Make it spicy.'
            },
            {
                id: 'order_test_2',
                date: Date.now() + 3600000, // +1 hour
                pickupOption: 'delivery',
                paymentMethod: 'cash',
                addressModel: {
                    state: 'Sohag',
                    city: 'Girga',
                    street: 'Nile Corniche',
                    mobile: '01198765432',
                    geoPoint: new admin.firestore.GeoPoint(26.3350, 31.8950) // Another spot in Girga
                },
                userModel: {
                    id: 'user_test_2',
                    name: 'Sara Ibrahim',
                    email: 'sara.ibrahim@example.com',
                    phone: '01198765432',
                    image: 'https://i.pravatar.cc/150?u=a042581f4e29026704d'
                },
                items: [
                    {
                        productId: 'prod_2',
                        name: 'Beef Burger Combo',
                        quantity: 3,
                        price: 90,
                        image: 'https://www.themealdb.com/images/media/meals/urpqup1511386216.jpg',
                        category: 'Sandwiches',
                        description: 'Juicy beef burger with fries and coke'
                    }
                ],
                orderStatus: 'upcoming',
                total: 270,
                subTotal: 270,
                deliveryImage: '',
                description: 'Leave at reception.',
                note: 'No onions please.'
            }
        ];

        for (const order of orders) {
            // Use set with merge: true to avoid overwriting unrelated fields if any, 
            // but here we likely want to replace the whole test object to ensure clean state.
            await db.collection('orders').doc(order.id).set(order);
            console.log(`✅ Updated/Added order: ${order.id} in Girga, Sohag`);
        }

        console.log('🎉 Successfully updated test orders to Sohag, Girga!');
        process.exit(0);
    } catch (error) {
        console.error('Error seeding orders:', error);
        process.exit(1);
    }
}

seedOrders();
