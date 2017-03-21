# OLXDemo
OLX iOS technical exercise

## UI/UX
This application queries the public OLX api /items endpoint and displays the results in a collection view.

The collection view cells show basic information such as title, price, and an image retrieved by the API.

The collection view contains a search bar which can be used to search for a specific item. The landing page shows the default items list with no search result passed in.

Tapping on a cell brings the user to a details view page. The details view page again presents the item title and price along with the image at a larger size, as well as location at the bottom. 

The details page also contains a more button which will expand the description view when tapped.

Most strings are provided by the server, however client side strings use localized string bundles. English and Spanish are currently supported by this application. Additional language support need only add additional string bundles.

## Technical details
The application architecture is based on MVVM with routing broken into its own component similar to VIPER architecture. 

Dependency injection is performed using a dependency tree. Each child module has a component which provides a dependencies. Child modules inherit all parent dependencies. Certain dependencies are shared throughout the application lifecycle and live as singletons. All dependencies are defined as protocols to make mocking for testing easier.

All modules are built with a builder which takes in a dependency component. The builder constructs the router, viewModel, and view for a module.

The search chain and details chain are the main modules in the appliaction. The search chain contains a router, viewModel, and view that displays a collection view of search results. The details chain contains a router, viewModel, and view that displays details for a specific item in the search results.

The router is responsible for routing to new views. The router also maintains the life cycle of the router->viewModel->View chain. The entire parent route will hold a strong refrence to its children until the view is detached.

The viewModel is responsible for making requests to the network and requesting the view controller to present the data. The viewModel transforms data into a state that is consumable for the view.

The component which makes a call to the network using the OLX api is the OLXService which lives inside the service layer. I chose to use Alamofire to implement the network stack of the application. The service layer takes in a comppletion closure that is called once the netwok request has been completed.

The network stack is set up to cache all responses from the network. When the user has connectivity the application will use the caching rules specified by the protocol. When network connectivity is not present, the application will use a cached response if available.

The model layer is a series of structs that are concrete objects representing data returned by the API. I am using the Freddy JSON parser to safely parse the raw response data into objects. The parsing is off of the main thread to prevent blocking UI. The service layer calls the completion callback on the main thread once parse work is finished.

The layout is performed with SnapKit, which programatically creates all autolayout constraints. This allows the application to conform to any size screen or orientation (portrait-upside down intentionally disabled in build settings).

All Modules are tested using the XCTest framework. Mocks are available for most of the protocols used by the application.

Basic UI Automation testing using XCUITest is provided for the search and detail views.

## Optimizations
While scrolling images are not loaded to preserve scroll performance. Image loads are initiated once the user stops scrolling.

The details page does not make its own network request, the item details are already known by the search controller and the model is simply passed down to the new view.

All images are cached in the shared URLCache using AlamofireImage.

Network requests adhere to cache protocols defined by the cache headers in the response.

All JSON parsing is done off of the main thread to maintain high scroll performance.
