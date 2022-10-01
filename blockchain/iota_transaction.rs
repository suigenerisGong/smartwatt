use iota_client::{Client, Result, Seed};
extern crate dotenv;
use dotenv::dotenv;
use std::any::type_name;
use std::collections::HashSet;
use std::{
    env,
    process,
    time::Duration,
    thread,
};

extern crate paho_mqtt as mqtt;
const DFLT_BROKER:&str = "tcp://106.14.44.95:1883";
const DFLT_CLIENT:&str = "iota_client";
const PUB_TOPICS:&[&str] = &["station/balance", "robot/balance"];
const SUB_TOPICS:&[&str] = &["check/balance"];

// Define the qos.
const QOS:i32 = 1;
const DFLT_QOS:&[i32] = &[0, 1];

// Reconnect to the broker when connection is lost.
fn try_reconnect(cli: &mqtt::Client) -> bool
{
    println!("Connection lost. Waiting to retry connection");
    for _ in 0..12 {
        thread::sleep(Duration::from_millis(5000));
        if cli.reconnect().is_ok() {
            println!("Successfully reconnected");
            return true;
        }
    }
    println!("Unable to reconnect after several attempts.");
    false
}

// Subscribes to multiple topics.
fn subscribe_topics(cli: &mqtt::Client) {
    if let Err(e) = cli.subscribe_many(SUB_TOPICS, DFLT_QOS) {
        println!("Error subscribes topics: {:?}", e);
        process::exit(1);
    }
}

fn print_type_of<T>(_: &T) {
    println!("{}", std::any::type_name::<T>())
}

#[tokio::main]
async fn main() -> Result<()> {
    let mut transaction_flag = "false";
    let mut balance_flag = "false";
    let host = env::args().nth(1).unwrap_or_else(||
        DFLT_BROKER.to_string()
    );

    // Define the set of options for the create.
    // Use an ID for a persistent session.
    let create_opts = mqtt::CreateOptionsBuilder::new()
        .server_uri(host)
        .client_id(DFLT_CLIENT.to_string())
        .finalize();

    // Create a client.
    let cli = mqtt::Client::new(create_opts).unwrap_or_else(|err| {
        println!("Error creating the client: {:?}", err);
        process::exit(1);
    });

    // Initialize the consumer before connecting.
    let rx = cli.start_consuming();

    // Define the set of options for the connection.
    let lwt = mqtt::MessageBuilder::new()
        .topic("test")
        .payload("Consumer lost connection")
        .finalize();

    // Define the set of options for the connection.
    let conn_opts = mqtt::ConnectOptionsBuilder::new()
        .keep_alive_interval(Duration::from_secs(20))
        .clean_session(true)
        .finalize();

    // Connect and wait for it to complete or fail.
    if let Err(e) = cli.connect(conn_opts) {
        println!("Unable to connect:\n\t{:?}", e);
        process::exit(1);
    }
    let iota = Client::builder()
        .with_node("http://156.247.9.220:14265") 
        .unwrap()
        .with_node_sync_disabled()
        .finish()
        .await
        .unwrap();
        
    // This example uses dotenv, which is not safe for use in production
    // Configure your own seed in ".env". Since the output amount cannot be zero, the seed must contain non-zero balance
        dotenv().ok();
        let seed_1 = Seed::from_bytes(&hex::decode(env::var("NONSECURE_USE_OF_DEVELOPMENT_SEED_1").unwrap())?);
        let seed_2 = Seed::from_bytes(&hex::decode(env::var("NONSECURE_USE_OF_DEVELOPMENT_SEED_2").unwrap())?);
    subscribe_topics(&cli);
    println!("Processing requests...");
    for msg in rx.iter() {
        if let Some(msg) = msg {
            print_type_of(&(msg.to_string()));
            let tmp_msg = msg.to_string();
            let tokens:Vec<&str>= (tmp_msg).split(" ").collect();
            println!("msg is {}",tokens[1]);      
            if tokens[1] == "balance"{
                balance_flag = "true";
                println!("balance_flag");
            }
            if tokens[1] == "transaction" {
                transaction_flag = "true";
                println!("transaction_flag");
            }
            if balance_flag == "true" {
                let seed_balance_1 = iota.get_balance(&seed_1).finish().await.unwrap();
                let seed_balance_2 = iota.get_balance(&seed_2).finish().await.unwrap();
                println!("Account balance of seed_1: {:?}i\n", seed_balance_1);
                println!("Account balance of seed_2: {:?}i\n", seed_balance_2);
                for num in 0..2 {
                    //let content =  "Hello world! ".to_string() + &num.to_string();
                    let content_1 =  seed_balance_1.to_string() + &num.to_string();
                    let content_2 =  seed_balance_2.to_string() + &num.to_string();
                    let mut msg = mqtt::Message::new(PUB_TOPICS[0], content_1.clone(), QOS);
                    //let mut msg_2 = mqtt::Message::new(PUB_TOPICS[1], content_2.clone(), QOS);
                    if num % 2 == 0 {
                        println!("Publishing messages on the {:?} topic", PUB_TOPICS[0]);
                        msg = mqtt::Message::new(PUB_TOPICS[0], content_1.clone(), QOS);
                    } else {
                        println!("Publishing messages on the {:?} topic", PUB_TOPICS[1]);
                        msg = mqtt::Message::new(PUB_TOPICS[1], content_2.clone(), QOS);
                    }
                    let tok = cli.publish(msg);
            
                            if let Err(e) = tok {
                                    println!("Error sending message: {:?}", e);
                                    break;
                            }
                }
                balance_flag = "false";
            }
            if transaction_flag == "true" {

                let message = iota
                    .message()
                    .with_seed(&seed_2)
                    // Insert the output address and amount to spent. The amount cannot be zero.
                    .with_output(
                        // We generate an address from our seed so that we send the funds to ourselves
                        &iota.get_addresses(&seed_1).finish().await?[0],//.with_range(1..2).finish().await?[0],
                        1_000_000,
                    )?
                    .finish()
                    .await?;
                println!(
                    "Transaction sent: https://explorer.iota.org/devnet/message/{}",
                    message.id().0
                );
                transaction_flag = "false";
            }
        }
        else if !cli.is_connected() {
            if try_reconnect(&cli) {
                println!("Resubscribe topics...");
                subscribe_topics(&cli);
            } else {
                break;
            }
        }
    }
    Ok(())
}
