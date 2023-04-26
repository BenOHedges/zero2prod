use actix_web::{web, Responder, HttpResponse};
use serde::Deserialize;

#[derive(serde::Deserialize)]
pub struct FormData{
    name: String,
    email: String,
}

pub async fn subscribe(_form: web::Form<FormData>) -> impl Responder{
    HttpResponse::Ok()
}