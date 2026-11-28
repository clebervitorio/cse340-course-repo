import express from 'express';
import { fileURLToPath } from 'url';
import path from 'path';
import { testConnection } from './src/models/db.js';
import router from './src/routes.js';
import session from 'express-session';
import flash from './src/middleware/flash.js';
import 'dotenv/config';

// Define the application environment
const nodeEnv = process.env.NODE_ENV?.toLowerCase() || 'production';

// Define the port number the server will listen on
const port = process.env.PORT || 3000;

const fileName = fileURLToPath(import.meta.url);
const directoryName = path.dirname(fileName);

const app = express();

const SESSION_SECRET = process.env.SESSION_SECRET;

/**
  * Configure Express middleware
  */

// Serve static files from the public directory

// Set up session management
app.use(session({
    secret: SESSION_SECRET,
    resave: false,
    saveUninitialized: true,
    rolling: true,
    cookie: {
        maxAge: 60 * 60 * 1000,
        httpOnly: true,
        secure: nodeEnv === 'production',
        sameSite: 'lax'
    }
}));

// Use flash message middleware
app.use(flash);

app.use(express.urlencoded({ extended: true }));
app.use(express.json());

app.use(express.static(path.join(directoryName, 'public')));

// Set EJS as the templating engine
app.set('view engine', 'ejs');

// Tell Express where to find your templates
app.set('views', path.join(directoryName, 'src/views'));

app.use((req, res, next) => {
  if (nodeEnv === 'development') {
    console.log(`${req.method} ${req.url}`);
  }
  next();
});

app.use((req, res, next) => {
    res.locals.isLoggedIn = false;
    res.locals.user = null;

    if (req.session && req.session.user) {
        res.locals.isLoggedIn = true;
        res.locals.user = req.session.user;
    }

    res.locals.NODE_ENV = nodeEnv;
    next();
});

// Use the imported router to handle routes
app.use(router);

// Catch-all route for 404 errors
app.use((req, res, next) => {
  const err = new Error('Page Not Found');
  err.status = 404;
  next(err);
});

// Global error handler
app.use((err, req, res, next) => {
  // Log error details for debugging
  console.error('Error occurred:', err.message);
  console.error('Stack trace:', err.stack);

  // Determine status and template
  const status = err.status || 500;
  const template = status === 404 ? '404' : '500';

  // Prepare data for the template
  const context = {
    title: status === 404 ? 'Page Not Found' : 'Server Error',
    error: err.message,
    stack: err.stack
  };

  // Render the appropriate error template
  res.status(status).render(`errors/${template}`, context);
});

app.listen(port, async () => {
  try {
    await testConnection();
    console.log(`Server is running at http://127.0.0.1:${port}`);
    console.log(`Environment: ${nodeEnv}`);
  } catch (error) {
    console.error('Error connecting to the database:', error);
    process.exit(1); // Exit the process with an error code
  }
});