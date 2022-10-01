
<!-- 区块链网页 -->

<template>
 
  <el-row :gutter="12">
    <el-col :span="7">
      <el-card shadow="always"> 
        <div class="box0">交易区</div>
      
        <div height="450px">
           我的余额:{{mybalance}}
           <br>
        </div>
        <el-divider />
        <div height="450px">
          <div style="margin-bottom:10px;">
          用户余额:{{usersbalance}}
        </div>
          <br>
          <div style="margin-bottom:10px;">
          用户消耗电量:{{watt.toFixed(2)}}
        </div>
          <br>
          用户的seed: {{seed}}
        </div>
       
      </el-card >
      <el-card shadow="always" style=" margin-top: 20px;">
        <el-button type="primary" plain  @click="start">开始交易</el-button>
        <el-button type="danger" plain @click="stop">停止交易</el-button>

      </el-card>

    </el-col>
    <el-col :span="17">
      <el-card shadow="always" index="user">  
        <div id="group">
          <div id="panel" style="width: 35%;height:280px;" ref="main">
          </div>
          <div id="main" style="width: 65%;height:300px;" ref="main">风能，太阳能发电电量，电站剩余电量
          </div>
        </div>

      </el-card>
   
    </el-col>

  </el-row>
  <el-col :span="24">
    <el-card shadow="always"> 
      <div>
        <!-- 历史区
        balance，transaction，用电量，用户seed，address，交易时间(始末) -->
        <el-table :data="tableData" height="200" style="width: 100%">
          <el-table-column  label="Date" width="180" >{{date}}</el-table-column>
          <el-table-column prop="name" label="Name" width="180" >Tom</el-table-column>
          <el-table-column label="Seed" width="180">{{seed}}</el-table-column>
          <el-table-column label="Balance" width="180" >{{usersbalance}}</el-table-column>
          <el-table-column label="Trading volume" width="180" >{{trading}}</el-table-column>
          
        </el-table>
      </div>
    </el-card>
  </el-col>

</template>

