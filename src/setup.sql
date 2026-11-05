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

INSERT INTO service_projects
    (organization_id, title, description, location, project_date)
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