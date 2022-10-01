
<!-- 后台-->

<template>
    <div class="app-wrapper">
      <el-container >
        <el-aside 
        width="200px"  
        height="100%"
        class="sidebar-containter"
        background-color="#2d3a4b" 
        ><Menu/></el-aside>
        <el-container>
          <el-header>
            <div class="navbar">
                <Breadcrumb/>
            </div>
          </el-header>
          <el-main>
            <router-view/>
          </el-main>
        </el-container>
      </el-container>
    </div>
</template>
  
<script setup>
import Menu from '@/views/layout/menu'
import Breadcrumb from '@/views/layout/header'
</script>

<style lang="scss" scoped>
.app-wrapper {
  position: relative;
  width: 100%;
  height: 100%;
}

.navbar {
  width: 100%;
  height: 60px;
  overflow: hidden;
  background-color: #fff;
  box-shadow: 0 1px 4px rgba(0, 21, 41, 0.08);
  padding: 0 16px;
  display: flex;
  align-items: center;
  box-sizing: border-box;
  position: relative;
}
:deep(.el-header){
  padding: 0px;
}

.sidebar-container {
  
  height: 100%;
}

::v-deep .el-container{
  height: 100%;
}

::v-deep ul.el-menu{
  border-right-width: 0px
}

</style>
