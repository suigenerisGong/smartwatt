import { createStore } from 'vuex'
const store= createStore({
  state() {
    return {
      shouru:[1],
      zhichu:[2]
    }

  },
  getters: {
  },
  mutations: {
    saveShouru(state,shouru){
      state.shouru = shouru;
  },
  saveShouru(state,zhichu){
    state.zhichu = zhichu;
},
  },
  actions: {
  },
  modules: {
  }
})
export default store;
