// import axios from 'axios';
// Vue.prototype.$axios = axios;

import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import store from './store'
import ElementPlus from 'element-plus'
import 'element-plus/dist/index.css'
import '././assets/styles/border.css'
import '././assets/styles/reset.css'
createApp(App).use(ElementPlus).use(store).use(router).mount('#app')
