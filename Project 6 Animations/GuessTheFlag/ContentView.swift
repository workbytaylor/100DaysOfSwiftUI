//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Nilakshi Roy on 2022-05-24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var userAnswer: Int = 4  // 4 to initialize, outside scope of correctAnswer
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score: Int = 0
    
    @State private var questionCount: Int = 0
    
    @State private var animationAmount: Double = 0.0
    @State private var opacityAmount: Double = 1.0
    //@State private var userTapped: Int = 0  // 4 outside of scope to start
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 400)
                .ignoresSafeArea()
            
            VStack {
                Text("Guess the Flag")
                    .font(.largeTitle.weight(.bold))
                    .foregroundColor(.white)
                Spacer()
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .font(.subheadline.weight(.heavy))
                            .foregroundStyle(.secondary)
                        
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            userAnswer = number
                            flagTapped(number)
                            questionCount += 1
                    
                            withAnimation {
                                animationAmount += 360
                                opacityAmount -= 0.75
                            }
                            
                        } label: {
                            if number == userAnswer {
                                FlagImage(country: countries[number])
                                    .rotation3DEffect(.degrees(animationAmount), axis: (x:0, y:1, z:0))
                            } else {
                                FlagImage(country: countries[number])
                                    .opacity(opacityAmount)
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                
                Text("Score: \(score)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                
                // show user the question number
                Text("Question \(questionCount) of 8")
                    .foregroundColor(.white)
                
                Spacer()
            }
            .padding()
        }
        
        .alert(scoreTitle, isPresented: $showingScore) {
            if questionCount == 8 {
                Button("Restart", action: restart)
            } else {
                Button("Continue", action: askQuestion)
            }
        } message: {
            if questionCount == 8 {
                Text("Your final score is \(score) of 8")
            } else if scoreTitle == "Correct" {
                Text("Your score is \(score)")
            } else {
                Text("Try again! You tapped the flag of \(countries[userAnswer])")
            }
        }
    }
    
    struct FlagImage: View {
        var country: String
        
        var body: some View {
            Image(country)
                .renderingMode(.original)
                .clipShape(Capsule())
                .shadow(radius: 5)
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
            
        } else {
            scoreTitle = "Wrong"
        }
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        opacityAmount = 1
    }
    
    func restart() {
        questionCount = 0
        score = 0
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
