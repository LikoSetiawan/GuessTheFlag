//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Liko Setiawan on 31/01/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var selectedFlag = ""
    
    @State private var showingScore = false
    @State private var wrongAnswer = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var lives = 3
    
    @State private var alertGameOver = false
    
    var body: some View {
        NavigationStack{
            ZStack{
                RadialGradient(stops: [
                    .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                    .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
                ], center: .bottom, startRadius: 300, endRadius: 700)
                .ignoresSafeArea()
                VStack(){
                    Spacer()
                    Text("Guess The Flag")
                        .font(.largeTitle.weight(.bold))
                        .foregroundStyle(.white)
                    Spacer()
                    Spacer()
                    Text("Current Lives : \(lives) ")
                        .foregroundStyle(.white)
                        .font(.title.bold())
                    Spacer()
                    Spacer()
                    Text("Score: \(score)")
                        .foregroundStyle(.white)
                        .font(.title.bold())
                    Spacer()
                    VStack(spacing : 15){
                        VStack{
                            Text("Tap the flag of")
                                .foregroundStyle(.secondary)
                                .font(.subheadline.weight(.heavy))
                            Text(countries[correctAnswer])
                                .font(.largeTitle.weight(.semibold))
                        }
                        
                        ForEach(0..<3) { number in
                            Button{
                                flagTapped(number)
                                
                            } label : {
                                FlagImage(flagImage: countries[number])
                            }
                        }
                    }
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                    .padding(.vertical, 20)
                    .background(.regularMaterial)
                    .clipShape(.rect(cornerRadius: 20))
                }
                .padding()
            }
            .navigationTitle("Guess the Flag Games")
            .alert(scoreTitle, isPresented: $showingScore) {
                Button("Continue", action: askQuestion)
            }message: {
                Text("Your Score is \(score)")
            }
            .alert(scoreTitle, isPresented: $alertGameOver) {
                Button("New Game") {
                    resetGame()
                }
            } message: {
                if score == 8 {
                    Text("You Finish The game")
                }else{
                    Text("Too Bad You Lose")
                }
            }
            .alert(scoreTitle, isPresented: $wrongAnswer){
                Button("Continue", action: askQuestion)
            }message: {
                Text("That is the wrong flag. The correct answer is : \(selectedFlag)")
            }
        }
    }
    
    func resetGame(){
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        lives = 3
        score = 0
        alertGameOver = false
    }
    
    func flagTapped(_ number : Int){
        if number == correctAnswer{
            scoreTitle = "Correct"
            if score < 8 {
                score += 1
                showingScore = true
            }else if score == 8 {
                scoreTitle = "You win"
                alertGameOver = true
            }else{
                showingScore = true
            }
            
        }else{
            scoreTitle = "Wrong"
            if lives > 0{
                lives -= 1
                wrongAnswer = true
                selectedFlag = countries[number]
            }else if lives == 0{
                alertGameOver = true
            }else{
                wrongAnswer = true
                selectedFlag = countries[number]
            }
            
        }

    }
    
    func askQuestion(){
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
}

struct FlagImage: View {
    var flagImage : String

    var body: some View {
        Image(flagImage)
            .clipShape(.capsule)
            .shadow(radius: 5)
    }
}

#Preview {
    ContentView()
}
