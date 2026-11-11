-- 1. Drop tables if they already exist (in reverse order, due to foreign key dependencies)
DROP TABLE IF EXISTS project_categories;
DROP TABLE IF EXISTS projects;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS organizations;

-- 2. Create the organizations table first
CREATE TABLE organization (
    organization_id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    description TEXT NOT NULL,
    contact_email VARCHAR(255) NOT NULL,
    logo_filename VARCHAR(255) NOT NULL
);

-- 3. Insert the base organizations (IDs 1, 2, and 3)
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

-- 4. Create the service_projects table
CREATE TABLE service_projects (
    project_id SERIAL PRIMARY KEY,
    organization_id INTEGER NOT NULL REFERENCES organization(organization_id),
    title VARCHAR(150) NOT NULL,
    description TEXT NOT NULL,
    location TEXT NOT NULL,
    date DATE NOT NULL
);

-- 5. Insert the base service projects (IDs 1 through 15)
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

-- 6. Create the categories table and the project_categories join table
CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

-- 7. Create the project_categories join table
CREATE TABLE project_categories (
    project_id INTEGER NOT NULL
        REFERENCES service_projects(project_id) ON DELETE CASCADE,
    category_id INTEGER NOT NULL
        REFERENCES categories(category_id) ON DELETE CASCADE,
    PRIMARY KEY (project_id, category_id)
);

-- 8. Insert the base categories
INSERT INTO categories (name)
VALUES
    ('Environmental'),
    ('Educational'),
    ('Community Service');

-- 9. Assign categories to projects based on their organization
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