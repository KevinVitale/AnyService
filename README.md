# Define JSON clients with literal strings

The most easy-to-use JSON library ever. 

## Creating clients

Create your JSON clients with just a string to the base URL.

### JSON Placeholder
```swift
let service: AnyService = "https://jsonplaceholder.typicode.com"
```

### Guild Wars 2
```swift
let gw2: AnyService = "https://api.guildwars2.com/v2"
```

## Fetching results

The callback returns _a throwable block, that returns a tuple_. 
Simply invoke this throwable block, and then you can then inspect 
either the JSON object returned, the `URLRequest`, or handle any errors.

### Fetch Example

```swift
let task = try gw2.fetch(endpoint: "items", "30694") { request in
    do {
        print("\(try request().0)")
    } catch {
        print("\(error)")
    }
    PlaygroundPage.current.finishExecution()
}

task.resume()
```

## Project Scope

My motivation was to create the simplest, most lightweight 
JSON Swift client around. I limited the code to 80% of
what many developers need to fetch JSON. 

Swift's powerful typing system could easily allow for a more
featureful, robust framework in the future. For example, I'd
like to explore defining services as a function of their type.
This could lead to something that looks like:
 - `AnyService<RESTful>`
 - `AnyService<Socket>`
 - etc.


<hr/>

### License
Copyright **2017** — Kevin Vitale

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
