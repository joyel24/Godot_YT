use std::{
    fs,
    io::{prelude::*, BufReader},
    net::{TcpListener, TcpStream},
    process,
};
use url::{Url, Host, Position};

// struct vars {
//     var1: i32,
//     var2: i32
// }

pub fn main() {
    let mut var1=0;
    let mut var2=0;
    let mut started=200;

    while true {
    let listener = TcpListener::bind("127.0.0.1:8080").unwrap();
        for stream in listener.incoming() {
            let stream = stream.unwrap();

            //println!("Connection established!");
            let var_increment = handle_connection(stream, var1, var2, started);
            //var1+=var_increment.0;
            //var2+=var_increment.1;

            println!("{var_increment}");
             if var_increment == 1 {
                var1+=1;
            }
            else if var_increment == 2 {
                var2+=1;
            }
            else if var_increment == 999 {
                var1=0;
                var2=0;
                started=200;
                println!("reset");
            }
            else if var_increment == 998 {
                started=299;
                println!("start");
            }
            else if var_increment == 997 {
                //started=299;
            }

            //return 0
        }
    }
}

pub fn handle_connection(mut stream: TcpStream, mut var1: i32, mut var2: i32, mut started: i32) -> i32 { //, mut var1: i16, mut var2: i16) {
    let buf_reader = BufReader::new(&mut stream);
    
    let request_line = buf_reader.lines().next().unwrap().unwrap();

    let urll = request_line;
    //let urll = urll.replace("GET ", "http://127.0.0.1");
    //let urll = urll.replace(" HTTP/1.1", "");


    //let a = urll;
    let mut b = &urll[0..urll.find("&scope=").unwrap_or(urll.len())];

    //let b = b.replace("%2F", "/");
    //let b = b.replace("GET /?state=state_parameter_passthrough_value&code=", "");
    //println!("{:#?}", b);

    println!("{:#?}", b);

    if b == "GET /index.html?&!1 HTTP/1.1" {
        var1+=1;
        let status_line = "HTTP/1.1 200 OK";//"HTTP/1.1 200 OK\r\n\r\n";
        let meta_refresh = ""; //"<meta http-equiv='refresh' content='1'>";
        //let html_response =format!("<!DOCTYPE html>{meta_refresh} <h1><center><body style='color:powderblue;font-size:500%'> Votes<br> !1: {var1} || !2: {var2}  </center></h1>");
        let html_response =format!("<!DOCTYPE html>{var1}:{var2}");

        //let html_response = "<h1> !1={gg} || !2=$2 </h1>";
        //let content = fs::read_to_string("test.html").unwrap();
        let content = html_response;
        let length = content.len();
        let response = format!("{status_line}\r\nContent-Length: {length}\r\n\r\n{content}");

        stream.write_all(response.as_bytes()).unwrap();
    }
    else if b == "GET /index.html?&!2 HTTP/1.1" {
        var2+=1;
        let status_line = "HTTP/1.1 200 OK";//"HTTP/1.1 200 OK\r\n\r\n";
        let meta_refresh = ""; //"<meta http-equiv='refresh' content='1'>";
        //let html_response =format!("<!DOCTYPE html>{meta_refresh} <h1><center><body style='color:powderblue;font-size:500%'> Votes<br> !1: {var1} || !2: {var2}  </center></h1>");
        let html_response =format!("<!DOCTYPE html>{var1}:{var2}");

        //let html_response = "<h1> !1={gg} || !2=$2 </h1>";
        //let content = fs::read_to_string("test.html").unwrap();
        let content = html_response;
        let length = content.len();
        let response = format!("{status_line}\r\nContent-Length: {length}\r\n\r\n{content}");

        stream.write_all(response.as_bytes()).unwrap();
    }
    else if b == "GET /index.html?&started HTTP/1.1"{
        let status_line = format!("HTTP/1.1 {started} OK");
        let length = status_line.len();
        let html_response =format!("{status_line}\r\n Content-Length: {length}\r\n\r\n<!DOCTYPE html>{started}");
        stream.write_all(html_response.as_bytes()).unwrap();
    }
    else if b == "GET /index.html HTTP/1.1" {
        let status_line = format!("HTTP/1.1 200 OK");
        let centent= format!("<!DOCTYPE html>{var1}:{var2}");
        let length = centent.len();
        let html_response =format!("{status_line}\r\n Content-Length: {length}\r\n\r\n<!DOCTYPE html>{var1}:{var2}");
        stream.write_all(html_response.as_bytes()).unwrap();
    }
    else if b == "GET /index.html?&vote_sum HTTP/1.1"{
        let status_line = format!("HTTP/1.1 200 OK");
        let vote_sum=var1-var2;
        let centent= format!("<!DOCTYPE html>{vote_sum}");
        let length = centent.len();
        let html_response =format!("{status_line}\r\n Content-Length: {length}\r\n\r\n<!DOCTYPE html>{vote_sum}");
        stream.write_all(html_response.as_bytes()).unwrap();
    }
    else {
        let status_line = "HTTP/1.1 200 OK";//"HTTP/1.1 200 OK\r\n\r\n";
        let meta_refresh = ""; //"<meta http-equiv='refresh' content='1'>";
        //let html_response =format!("<!DOCTYPE html>{meta_refresh} <h1><center><body style='color:powderblue;font-size:500%'> Votes<br> !1: {var1} || !2: {var2}  </center></h1>");
        let html_response =format!("<!DOCTYPE html>{var1}:{var2}");

        //let html_response = "<h1> !1={gg} || !2=$2 </h1>";
        //let content = fs::read_to_string("test.html").unwrap();
        let content = html_response;
        let length = content.len();
        let response = format!("{status_line}\r\nContent-Length: {length}\r\n\r\n{content}");

        stream.write_all(response.as_bytes()).unwrap();
    }
    

    if b == "GET /index.html?&!1 HTTP/1.1" {
        return 1;//var1+=1;
    }
    else if b == "GET /index.html?&!2 HTTP/1.1" {
        return 2;//var2+=1;
    }
    else if b == "GET /index.html?&!reset HTTP/1.1" {
        return 999;
    }
    else if b == "GET /index.html?&!start HTTP/1.1" {
        return 998;
    }
    else if b == "GET /index.html?&started HTTP/1.1"{
        return 997;
    }
    else if b == "GET /index.html?&vote_sum HTTP/1.1"{
        return 996; //UNUSED
    }
    else {0}

    // writes(b);
    //process::exit(0x0000);
    //return (var1, var2);
    //println!("{:#?}", b);
    //let c: &String = &b.to_string();
    //c
    //&"test".to_string()
}


fn writes(tests: String) -> std::io::Result<()> {
    let mut file = fs::File::create("code.txt")?;
    //file.write_all(b"{1234}")?;
    file.write_all(tests.as_bytes());
    Ok(())
}