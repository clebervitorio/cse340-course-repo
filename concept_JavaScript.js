// Key Technical Changes in JavaScript's Evolution
//Variable Declarations (ES6 - 2015)
//Originally, JavaScript only had var to declare variables. This worked, but it had serious problems that caused bugs and confusion in larger programs.

//The first problem with var is hoisting. You can reference a variable before you declare it, and instead of getting an error, JavaScript returns undefined:
    console.log(myVariable); // undefined (should be an error!)
    var myVariable = "Hello World";

// The second and bigger problem is scope. Scope determines where in your code a variable can be accessed. Variables declared with var are function-scoped, meaning they're accessible anywhere within the entire function, even outside blocks like if statements:
function example() {
    if (true) {
        var leaksOut = "I escape the block";
    }
    console.log(leaksOut); // "I escape the block" - accessible here!
}

// This scope behavior often caused unexpected bugs because variables would be accessible in places where you didn't intend them to be. ES6 (2015) introduced let and const to fix these problems by providing block scope instead of function scope.

// Modern JavaScript uses let and const:
let y = 20;   // Block-scoped, can be changed
const z = 30; // Block-scoped, cannot be changed

// With block scope, variables stay inside their blocks (the curly braces where they're declared):
function example() {
    if (true) {
        let staysInside = "I'm contained";
        const alsoStaysInside = "Me too";
    }
    console.log(staysInside); // ReferenceError - not accessible here
}

// Use const when the value won't change, and let when it will:
const pi = 3.14159;  // This means `pi` never changes
let counter = 0;     // This allows `counter` to be updated
counter = 1;         // `counter` updated to 1
pi = 3.14;           // TypeError: Assignment to constant variable `pi`

// Arrow Functions and this Behavior (ES6 - 2015)
// Originally, JavaScript only had traditional function declarations and expressions. These worked fine for basic tasks, but they had a confusing problem with the this keyword that caused many bugs.

// Here's how functions used to be written:

// Traditional function declaration
function greet(name) {
    return "Hello, " + name;
}

// Traditional function expression
const greet = function(name) {
    return "Hello, " + name;
};

// The problem with traditional functions is that this changes depending on how the function is called, not where it's defined. This often caused unexpected behavior:
const person = {
    name: "Alice",
    greet: function() {
        console.log("Hello, I'm " + this.name);
    },
    delayedGreet: function() {
        setTimeout(function() {
            console.log("Hello, I'm " + this.name); // this.name is undefined!
        }, 1000);
    }
};

person.greet();        // "Hello, I'm Alice" ✓
person.delayedGreet(); // "Hello, I'm undefined" ✗

// The callback function inside setTimeout loses the original this value, causing bugs. ES6 introduced arrow functions to solve this problem by inheriting this from their surrounding context:
const person = {
    name: "Alice",
    greet: function() {
        console.log("Hello, I'm " + this.name);
    },
    delayedGreet: function() {
        setTimeout(() => {
            console.log("Hello, I'm " + this.name); // this.name works correctly!
        }, 1000);
    }
};

person.greet();        // "Hello, I'm Alice" ✓
person.delayedGreet(); // "Hello, I'm Alice" ✓

// Arrow functions also provide cleaner syntax for simple functions:

// Traditional function
const greet = function(name) {
    return "Hello, " + name;
};

// Arrow function - shorter and cleaner
const greet = (name) => "Hello, " + name;

//String Template Literals (ES6 - 2015)

// Originally, JavaScript built strings by combining pieces together using string concatenation. Concatenation means joining multiple strings into one by using the plus (+) operator.

// Here's how strings used to be built:
const name = "JavaScript";
const version = 6;
const message = "Hello, " + name + "! ES" + version + " is great.";

// This concatenation approach became messy and error-prone with longer strings. It was easy to forget spaces, mix up quotes, or make syntax errors:
const user = "Alice";
const score = 95;
const time = "2:30";

// This gets hard to read and maintain:
const result = "Congratulations " + user + "! You scored " + score + "% in " + time + " minutes.";

// ES6 introduced template literals to make string building cleaner and easier. Instead of regular quotes, you use backticks (`) and insert variables directly with ${}:
const user = "Alice";
const score = 95;
const time = "2:30";

// Much cleaner and easier to read:
const result = `Congratulations ${user}! You scored ${score}% in ${time} minutes.`;

// Template literals also support multi-line strings without needing special characters:

// Old way required \n for new lines
const oldMessage = "Line 1\nLine 2\nLine 3";

// Template literals preserve line breaks naturally
const newMessage = `Line 1
Line 2
Line 3`;

// Handling Asynchronous Code
// JavaScript evolved from using callbacks to Promises and eventually Async/Await for handling asynchronous tasks like fetching data from a server.

// Callbacks (Pre-ES6)
// Using callbacks often led to deeply nested code, commonly referred to as callback hell, making it difficult to read and maintain.
fetchData((data) => {
    processData(data, (result) => {
        displayResult(result);
    });
});

// Promises (ES6 - 2015)
// Promises were introduced to address callback hell by providing a cleaner, more readable way to handle asynchronous operations.
fetchData()
    .then(processData)
    .then(displayResult)
    .catch(handleError);

// Async/Await (ES8 - 2017)
// Async/Await further simplified asynchronous code, making it look and behave more like synchronous code, thus improving readability and maintainability.
async function fetchAndProcess() {
    try {
        const data = await fetchData();
        const result = await processData(data);
        displayResult(result);
    } catch (error) {
        handleError(error);
    }
}

// Modules for Cleaner Code Organization (ES6 - 2015)
// Modules allow developers to organize code into separate files, making it easier to manage, reuse, and scale projects. Instead of writing all functionality in one large file, developers can split code into smaller, self-contained pieces, each handling a specific task.

// With modules, a file can export functions, objects, or variables using the export keyword. Other parts of the application can then import only what they need using the import keyword. This modular approach improves readability, maintainability, and reusability, making it easier for teams to collaborate and for projects to grow without becoming messy or difficult to manage.
// math.js - Module exporting multiple functions
export const add = (a, b) => a + b;
export const subtract = (a, b) => a - b;
export const multiply = (a, b) => a * b;
export const divide = (a, b) => b !== 0 ? a / b : 'Cannot divide by zero';

// app.js - Importing specific functions from math.js
import { add, subtract, multiply, divide } from './math.js';

console.log("Addition:", add(2, 3));            // Output: 5
console.log("Subtraction:", subtract(5, 2));    // Output: 3
console.log("Multiplication:", multiply(3, 4)); // Output: 12
console.log("Division:", divide(10, 2));        // Output: 5
console.log("Division by zero:", divide(5, 0)); // Output: Cannot divide by zero