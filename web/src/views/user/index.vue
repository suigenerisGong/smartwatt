
<!-- USER -->
<!-- 温度湿度等传感器数值 -->

<template>
  <!-- <div id="main" style='height: 500px'>基础示例</div> -->
    <div id="group">
    <div id="panel" style="width: 50%;height:300px;" ref="main">
    </div>
    <div id="main1" style="width: 50%;height:300px;" ref="main">
    </div>
  </div>
  <div id="group">
    <div id="main2" style="width: 50%;height:300px;" ref="main">
    </div>
    <div id="main3" style="width: 50%;height:300px;" ref="main">
    </div>
    <!-- <div id="main4" style="width: 33%;height:240px;" ref="main">
    </div> -->
  </div>
</template>


<script>
  import { onMounted } from "vue";
  import * as echarts from "echarts";
     import * as mqtt from "mqtt/dist/mqtt.min";
     import{ref}from "vue";
     const client = mqtt.connect('ws://192.168.1.118:3881/mqtt');  
   export default{
    setup(){ 
        //用户的信息数据
        let windrotate=ref(0);
        let humidity=ref(0);
        let temperature=ref(0);
        let irradiance=ref(0);
        // let co2=ref(0); 
     //////////////////画图部分
      onMounted(() =>       
        {  
          // 官方示例 
          var myChart1 = echarts.init(document.getElementById('main1'));  
          var myChart2 = echarts.init(document.getElementById('main2'));  
          var myChart3 = echarts.init(document.getElementById('main3')); 
          // var myChart4 = echarts.init(document.getElementById('main4'));  
          
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
          const dataThree = (function () { // 10个0
            let res = [];
            let len = 10;
            while (len--) {
              res.push(0);
            }
            return res;
          })();
          // const dataFour = (function () { // 10个0
          //   let res = [];
          //   let len = 10;
          //   while (len--) {
          //     res.push(0);
          //   }
          //   return res;
          // })();
  
          //折线图样式与配置项，可以去查一下官方文档
          let option_main1 = {
            title: {
              text: 'Wind Rotate',
              subtext: 'P/KW',
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
                name: 'windrotate',
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
          let option_main2 = {
            title: {
              text: 'Temperature',
              subtext: '℃',
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
                data: dataTwo,
                type: 'line',
                smooth: true,//曲线平滑
                name: 'windrotate',
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
          let option_main3 = {
            title: {
              text: 'Irradiance',
              subtext: 'W/㎡',
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
                data: dataThree,
                type: 'line',
                smooth: true,//曲线平滑
                name: 'irradiance',
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
          // let option_main4 = {
          //   title: {
          //     text: 'Co2浓度',
          //     subtext: '浓度',
          //     textStyle: {
          //       color: 'black'
          //     }
          //   },
          //   tooltip: {
          //     trigger: 'axis',
          //     axisPointer: {
          //       type: 'cross',
          //       label: {
          //         backgroundColor: '#283b56'
          //       }
          //     }
          //   },
          //   legend: {},
          //   xAxis: {
          //     type: 'category',
          //     data: time, // 把时间组成的数组接过来，放在x轴上
          //     boundaryGap: true
          //   },
          //   yAxis: {
          //     type: 'value'
          //   },
          //   series: [
          //     {
          //       data: dataFour,
          //       type: 'line',
          //       smooth: true,//曲线平滑
          //       name: 'Co2浓度',
          //       markPoint: {
          //         data: [
          //           { type: 'max', name: '最大值' },
          //           { type: 'min', name: '最小值' }
          //         ]
          //       },
          //       markLine: {
          //         data: [{ type: 'average', name: '平均值' }]
          //       },
          //     },
          //   ]
          // }
          
          
          //仪表盘样式与配置     
          let option_panel = {
            title: {
              text: 'Humidity',
              textStyle: {
                color: 'black'
              }
            },
            tooltip: {
              formatter: '{a} <br/>{b} : {c}%'
            },
            series: [
              {
                name: 'Humidity',
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
                    value: 0,
                    name: 'HUMIDITY'
                  }
                ]
              }
            ]
          };
          //函数与数据部分？？？？？？？？？？？？？？？？？？？？？？？？
          setInterval(function () {
            let nowTime = new Date().toLocaleTimeString().replace(/^\D*/, '');
            time.push(nowTime)
            dataOne.push(windrotate.value)//在后面添加添加数组       
            dataTwo.push(temperature.value)
            dataThree.push(irradiance.value) 
            // dataFour.push(co2.value) 
  
          
  
            //折线图数据、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、
            myChart1.setOption({
              xAxis: [
                {
                  data: time
                }
              ],
              series: [
                {
                  data: dataOne
                },
                // {
                // data: dataTwo
                // },
              ]
            })
            myChart2.setOption({
              xAxis: [
                {
                  data: time
                }
              ],
              series: [
                {
                  data: dataTwo
                },
                // {
                // data: dataTwo
                // },
              ]
            })
            myChart3.setOption({
              xAxis: [
                {
                  data: time
                }
              ],
              series: [
                {
                  data: dataThree
                },
                // {
                // data: dataTwo
                // },
              ]
            })
            // myChart4.setOption({
            //   xAxis: [
            //     {
            //       data: time
            //     }
            //   ],
            //   series: [
            //     {
            //       data: dataFour
            //     },
            //     // {
            //     // data: dataTwo
            //     // },
            //   ]
            // })
           
            //仪表盘数据、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、、
            myPanel.setOption({
             series: [
               {
                 data: [
                   {
                     value: +(humidity.value)//表示消耗的电量
                   }
                 ]
               }
             ]
            });
  
        }, 2000)
         
         //导出
         myChart1.setOption(option_main1)
         myChart2.setOption(option_main2)
         myChart3.setOption(option_main3)
        //  myChart4.setOption(option_main4)
         myPanel.setOption(option_panel) 
        })
  //////////////////////MQTT////////////////////////////////////////////////////////////
   {   
      if (!client.connected) {
        console.log("客户端连接成功。。。。。。。");
      }
      client.on("connect", function () {
         client.subscribe('wattnode/data');//修改图表的数据
         client.subscribe('switchnode/data');//修改图表的数据
        console.log('"/wattnode/data" start... ');
        console.log('"/switchnode/data" start... ');
  
      });
  
      client.on("message", function (topic, message) {
        //电站电能信息
        if (topic == "wattnode/data") {    
          const res1=JSON.stringify(message.toString())
          const res = JSON.parse(res1);
          let station=res.split(';');   
          console.log("res1:", res1);
          console.log("res:", res);
          console.log("station:", station);
          windrotate.value = station[6];
          humidity.value=station[7];
          temperature.value=station[8];
          irradiance.value=station[9];
          console.log("wattnode/data/Windrotate:", windrotate.value);
          console.log("wattnode/data/humidity:", humidity.value);
          console.log("wattnode/data/temperature:", temperature.value);
          console.log("wattnode/data/irradiance:", irradiance.value);
        } 
        if (topic == "switchnode/data") {    
          const res1=JSON.stringify(message.toString())
          const res = JSON.parse(res1);
          let station=res.split(';');   
          console.log("res1:", res1);
          console.log("res:", res);
          console.log("station:", station);
          co2.value = station[5];

          console.log("wattnode/data/Windrotate:", co2.value);
          
        } 
       });
    
    
    }        
    return{
      windrotate,
      humidity,
      temperature,
      irradiance,

   }  
  } 
  } 
  </script>  





  
  <!-- <script>
  import * as echarts from "echarts";
  // import axios from "axios";
  export default {
    name: 'homePage',
    mounted() {
      this.test()
    },
    methods: {
      test() {
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

        const dataOne = (function () { // 10个随机数，大家可随意定义
          let res = [];
          let len = 10;
          while (len--) {
            res.push(Math.round(Math.random() * 1000));
          }
          return res;
        })();
        const dataTwo = (function () { // 10个随机数
          let res = [];
          let len = 10;
          while (len--) {
            res.push(Math.round(Math.random() * 1000));
          }
          return res;
        })();

        //折线图样式与配置项，可以去查一下官方文档
        let option_main = {
          title: {
            text: '动态',
            subtext: 'Fake Data',
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

              name: '测试一',
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
              name: '测试二',
              type: 'line',
              
              smooth: true,//曲线平滑

              markPoint: {
                data: [
                  { type: 'max', name: '最大值' },
                  { type: 'min', name: '最小值' }
                ]
              },
              markLine: {
                data: [{ type: 'average', name: '平均值' }]
              }
            }
          ]
        }
       
        //仪表盘样式与配置     
        let option_panel = {
          tooltip: {
            formatter: '{a} <br/>{b} : {c}%'
          },
          series: [
            {
              name: 'Pressure',
              type: 'gauge',
              progress: {
                show: true
              },
              detail: {
                valueAnimation: true,
                formatter: '{value}'
              },
              data: [
                {
                  value: 50,
                  name: 'SCORE'
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
          dataOne.push(Math.round(Math.random() * 1000))//在后面添加添加数组
          dataTwo.push(Math.round(Math.random() * 1000))

          //很多朋友可能要接后端接口,把数据替换下来既可以了
          // axios.get('你的url').then(res => {
          //   console.log(res)
          // })

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
                   value: +(Math.random() * 100).toFixed(2)
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
    }
  }
  </script> 

 -->




<!-- 基础示例 -->
<!-- 
<script>
  import * as echarts from 'echarts'
  import { onMounted } from 'vue'
  export default {
    setup() {
      onMounted(() => {
        // 获取DOM元素并且进行初始化
        var myChart = echarts.init(document.getElementById('main'));
        // 创建图标
        myChart.setOption({
          title: {
            text: 'ECharts 入门示例'
          },
          tooltip: {},
          xAxis: {
            data: ['衬衫', '羊毛衫', '雪纺衫', '裤子', '高跟鞋', '袜子']
          },
          yAxis: {},
          series: [
            {
              name: '销量',
              type: 'bar',
              data: [5, 20, 36, 10, 10, 20]
            }
          ]
        })
      })
    }
  }
  </script>
   -->
  <!-- <script>
  import * as mqtt from "mqtt/dist/mqtt.min";
  import{reactive, toRefs}from"vue";
  const client = mqtt.connect('ws://192.168.1.145:3881/mqtt');
  
  export default {
    setup(){
      const state =reactive({
        data:[0]
      })
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
            
            this.$store.commit('saveShouru', res);
            state.data = this.$store.state.shouru;
            console.log("test1:", state.data);
           
          }
  
         
        });
     }
     
      return{
          ...toRefs(state)
      }
    }
  }
  </script>
   -->
   <style scoped lang="scss">
    #group{
    display: flex;
}
  </style>