// Import any needed model functions
import { getUpcomingProjects, getProjectDetails } from '../models/projects.js';
import { getCategoriesByProjectId } from '../models/categories.js';

// Define any controller functions
const NUMBER_OF_UPCOMING_PROJECTS = 5;

const showProjectsPage = async (req, res) => {
    const upcomingProjects = await getUpcomingProjects(NUMBER_OF_UPCOMING_PROJECTS);
    const title = 'Upcoming Service Projects';

    res.render('projects', { title, projects: upcomingProjects });
};

const showProjectDetailsPage = async (req, res, next) => {
    const projectId = Number(req.params.projectId);

    if (!Number.isInteger(projectId) || projectId < 1) {
        const error = new Error('Project not found');
        error.status = 404;
        return next(error);
    }

    const projectDetails = await getProjectDetails(projectId);

    if (!projectDetails) {
        const error = new Error('Project not found');
        error.status = 404;
        return next(error);
    }

    const categories = await getCategoriesByProjectId(projectId);
    const title = projectDetails.title;

    res.render('project', {
        title,
        project: projectDetails,
        categories
    });
};

// Export any controller functions
export { showProjectsPage, showProjectDetailsPage };