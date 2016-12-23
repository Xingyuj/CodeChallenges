//@Author Ethan Xingyu Ji
use std::io;
use std::io::prelude::*;
use std::str;

// reverse a sequence of integer by using stack
fn reverse_integer(){
    let mut stack = Vec::new();
    let stdin = io::stdin();
    println!("Input integers one per line, input a non-integer will display reversed result:");
    for line in stdin.lock().lines() {
        let input = line.unwrap().parse::<i32>();
        if input.is_ok() {
            stack.push(input.unwrap());
        } else {
            break;
        }
    }
    while let Some(top) = stack.pop() {
        println!("{}", top);
    }
}

// reverse a string by doing three times of Xor operations
fn reverse_string(){
  let stdin = io::stdin();
  let mut input:String = String::from("");
  println!("Input a string:");
  for line in stdin.lock().lines() {
      input = line.unwrap();
      if input != "" {
          input = input.to_owned();
          break;
      }
  }
  let mut input_bytes = input.as_bytes().to_owned();
  let mut start = 0;
  let mut end = input_bytes.len()-1;
  // Three times Xor operations to reverse string
  while start < end {
      input_bytes[end] ^= input_bytes[start];
      input_bytes[start] ^= input_bytes[end];
      input_bytes[end] ^= input_bytes[start];
      start += 1;
      end -= 1;
  }
  println!("{}", str::from_utf8(&input_bytes).unwrap());
}

fn main() {
    let stdin = io::stdin();
    let mut chosen = 1;
    println!("Please select: 1 -> reverse integer, 2 -> reverse string");
    for line in stdin.lock().lines() {
        let input = line.unwrap().parse::<i32>();
        if input.is_ok() {
            chosen = input.unwrap();
            if chosen == 1 {
                break;
            } else if chosen == 2 {
                break;
            }
        }
    }
    if chosen == 1 {
        reverse_integer();
    } else {
        reverse_string();
    }
}
