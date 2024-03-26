import { createRouter, createWebHistory } from 'vue-router';

import LoginPage from "./components/LoginPage.vue";
import HomeComponent from './components/HomeComponent.vue';
import Edit from './components/Edit.vue';

const routes = [
    {
        path: '/',
        redirect: { name: 'login' }
    },
    {
        path: '/login',
        name: 'login',
        component: LoginPage,
        // meta: { requiresAuth: false }
    },
    {
        path: '/home',
        name: 'HomePage',
        component: HomeComponent
    },
    {
        path: '/edit/:id',
        name: 'edit',
        component: Edit
    }
]




const router = createRouter({
    routes,
    history: createWebHistory(import.meta.env.BASE_URL)
    // history: 
})

export default router;