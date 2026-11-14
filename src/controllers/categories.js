// Import any needed model functions
import { getAllCategories, getCategoryDetails } from '../models/categories.js';
import { getProjectsByCategoryId } from '../models/projects.js';

// Define any controller functions
const showCategoriesPage = async (req, res) => {
    const categories = await getAllCategories();
    const title = 'Service Categories';

    res.render('categories', { title, categories });
};

const showCategoryDetailsPage = async (req, res, next) => {
    const categoryId = Number(req.params.id);

    if (!Number.isInteger(categoryId) || categoryId < 1) {
        const error = new Error('Category not found');
        error.status = 404;
        return next(error);
    }

    const category = await getCategoryDetails(categoryId);

    if (!category) {
        const error = new Error('Category not found');
        error.status = 404;
        return next(error);
    }

    const projects = await getProjectsByCategoryId(categoryId);
    const title = category.name;

    res.render('category', { title, category, projects });
};

// Export any controller functions
export { showCategoriesPage, showCategoryDetailsPage };