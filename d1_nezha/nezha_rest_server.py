from flask import Flask, url_for, render_template, request, flash, \
                    redirect, make_response, jsonify, abort, g
from flask_mqtt import Mqtt
import my_logging as mylogger

logger = mylogger.init_logger(mylogger.DEBUG)

SERVER = {
    'HOST': '0.0.0.0',
    'PORT': 80
}

app = Flask(__name__)
app.config['MQTT_BROKER_URL'] = '192.168.1.118'
app.config['MQTT_BROKER_PORT'] = 1883
app.config['MQTT_USERNAME'] = ''
app.config['MQTT_PASSWORD'] = ''
app.config['MQTT_KEEPALIVE'] = 5
app.config['MQTT_TLS_ENABLED'] = False

mqtt = Mqtt(app)
app = Flask(__name__, static_folder='aligenie',static_url_path='/aligenie')

mqtt_recv = {}
mqtt_recv['current'] = '0'
mqtt_recv['power'] = '0'
mqtt_recv['energy'] = '0'

pub_topic = {
    'TOPIC': 'wattnode/data'
}
sub_topic = {
    'TOPIC': 'wattnode/cmd',
}

@mqtt.on_connect()
def handle_connect(client, userdata, flags, rc):
    mqtt.subscribe(sub_topic['TOPIC'])
    logger.info('connected to broker and subscribe a topic')

@mqtt.on_message()
def handle_mqtt_message(client, userdata, message):
    topic = message.topic
    payload = message.payload.decode()
    print(topic)
    print(payload)
    if topic == sub_topic['TOPIC']:
        logger.info('sensor value received: ')
        logger.info(str(payload))
        tmp = eval(payload)
        mqtt_recv['current'] = str(tmp[1])
        mqtt_recv['power'] = str(tmp[2])
        mqtt_recv['energy'] = str(tmp[3])
        print(mqtt_recv)

@app.route('/', methods=['GET'])
def index():
    return jsonify({'msg':'ok'})

@app.route('/', methods=['POST'])
def webhook_serve():
    _post = request
    value_post = _post.form["data"]
    mqtt_data = value_post
    mqtt.publish(pub_topic['TOPIC'], mqtt_data)
    print("here is the print:", value_post)
    return jsonify({})

@app.route('/node/<node_info>', methods=['GET'])
def update_node(node_info):
    tmp = node_info.split('_')
    if len(tmp) == 2:
        mqtt.unsubscribe(sub_topic['TOPIC'])
        pub_topic['TOPIC'] = '/d' + tmp[0] + '/n' + tmp[1]
        sub_topic['TOPIC'] = '/d' + tmp[0] + '/n' + tmp[1] + '/sensor'
        mqtt.subscribe(sub_topic['TOPIC'])
        return jsonify({'msg':node_info})
    else:
        return jsonify({'msg':'node info is error'})
if __name__ == '__main__':
    app.run(debug=True, host=SERVER['HOST'], port=SERVER['PORT'])
    logger.info('Server is running.')
