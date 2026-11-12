// Import any needed model functions
import { getAllProjects, getProjectsByOrganizationId, getUpcomingProjects, getProjectDetails } from '../models/projects.js';

// Define any controller functions
const NUMBER_OF_UPCOMING_PROJECTS = 5;

const showProjectsPage = async (req, res) => {
    const upcomingProjects = await getUpcomingProjects(NUMBER_OF_UPCOMING_PROJECTS);
    const title = 'Upcoming Service Projects';

    res.render('projects', { title, projects: upcomingProjects });
};

const showProjectDetailsPage = async (req, res) => {
    const projectId = req.params.projectId;  
    const projectDetails = await getProjectDetails(projectId);
    const title = 'Project Details';

    res.render('project', { title, project: projectDetails });
};  

// Export any controller functions
export { showProjectsPage, showProjectDetailsPage };