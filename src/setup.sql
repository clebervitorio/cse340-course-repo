DROP TABLE IF EXISTS project_categories;
DROP TABLE IF EXISTS projects;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS organizations;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS roles;

CREATE TABLE organization (
    organization_id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    description TEXT NOT NULL,
    contact_email VARCHAR(255) NOT NULL,
    logo_filename VARCHAR(255) NOT NULL
);

CREATE TABLE service_projects (
    project_id SERIAL PRIMARY KEY,
    organization_id INTEGER NOT NULL REFERENCES organization(organization_id),
    title VARCHAR(150) NOT NULL,
    description TEXT NOT NULL,
    location TEXT NOT NULL,
    date DATE NOT NULL
);

CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE project_categories (
    project_id INTEGER NOT NULL
        REFERENCES service_projects(project_id) ON DELETE CASCADE,
    category_id INTEGER NOT NULL
        REFERENCES categories(category_id) ON DELETE CASCADE,
    PRIMARY KEY (project_id, category_id)
);

CREATE TABLE roles (
    role_id SERIAL PRIMARY KEY,
    role_name VARCHAR(50) UNIQUE NOT NULL,
    role_description TEXT
);

CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role_id INTEGER REFERENCES roles(role_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
); 

INSERT INTO organization
    (name, description, contact_email, logo_filename)
VALUES
    (
        'BrightFuture Builders',
        'Supports education through tutoring and community learning.',
        'info@brightfuture.org',
        'brightfuture-logo.png'
    ),
    (
        'GreenHarvest Growers',
        'Supports community gardens and environmental service.',
        'contact@greenharvest.org',
        'greenharvest-logo.png'
    ),
    (
        'UnityServe Volunteers',
        'Connects volunteers with opportunities to serve their neighbors.',
        'hello@unityserve.org',
        'unityserve-logo.png'
    );

INSERT INTO service_projects
    (organization_id, title, description, location, date)
VALUES
    -- Organization 1
    (1, 'Math Tutoring Night', 'Help middle school students practice fractions and algebra.', 'Riverside Library', '2027-04-05'),
    (1, 'Classroom Supply Drive', 'Sort donated notebooks and pencils into classroom kits.', 'Lincoln Elementary School', '2027-04-08'),
    (1, 'Resume Workshop', 'Help high school seniors write a resume for their first summer job.', 'Community Learning Center', '2027-04-10'),
    (1, 'Reading Buddies', 'Read picture books with children and help them sound out new words.', 'Westside Library', '2027-04-13'),
    (1, 'Science Fair Prep', 'Help students rehearse presentations and assemble their display boards.', 'Valley Middle School', '2027-04-16'),

    -- Organization 2
    (2, 'Community Garden Planting', 'Plant peas and lettuce in garden beds reserved for the food pantry.', 'Maple Community Garden', '2027-04-06'),
    (2, 'Riverbank Cleanup', 'Collect litter along the river and record the types of waste found.', 'Willow Creek Trail', '2027-04-09'),
    (2, 'Spring Tree Planting', 'Plant native saplings and add mulch around each tree.', 'Cedar Park', '2027-04-12'),
    (2, 'Seed Swap', 'Label donated seed packets and help neighbors choose seeds for their gardens.', 'Grange Hall', '2027-04-15'),
    (2, 'Compost Bin Build', 'Assemble wooden compost bins for gardeners to share.', 'Northside Garden', '2027-04-17'),

    -- Organization 3
    (3, 'Food Pantry Packing', 'Pack shelf-stable groceries into boxes for local families.', 'Valley Food Pantry', '2027-04-07'),
    (3, 'Senior Tech Help', 'Help older adults practice making video calls on their phones.', 'Sunrise Senior Center', '2027-04-10'),
    (3, 'Neighborhood Coat Closet', 'Sort donated jackets by size and restock the clothing racks.', 'Oak Street Community Center', '2027-04-14'),
    (3, 'Blood Drive Welcome Team', 'Greet donors and guide them to the check-in desk.', 'Eastside Community Hall', '2027-04-16'),
    (3, 'Community Dinner', 'Set tables, serve meals, and clean up after a neighborhood dinner.', 'Main Street Fellowship Hall', '2027-04-18');

INSERT INTO categories (name)
VALUES
    ('Environmental'),
    ('Educational'),
    ('Community Service');

INSERT INTO project_categories (project_id, category_id)
SELECT p.project_id, c.category_id
FROM service_projects AS p
JOIN categories AS c
    ON c.name = CASE
        WHEN p.organization_id = 1 THEN 'Educational'
        WHEN p.organization_id = 2 THEN 'Environmental'
        ELSE 'Community Service'
    END
ON CONFLICT (project_id, category_id) DO NOTHING;

-- Roles must exist before users can reference them.
INSERT INTO roles (role_name, role_description)
VALUES
    ('user', 'Standard user with basic access'),
    ('admin', 'Administrator with full system access');

CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role_id INTEGER REFERENCES roles(role_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Optional verification: run this block manually in pgAdmin.
-- ROLLBACK removes the test record without changing existing users.
/*
BEGIN;

INSERT INTO users (name, email, password_hash, role_id)
SELECT 'testuser', 'test@example.com', 'placeholder_hash', role_id
FROM roles
WHERE role_name = 'user';

SELECT u.user_id, u.name, u.email, r.role_name, r.role_description
FROM users AS u
JOIN roles AS r ON u.role_id = r.role_id
WHERE u.email = 'test@example.com';

DELETE FROM users WHERE email = 'test@example.com';

ROLLBACK;
*/

INSERT INTO roles (role_name, role_description) VALUES 
    ('user', 'Standard user with basic access'),
    ('admin', 'Administrator with full system access');

INSERT INTO users (name, email, password_hash, role_id) VALUES
    ('Star Trek Fan', 'startrekfan@gmail.com', 'Abcd1234!', 1),
    ('Star Wars Fan', 'starwarsfan@gmail.com', 'Abcd1234#', 2);