<script>
import { onMounted } from "vue";
import * as echarts from "echarts";
   import * as mqtt from "mqtt/dist/mqtt.min";
   import{ref,reactive}from "vue";
   const client = mqtt.connect('ws://192.168.1.118:3881/mqtt');
   
 export default{
  setup(){
     // 用户的信息数据
      let tableData =ref([
    {
      date: '',
      name: 'Tom',
      seed: '256a818b2aac458941f7274985a410e57fb750f3a3a67969ece5bd9ae7eef5b3',
      balance:'',
      trading:''
    }]);
      let mybalance=ref(0);
      let usersbalance=ref(0);
      let chargeRequest=ref(0);
      let SunRealtime=ref(0);//存放读进来的数据//判断电源是否被接入 接口为request
      let WindRealtime=ref(0);

      let Toswitch=ref(0);//告诉开关是否要打开
      let watt=ref(0);//开关消耗的能量，结算用
      let watt1=ref(0);//开关消耗的能量,计数用
      let watttime=ref(0);
      let P=ref(0);
      let trading=ref(10);
      let flag=ref(0);
      let date=ref('-')
      let seed=ref('256a818b2aac458941f7274985a410e57fb750f3a3a67969ece5bd9ae7eef5b3')

     
    //发送指令到智能开关,接口为charge     
    //////////////////画图部分
    onMounted(() => {
      
      {  
        // 官方示例 
        var myChart = echarts.init(document.getElementById('main'));  
        var myPanel = echarts.init(document.getElementById('panel'));  
        // const myChart = echarts.init(this.$refs.main); // 我们可以这样写 
        const time = (function () { // 立即执行函数
          let now = new Date();  // 获得当前的时间
          

          let res = []; // 存放时间的数组
          let len = 10; // 要存几个时间？
          while (len--) {
            res.unshift(now.toLocaleTimeString().replace(/^\D*/, '')); // 转换时间，大家可以打印出来看一下
            now = new Date(+now - 6000) // 延迟几秒存储一次？
          }
          return res;
        })();      
        const dataOne = (function () { // 10个0
          let res = [];
          let len = 10;
          while (len--) {
            res.push(0);
          }
          return res;
        })();
        const dataTwo = (function () { // 10个0
          let res = [];
          let len = 10;
          while (len--) {
            res.push(0);
          }
          return res;
        })();
       
        //折线图样式与配置项，可以去查一下官方文档
        let option_main = {
          title: {
            text: '电站功率',
            subtext: 'P/W',
            textStyle: {
              color: 'black'
            }
          },
          tooltip: {
            trigger: 'axis',
            axisPointer: {
              type: 'cross',
              label: {
                backgroundColor: '#283b56'
              }
            }
          },
          legend: {},
          xAxis: {
            type: 'category',
            data: time, // 把时间组成的数组接过来，放在x轴上
            boundaryGap: true
          },
          yAxis: {
            type: 'value'
          },
          series: [
            {
              data: dataOne,
              type: 'line',
              smooth: true,//曲线平滑
              name: '太阳能',
              markPoint: {
                data: [
                  { type: 'max', name: '最大值' },
                  { type: 'min', name: '最小值' }
                ]
              },
              markLine: {
                data: [{ type: 'average', name: '平均值' }]
              },
            },
            {
              data: dataTwo,
              type: 'line',
              smooth: true,//曲线平滑
              name: '风能',
              markPoint: {
                data: [
                  { type: 'max', name: '最大值' },
                  { type: 'min', name: '最小值' }
                ]
              },
              markLine: {
                data: [{ type: 'average', name: '平均值' }]
              },
            },

          ]
        }
       
        //仪表盘样式与配置     
        let option_panel = {
          title: {
            text: '消耗电量',
            // subtext: 'P/KW',
            textStyle: {
              color: 'black'
            }
          },
          tooltip: {
            formatter: '{a} <br/>{b} : {c}%'
          },
          series: [
            {
              name: 'watt',
              type: 'gauge',
              progress: {
                show: true
              },
              detail: {
                valueAnimation: true,
                formatter: '{value}',
                fontSize:14
              },
              data: [
                {
                  value: 50,
                  name: 'WATT'
                }
              ]
            }
          ]
        };
        //函数与数据部分？？？？？？？？？？？？？？？？？？？？？？？？
        setInterval(function () {
          let nowTime = new Date().toLocaleTimeString().replace(/^\D*/, '');
          //time.shift()
          time.push(nowTime)
          dataOne.push(SunRealtime.value.toFixed(2))//在后面添加添加数组
          dataTwo.push(WindRealtime.value.toFixed(2))

        

          //折线图数据、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、
          myChart.setOption({
            xAxis: [
              {
                data: time
              }
            ],
            series: [
              {
                data: dataOne
              },
              {
              data: dataTwo
              },
            ]

          })

          //仪表盘数据、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、
          myPanel.setOption({
           series: [
             {
               data: [
                 {
                   value: +(watt.value).toFixed(2)//表示消耗的电量
                 }
               ]
             }
           ]
          });

      }, 2000)
       
       //导出
       myChart.setOption(option_main)
       myPanel.setOption(option_panel) 
 }
})
//////////////////////MQTT////////////////////////////////////////////////////////////
 { 
  
    if (!client.connected) {
      console.log("客户端连接成功。。。。。。。");
    }
    client.on("connect", function () {
       client.subscribe('wattnode/data');//修改图表的数据      //电站能量信息wattnode/data eg:12;12
                                                      //开关剩余电量switchnode/data
      client.subscribe('charge/request');//请求充电的指令    charge/request ,我发送用的是check/balance
      client.subscribe('switchnode/cmd');//开启智能开关放电   switchnode/cmd
      client.subscribe('switchnode/data');//开启智能开关放电
      client.subscribe('station/balance');//我的余额,       与用户余额一起返回station/balance
      client.subscribe('robot/balance');//用户的余额      robot/balance
         //保存一笔交易记录
      console.log('"/wattnode/data" start... ');
      console.log('"charge/request" start... ');
    });
    
    client.on("message", function (topic, message) {
      console.time("循环MQTT的时间") 
       setInterval(ge,15000);//每隔15s请求一次数据
      console.timeEnd("循环MQTT的时间")
      //电站电能信息
      if (topic == "wattnode/data") {    
        const res1=JSON.stringify(message.toString())
        const res = JSON.parse(res1);
        let enengy=res.split(';');
        // console.log("enengy:", enengy);
        // console.log("res1:", res1);
        // console.log("res:", res);
        SunRealtime.value = enengy[1]*enengy[2];
        WindRealtime.value=enengy[3]*enengy[4];
        console.log("wattnode/data/sun:", SunRealtime.value);
        console.log("wattnode/data/wind:", WindRealtime.value);
      } 

      //判断电源是否被接入 ,电站发送充电request,网页向网页向服务器请求station 与robot的balance，服务器返回二者balance— 
      if (topic == "charge/request") {
        let res = message.toString();
        if(res=='open'){
          chargeRequest.value=1    
         client.publish('check/balance','balance')
         console.log("询问用户余额中");
        }else if(res=='close'){
          chargeRequest.value=0   
          watt.value=watt1.value;
          console.log("交易结束,watt",watt.value);
          //clearInterval(i)//停止
        trading.value=flag.value-usersbalance.value
        usersbalance=0
        }
      }
      if (topic == "station/balance") {
        let res = JSON.parse(message.toString());
        mybalance.value = res;
        console.log("mybalance:", mybalance.value);
      }
      if (topic == "robot/balance") {
        let res = JSON.parse(message.toString());
        usersbalance.value = res;   
        console.log("usersbalance:", usersbalance.value);
        
        if(chargeRequest.value==1 && usersbalance.value>10){
        client.publish('switchnode/cmd','1')
        client.publish('check/balance','transaction')       
        Toswitch.value=1
        date.value=new Date();
        console.log("智能开关开启",Toswitch.value);
        if(flag.value==0){//取出第一个用户余额数据
          flag.value=usersbalance.value
        }
       
      }else {
        client.publish('switchnode/cmd','0')
        Toswitch.value=0
      }
      } 
      //----若用户余额充足，则发送指令到智能开关   
     // console.time("循环MQTT的时间") 
      if(Toswitch.value==1 && topic == "switchnode/data"){
        console.log("watttime",watttime.value)
        watttime.value=0
        console.log("智能开关开启");
        const res1=JSON.stringify(message.toString())
        const res = JSON.parse(res1);
        let enengy=res.split(';');

        P.value = enengy[2];

        console.log("switchnode/data/P:", P.value)
        watt.value+=P.value*1      
        console.log("watt1",watt.value)  
      }
      if(Toswitch.value==0){
        clearInterval(setInterval(bian,2000))//停止
      }

    });
    function bian(){
      watt1.value+=P*5//开关消耗的电量 
      console.log("watt1",watt1.value)
    }
    function ge(){
      client.publish('request','request')
      console.log("request")
    }
    
  }        
  /////////////////////////////////////////////////////////////
  function start(){
      client.publish('switchnode/cmd','1')
        client.publish('check/balance','transaction') 
        //client.publish('check/balance','balance')      
        Toswitch.value=1
        date.value=new Date();
        if(flag.value==0){//取出第一个用户余额数据
          flag.value=usersbalance.value
        }
        console.log("智能开关开启",Toswitch.value);
    }

    function stop(){
      client.publish('switchnode/cmd','0')
      Toswitch.value=0
      chargeRequest.value=0   
         // watt.value=watt1.value;
          console.log("交易结束,watt",watt.value);
          
        trading.value=flag.value-usersbalance.value
        usersbalance=0
    }
  return{
  tableData, 
  mybalance,
  usersbalance,
  chargeRequest,
  SunRealtime,
  WindRealtime,
  seed,
  trading,
  date,
  watt,
  start,
  stop
 }
 
}

}
 
</script>







<style lang="scss">
  .el-row {
  margin-bottom: 20px;
}  
.box0{
  border-bottom:1px solid rgb(133, 152, 151);
  margin-bottom: 20px;

} 
#group{
    display: flex;
}
    </style>