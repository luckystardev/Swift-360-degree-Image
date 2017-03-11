
# What is this?

Image360 is a simple stack of Image360Controller + Image360View which allows you to display 360° panoramic images.
 
![alt tag](https://raw.githubusercontent.com/wonderfulmobileworld/Swift-360-degree-Image/master/example.gif)

## How to use it?
- Create an instance of `Image360Controller` in your code.
- Set 360° image as `image: UIImage` of just created instance.
- If it is necessary, set up the `inertia: Inertia` of just created instance.
 
### Example
 
```swift
 class ViewController: UIViewController {
 
 ...
 // Image360Controller is inserted to view with container view and bind with "image360" segue
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   if let identifier = segue.identifier {
   switch identifier {
     case "image360":
       if let destination = segue.destination as? Image360Controller {
         self.image360Controller.imageView.image = UIImage(named: "MyPanoramicImage")
       }
     default:
       ()
     }
   }
 
 }
```

For more details look at "iOS Example" in this repository.

