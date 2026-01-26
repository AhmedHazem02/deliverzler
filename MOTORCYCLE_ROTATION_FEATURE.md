# Motorcycle Rotation Feature Implementation

## Overview
This document describes the implementation of dynamic motorcycle marker rotation on the map based on the delivery person's heading/bearing direction.

## Problem
Previously, the motorcycle marker was displayed as a static point on the map without indicating the direction of movement, which is not intuitive for delivery tracking apps.

## Solution
Added `deliveryHeading` field throughout the architecture to track and display the delivery person's direction of movement.

## Implementation Details

### 1. Domain Layer Changes

#### `order.dart`
- Added `deliveryHeading` field of type `double?` to the `AppOrder` entity
- This field stores the delivery person's heading in degrees (0-360)

#### `update_delivery_geopoint.dart`
- Added `heading` field to `UpdateDeliveryGeoPoint` value object
- This ensures heading is sent along with geolocation updates

### 2. Infrastructure Layer Changes

#### `order_dto.dart`
- Added `deliveryHeading` field to `OrderDto`
- Updated `fromDomain()` and `toDomain()` methods to map the field

#### `update_delivery_geo_point_dto.dart`
- Added `heading` field with `@JsonKey(name: 'deliveryHeading')` annotation
- This ensures proper Firebase field naming
- Made `orderId` excluded from JSON (`includeToJson: false`)

### 3. Presentation Layer Changes

#### `update_delivery_geo_point_provider.dart`
- Updated to include `position.heading` when creating `UpdateDeliveryGeoPoint`
- This automatically captures heading from GPS data

#### `my_location_marker_provider.dart`
- Already using `heading` from `locationStreamProvider`
- No changes needed - the rotation is already implemented using `MapStyleHelper.getMyLocationMarker()`

### 4. Map Helper

#### `map_style_helper.dart`
- `getMyLocationMarker()` method already accepts `rotation` parameter
- Sets `flat: true` for proper rotation behavior
- Sets `anchor: const Offset(0.5, 0.5)` for center-based rotation

## Data Flow

```
GPS Location Update (with heading)
        ↓
LocationService (captures heading from GPS)
        ↓
locationStreamProvider
        ↓
updateDeliveryGeoPointProvider
        ↓
UpdateDeliveryGeoPoint (orderId, geoPoint, heading)
        ↓
UpdateDeliveryGeoPointDto (serialized with deliveryGeoPoint & deliveryHeading)
        ↓
Firebase Firestore Update
        ↓
OrderDto (reads deliveryGeoPoint & deliveryHeading from Firebase)
        ↓
AppOrder (domain entity with deliveryHeading)
        ↓
myLocationMarkerProvider (uses heading for rotation)
        ↓
MapStyleHelper.getMyLocationMarker(rotation: heading)
```

## Firebase Schema

### Orders Collection
Each order document now includes:
```json
{
  "deliveryGeoPoint": GeoPoint(latitude, longitude),
  "deliveryHeading": 45.0  // degrees (0-360)
}
```

## Performance Considerations

1. **Efficient Updates**: Heading is sent only when location changes (every 5 seconds or 50 meters)
2. **Parallel Execution**: Multiple orders are updated in parallel using `Future.wait()`
3. **Stream Optimization**: Uses `throttleTime()` to prevent excessive updates
4. **Custom Equality**: `deliveryGeoPoint` excluded from equality check to prevent unnecessary UI rebuilds

## Testing

### Test Data
`seed_orders.js` creates test orders with:
- `deliveryGeoPoint: null`
- `deliveryHeading: null`

These values will be populated when a delivery person starts delivering.

### How to Test
1. Run `node seed_orders.js` to add test orders
2. Login as a delivery person
3. Accept an order (deliveryStatus → 'onTheWay')
4. Move around - the motorcycle marker will rotate based on movement direction
5. The heading value (0-360 degrees) represents:
   - 0° = North
   - 90° = East
   - 180° = South
   - 270° = West

## Code Quality

### Clean Code Principles Applied
- ✅ **Single Responsibility**: Each class has one reason to change
- ✅ **Separation of Concerns**: Domain, Infrastructure, and Presentation layers properly separated
- ✅ **Immutability**: Using Freezed for immutable data classes
- ✅ **Type Safety**: Strong typing throughout the architecture
- ✅ **Null Safety**: Proper null handling with `double?` type

### High Performance Principles
- ✅ **Lazy Evaluation**: Providers only compute when watched
- ✅ **Parallel Execution**: Multiple Firebase updates run concurrently
- ✅ **Stream Optimization**: Throttling to prevent excessive updates
- ✅ **Efficient Equality**: Custom equality to avoid unnecessary rebuilds

## Browser Compatibility

### Web Platform
The `web_location_service.dart` already handles heading:
```dart
heading: (coords.heading ?? 0.0).toDouble()
```

### Mobile Platforms
Geolocator package provides heading on both Android and iOS.

## Future Enhancements

1. **Heading Smoothing**: Add interpolation for smoother rotation animations
2. **Direction Arrow**: Add a small arrow to the marker for better visibility
3. **Historical Path**: Show delivery person's path with directional indicators
4. **Offline Support**: Cache last known heading for offline scenarios

## References

- [Google Maps Marker Rotation](https://developers.google.com/maps/documentation/javascript/markers)
- [Geolocator Package](https://pub.dev/packages/geolocator)
- [Freezed Package](https://pub.dev/packages/freezed)
- [Riverpod Architecture](https://riverpod.dev/)
