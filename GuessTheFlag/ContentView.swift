//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Zaid Raza on 29/08/2020.
//  Copyright © 2020 Zaid Raza. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var showingScore = false
    
    @State private var scoreTitle = ""
    
    @State private var score = 0
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var animationAmount = 0.0
    @State private var opacityAmount = 1.0
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    
    let labels = [
        "Estonia": "Flag with three horizontal stripes of equal size. Top stripe blue, middle stripe black, bottom stripe white",
        "France": "Flag with three vertical stripes of equal size. Left stripe blue, middle stripe white, right stripe red",
        "Germany": "Flag with three horizontal stripes of equal size. Top stripe black, middle stripe red, bottom stripe gold",
        "Ireland": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe orange",
        "Italy": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe red",
        "Nigeria": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe green",
        "Poland": "Flag with two horizontal stripes of equal size. Top stripe white, bottom stripe red",
        "Russia": "Flag with three horizontal stripes of equal size. Top stripe white, middle stripe blue, bottom stripe red",
        "Spain": "Flag with three horizontal stripes. Top thin stripe red, middle thick stripe gold with a crest on the left, bottom thin stripe red",
        "UK": "Flag with overlapping red and white crosses, both straight and diagonally, on a blue background",
        "US": "Flag with red and white stripes of equal size, with white stars on a blue background in the top-left corner"
    ]
    
    var body: some View {
        
        ZStack{
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30){
                VStack{
                    
                    Text("Tap the Flag of")
                        .foregroundColor(Color.white)
                    
                    Text(countries[correctAnswer])
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
                
                ForEach(0..<3, id: \.self){ number in
                    Button(action: {
                        withAnimation{
                            self.opacityAmount = 0.25
                            self.animationAmount += 360
                        }
                        self.flagTapped(number: number)
                    }){
                        Image(self.countries[number])
                            .renderingMode(.original)
                            .clipShape(Capsule())
                            .overlay(Capsule().stroke(Color.black,lineWidth: 1))
                            .shadow(color: .black, radius: 2)
                            .accessibility(label: Text(self.labels[self.countries[number], default: "Unknown flag"]))
                    }
                        
                    .opacity(number != self.correctAnswer ? self.opacityAmount : 1)
                    .rotation3DEffect(.degrees(number == self.correctAnswer ? self.animationAmount : 0.0), axis: (x:0,y:1,z:0))
                    
                }
                
                VStack{
                    Text("Score: \(score)")
                        .foregroundColor(.white)
                }
                Spacer()
                
            }
                
            .alert(isPresented: $showingScore){
                Alert(title: Text(scoreTitle), message: Text("your score is \(score)"), dismissButton: .default(Text("Continue")){
                    self.askQuestion()
                    self.opacityAmount = 1.0
                    self.animationAmount = 0.0
                    })
            }
        }
    }
    
    func flagTapped(number: Int){
        if number == correctAnswer{
            scoreTitle = "Correct"
            score += 1
        }
        else{
            scoreTitle = "Wrong that's the flag of \(countries[number])"
            score -= 1
        }
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
