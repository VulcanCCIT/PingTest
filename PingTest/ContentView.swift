//
//  ContentView.swift
//  PingTest
//
//  Created by Chuck Condron on 5/5/23.
//  Code based on SwiftyPing
//  https://github.com/samiyr/SwiftyPing.git
//
//  Needing to add a textfield or a picker to enter in the ip address... right now it is hard coded

import SwiftUI


struct ContentView: View {
  @State var ping: SwiftyPing?
  @State var response = ""
  
  var body: some View {
    
    VStack {
      HStack {
        Button(action: {
          ping?.stopPinging()
          response = ""
        }, label: {
          Text("Stop Ping")
            .padding()
            .foregroundColor(.white)
            .background(Color.red)
            .font(.title2)
            .fontWeight(.bold)
            .cornerRadius(20)
        })
        
        Spacer()
        
        Button(action: {
          startPinging()
        }, label: {
          Text("Start Ping")
            .padding()
            .foregroundColor(.white)
            .background(Color.green)
            .font(.title2)
            .fontWeight(.bold)
            .cornerRadius(20)
        })
        
      }
      LazyVStack(spacing: 300) {
        ScrollView(.vertical, showsIndicators: true) {
          TextEditor(text: .constant(response))
            .scrollContentBackground(.hidden)
            .background(Color.black)
            .foregroundColor(Color.green)
            .font(.title3)
            .frame(width: 375, height: 550)
            .cornerRadius(25)
        }
        
      }
      .frame(width: 300, height: 550)
    }
    .padding()
  }
  
  func pingContinuous() {
    // Ping indefinitely
    let pinger = try? SwiftyPing(host: "1.1.1.1", configuration: PingConfiguration(interval: 0.5, with: 5), queue: DispatchQueue.global())
    pinger?.observer = { (response) in
      let duration = response.duration
      print(duration)
    }
    try? pinger?.startPinging()
  }
  
  func startPinging() {
    do {
      ping = try SwiftyPing(host: "1.1.1.1", configuration: PingConfiguration(interval: 1.0, with: 1), queue: DispatchQueue.global())
      ping?.observer = { (response) in
        DispatchQueue.main.async {
          
          let value = Int(round(response.duration * 1000000) / 1000)
          
          var message = "\(value) ms"
          if let error = response.error {
            if error == .responseTimeout {
              message = "Timeout \(message)"
            } else {
              print(error)
              message = error.localizedDescription
            }
          }
          self.response.append(contentsOf: "\nReply from \(response.ipAddress!): bytes=\(response.byteCount!) time= \(message)")
          //self.textView.string.append(contentsOf: "\nPing #\(response.sequenceNumber): \(message)")
          //self.textView.scrollRangeToVisible(NSRange(location: self.textView.string.count - 1, length: 1))
        }
      }
      //            ping?.targetCount = 1
      try ping?.startPinging()
    } catch {
      response = error.localizedDescription
    }
  }
  
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
