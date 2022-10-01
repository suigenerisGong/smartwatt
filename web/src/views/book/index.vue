
<!-- 登记信息的查询 -->
<!-- MQTT -->


<template>
  <h1>个人信息</h1>
  <h2>姓名：{{ name }}</h2>
  <h2>年龄：{{ age }}</h2>
  <h2>性别：{{ info.sex }}</h2>
  <h2>身高：{{ info.height }}m</h2>
  <h2>喜欢：{{ info.like }}</h2>
  <h2>其他爱好：{{ hobby }}</h2>
  <button @click="chaneUserInfo1">修改个人信息（one）</button>
  
</template>
 
<script>
import { ref, reactive } from "vue";
import * as mqtt from "mqtt/dist/mqtt.min";
const client = mqtt.connect('ws://106.14.44.95:3881/mqtt');
export default {
  name: "App",
  setup() {
    // ----------------------ref声明数据-----------------------------
    let name = ref("小明");
    let age = ref(18);
    let info = ref({
      sex: "男",
      height: 1.8,
      like: "游泳",
    });
    let hobby = ref(["打篮球", "打游戏", "健身"]);

    /* 
    针对于ref声明的数据如何进行修改 注意注意注意： .value  (在ref声明的数据里面，需要先通过.value才可以)
    */
    function chaneUserInfo1() {
      console.log(name);
      console.log(info);
      name.value = "小红";
      age.value = 16;
      info.value.sex = "女";
      info.value.height = 1.6;
      info.value.like = "跑步";
      hobby.value[1] = "听音乐";
    }
 
    {
    if (!client.connected) {
        console.log("客户端连接成功。。。。。。。");
      }
      client.on("connect", function () {
        client.subscribe('/test1');
        console.log('"/test1" start... ');
      });

      client.on("message", function (topic, message) {
        if (topic == "/test1") {
          const res = JSON.parse(message.toString());
        //   console.log(topic + ": ", res);
          age.value = res;
          console.log("test1:", age.value);
        }

       
      });
   }
    return {
      name,
      age,
      info,
      hobby,
     // person,
      chaneUserInfo1,
     // chaneUserInfo2,
    };
  },
};
</script>
 












































<!-- <template>
  {{data}}
 
</template>

<script>
import * as mqtt from "mqtt/dist/mqtt.min";
import{ref, toRefs}from"vue";
const client = mqtt.connect('ws://192.168.1.145:3881/mqtt');

export default {
  setup(){ 
     const data=ref(0)
   {
    if (!client.connected) {
        console.log("客户端连接成功。。。。。。。");
      }
      client.on("connect", function () {
        client.subscribe('/test1');
        console.log('"/test1" start... ');
      });

      client.on("message", function (topic, message) {
        if (topic == "/test1") {
          const res = JSON.parse(message.toString());
        //   console.log(topic + ": ", res);
          data = res;
          console.log("test1:", data);
        }

       
      });
   }
   
    return{
       data
    }
  }
}
</script>

<style scoped>

</style> -->
