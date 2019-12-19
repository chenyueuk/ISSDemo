# ISSDemo

## Installation
------------------

If the project was downloaded and unzipped from compressed file, it should be built and run without any issues.

If the project was cloned from git repo, please use **cocoapods** to fetch required dependencies. For cocoapods installation, please follow this [page](https://guides.cocoapods.org/using/getting-started.html). If cocoapods is alreay installed, please go to the **root** directory with **terminal**, and run `pod install`.

## Dependencies
------------------

1. Realm
**Realm** is a open source database library to manage app persistent data in reactive manner. For more information please follow this [link](https://realm.io/docs/swift/latest). Realm is used for offline data storage.
2. Alamofire
**Alamofire** is a open source HTTP networking library in Swift. For more information please follow this [link](https://github.com/Alamofire/Alamofire). Alamofire is used to create cleaner API calls.

## App description
------------------

### Menu

**MenuViewController** is a `UITableViewController` with it's datasource from [MenuViewModel.swift](https://github.com/chenyueuk/ISSDemo/blob/master/ISSDemo/UI/MenuViewController/MenuViewModel.swift).

In **MenuViewModel**, available options are defined in `enum Item`. The special `.test` option is only shown in *simulator* mode.

**MenuDetailsControllerProtocol** requires a initializer method `instantiateFromStoryboard()` which returns a `UIViewController`. Tapping cell in **MenuViewController** will get and push the target `UIViewController` that implements this protocol.

### Flyover times

**FlyoverTimesViewController** is a `UITableViewController` that displays the next 5 ISS flyover times for the device location. It uses [LocationUpdater](https://github.com/chenyueuk/ISSDemo/blob/master/ISSDemo/Utils/CoreLocation/LocationUpdater.swift) to get the current location of device, then call [GetFlyoverTimesService](https://github.com/chenyueuk/ISSDemo/blob/master/ISSDemo/WebService/GetFlyoverTimesService.swift) to fetch the ISS flyover times.

**LocationUpdater** uses *CoreLocation* framework, when `func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading)` called, it saves the location data into Realm database's **LocationStream** object.

After **LocationStream** updated in database, a Realm `NotificationToken` will get the notification and further call ISS API to get flyover times with the updated locations. Successful `GetFlyoverTimesService` call will write flyover times into **ISSPassTimes** object in Realm database.

After **ISSPassTimes** object updated, **FlyoverTimesViewController** gets a notification, then call `tableView.reloadData()` to refresh the table content.
