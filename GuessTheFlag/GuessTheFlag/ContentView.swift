//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Yashraj jadhav on 02/01/23.
//

import SwiftUI

struct FlagImage: View {
    var name: String
    
    var body: some View {
        Image(name)
            .renderingMode(.original)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
            .shadow(color: .black, radius: 2)
    }
}

struct ContentView: View {
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var userScore = 0
    
    // for accessibility
    
    let labels = [
        "India" : "Flag with three horizontal stripes of equal size. Top stripe saffron, middle stripe white with navy blue Ashoka Chakra, which has 24 spokes and represents the wheel of law in center of it , bottom stripe green",
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
                   "US": "Flag with red and white stripes of equal size, with white stars on a blue background in the top-left corner"  ]
    
    @State private var countries = [ "India", "Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var number = Int.random(in: 0...11)
    @State private var spinAnimationAmounts = [0.0 , 0.0 , 0.0 ]
    @State private var animatingIncreaseScore = false
    
    @State private var shakeAnimationAmounts = [0, 0, 0]
    @State private var animatingDecreaseScore = false
    
    @State private var animateopacity = false
    @State private var allowSubmitAnswer = true
    
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
            .ignoresSafeArea(.all)
            
            VStack() {
                Spacer()
                
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                            .fontWeight(.semibold).font(.callout)
                        
                    }
                    
                    
                    ForEach(0 ..< 3) { number in
                        Button(action: {
                            self.flagTapped(number)
                        })
                        {
                            
                            // project 3 - challenge 3
                            FlagImage(name: self.countries[number])
                            // project 6 - challenge 1
                            
                                .rotation3DEffect(.degrees(self.spinAnimationAmounts[number]), axis: (x: 0, y: 1, z: 0))
                            
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .accessibilityLabel(labels[countries[number], default: "Unknown flag"])

                Spacer()
                Spacer()
                
                Text("Score:\(userScore)")
                    .foregroundColor(animatingIncreaseScore ? .green : (animatingDecreaseScore ? .red : .white))
                // .foregroundColor(.white)
                    .font(.title.bold())
                
                // project 6 - challenge 1
                Text("+1")
                    .font(.headline)
                    .foregroundColor(animatingIncreaseScore ? .green : .clear)
                    .opacity(animatingIncreaseScore ? 0 : 1)
                    .offset(x: 0, y: animatingIncreaseScore ? -50 : -20)
                
                Text("-1")
                                            .foregroundColor(animatingDecreaseScore ? .red : .clear)
                                            .font(.headline)
                                            .opacity(animatingDecreaseScore ? 0 : 1)
                                            .offset(x: 0, y: animatingDecreaseScore ? 50 : 20)
                
                Spacer()
            }
            .padding()
            
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        }
        
    message: {
        Text("Your score is \(userScore)").font(.headline).foregroundColor(animatingDecreaseScore ?.red : .clear)
        
    }
    }

    
    func flagTapped(_ number: Int) {
        
        // project 6 - challenge 2
   
        
        let nextQuestionDelay = 1.5
        
        let flagAnimationDuration = 0.5
        
        let scoreUpdateDuration = 1.5
        
        withAnimation(Animation.easeOut(duration: flagAnimationDuration)){
            self.animateopacity = true
        }
        
        if number == correctAnswer {
            scoreTitle = "Correct"
            userScore += 1
            
            withAnimation(Animation.easeInOut(duration: flagAnimationDuration)) {
            /* this was imp here */                self.spinAnimationAmounts[number] += 360
                        }
                        withAnimation(Animation.linear(duration: scoreUpdateDuration)) {
                            self.animatingIncreaseScore = true
                        }
                    }
            
        
    else {
            scoreTitle = "Wrong! That’s the flag of \(countries[number])"
            userScore -= 1
        
        withAnimation(Animation.easeOut(duration: flagAnimationDuration)) {self.shakeAnimationAmounts[number] = 2}
        
        }
        
        withAnimation(Animation.linear(duration: scoreUpdateDuration)) {
                        self.animatingDecreaseScore = true
                    }
        
        showingScore = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + nextQuestionDelay) {
                    self.askQuestion()
                }
        
    }
    
    func askQuestion() {
       
        
        self.spinAnimationAmounts = [0.0, 0.0, 0.0]
        self.animatingIncreaseScore = false
        
        self.animateopacity = false
        
        self.shakeAnimationAmounts = [0, 0, 0]
                self.animatingDecreaseScore = false
        
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
    }
}

struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
