import { createRouter, createWebHashHistory } from 'vue-router'
const routes = [
  // {
  //   path: '/login',
  //   name: 'login',
  //   // route level code-splitting
  //   // this generates a separate chunk (about.[hash].js) for this route
  //   // which is lazy-loaded when the route is visited.
  //   component: () => import(/* webpackChunkName: "about" */ '../views/login')
  // },
  // {
  {
    path: '/',
    name: '首页',
    component: () => import( '../views/layout'),
    redirect:'/other',
    children:[
      {
        path: '/home',
        name: '首页',
        component: () => import( '../views/home')
      },
      {
        path: '/book',
        name: '用户订单',
        component: () => import( '../views/book')
      },
      
      {
         path: '/other',
        name: 'trading',
        component: () => import( '../views/other')
      },
      {
        path: '/user',
        name: 'data',
        component: () => import( '../views/user')
      },   
    ]
  } 
]

const router = createRouter({
  history: createWebHashHistory(),
  routes
})

export default router
