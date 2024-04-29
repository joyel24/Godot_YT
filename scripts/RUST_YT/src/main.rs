use std::{
    fs::File,
    io::{prelude::*, BufReader},
    net::{TcpListener, TcpStream},
    process,
};
use url::{Url, Host, Position};

fn main() {
    let listener = TcpListener::bind("127.0.0.1:8080").unwrap();

    for stream in listener.incoming() {
        let stream = stream.unwrap();

        //println!("Connection established!");
        handle_connection(stream);
        //return 0
    }
}

fn handle_connection(mut stream: TcpStream) {
    let buf_reader = BufReader::new(&mut stream);
    let request_line = buf_reader.lines().next().unwrap().unwrap();

    let urll = request_line;
    //let urll = urll.replace("GET ", "http://127.0.0.1");
    //let urll = urll.replace(" HTTP/1.1", "");


    //let a = urll;
    let b = &urll[0..urll.find("&scope=").unwrap_or(urll.len())];
    let b = b.replace("%2F", "/");
    let b = b.replace("GET /?state=state_parameter_passthrough_value&code=", "");
    //println!("{:#?}", b);
    writes(b);
    process::exit(0x0000);
    //return 0;



    //let b = &b[0..b.find("&scope=").unwrap_or(b.len())];
    //b = &b.drain(0..b).collect::<String>();
    //let c = b.drain(0..b).collect::<String>();

    //let uurl="http://bbidule.com/test?pp=22";

    //let URLObject = Url::parse(uurl);

    //let param = URLObject.searchParams.get("code"); 

    //println!("{:#?}", urll);
    //println!("AAAAAAA ");
    
    //println!(" ");
    //println!("{:#?}", c);
    //println!(" ");
}


fn writes(tests: String) -> std::io::Result<()> {
    let mut file = File::create("code.txt")?;
    //file.write_all(b"{1234}")?;
    file.write_all(tests.as_bytes());
    Ok(())
}