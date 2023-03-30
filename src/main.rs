use std::net::TcpListener;
use zero2prod::run;

#[tokio::main]
// #[actix_web::main]
async fn main() -> Result<(), std::io::Error>{
    let listener = TcpListener::bind("127.0.0.1:0").expect("Failed to bind random port");

    let _ = run(listener);
    Ok(())
}