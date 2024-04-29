use std::{
    io::{prelude::*, BufReader},
    net::{TcpListener, TcpStream},
    url::{Url, Host, Position},
};

fn main() {
    let listener = TcpListener::bind("127.0.0.1:80").unwrap();

    for stream in listener.incoming() {
        let stream = stream.unwrap();

        //println!("Connection established!");
        handle_connection(stream);
    }
}

fn handle_connection(mut stream: TcpStream) {
    let buf_reader = BufReader::new(&mut stream);
    let request_line = buf_reader.lines().next().unwrap().unwrap();

    let uurl="http://123.123.123.123/test?pp=22";
    let URLObject = new URL (urrl);
    let param = URLObject.searchParams.get("pp"); 

    //println!("{:#?}", request_line);
    //println!(" ");
    //println!("Request: {:#?}", http_request);
}


