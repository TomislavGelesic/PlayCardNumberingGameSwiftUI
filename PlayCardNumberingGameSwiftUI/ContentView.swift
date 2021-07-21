//
//  ContentView.swift
//  PlayCardNumberingGameSwiftUI
//
//  Created by Tomislav Gelesic on 21.07.2021..
//

import SwiftUI

struct ContentView: View {
    
    @State var resultsVisible: Bool = false {
        didSet {
            data.numberOfPlayers = 0
            data.directionChangeDivider = 0
            data.skipPlayerDivider = 0
        }
    }
    @State var data: UserData = .init()
    
    var body: some View {
        ZStack {
            VStack(alignment: .center) {
                Spacer()
                Text("PLAY NUMBERING GAME")
                    .foregroundColor(.orange)
                    .padding(.bottom)
                VStack(alignment: .leading, spacing: 100) {
                    InputView(labelText: "Number of players",
                              inputText: $data.numberOfPlayers)
                    InputView(labelText: "Change direction " + "\u{2A}",
                              inputText: $data.directionChangeDivider)
                    InputView(labelText: "Skip player " + "\u{2A}",
                              inputText: $data.skipPlayerDivider)
                    Text("\u{2A}" +  " by what number current game number should be divisible")
                        .foregroundColor(.orange)
                }
                .padding()
                .navigationTitle("PLAY NUMBERING GAME")
                Spacer()
                Button1(action: {
                    calculate()
                    resultsVisible.toggle()
                }, title: "Result")
            }
            .blur(radius: resultsVisible ? 10 : 0)
            .opacity(resultsVisible ? 0.5 : 1)
            if resultsVisible {
                VStack {
                    Spacer()
                    ResultView(player: $data.winner,
                               directionChanges: $data.directionChanged,
                               skippedPlayers: $data.skipped,
                               returnAction: { resultsVisible.toggle() })
                    
                }
            }
        }
    }
    
    func calculate() {
        var skipped = 0
        var changedDirection = 0
        var winnerCounter = 0
        var d = "+"
        
        for i in 0..<data.numberOfPlayers {
            if (i % data.skipPlayerDivider) == 0 {
                skipped += 1
                if d == "-" { winnerCounter -= 2 }
                else { winnerCounter += 2 }
            } else {
                if d == "-" { winnerCounter -= 1 }
                else { winnerCounter += 1 }
            }
            
            if (i % data.directionChangeDivider) == 0 {
                if d == "-" { d = "+" }
                else { d = "-" }
                changedDirection += 1
            }
        }
        
        data.winner = winnerCounter
        data.skipped = skipped
        data.directionChanged = changedDirection
    }
}

struct InputView: View {
    
    var labelText: String
    @Binding var inputText: Int
    
    var body: some View {
        VStack(alignment: .leading,
               spacing: 10) {
            
            Text("\(labelText)")
                .foregroundColor(.orange)
            
            TextField("Enter a number...",
                      value: $inputText,
                      formatter: NumberFormatter())
        }
    }
}
struct ResultView: View {
    
    @Binding var player: Int
    @Binding var directionChanges: Int
    @Binding var skippedPlayers: Int
    var returnAction: ()->()
    
    var body: some View {
        Spacer()
        VStack(spacing: 20) {
            ResultRowView(title: "Player who ended the game",
                          number: $player)
            ResultRowView(title: "How many times direction changed",
                          number: $directionChanges)
            ResultRowView(title: "How many players were skipped",
                          number: $skippedPlayers)
        }
        .background(Color(.white))
        .cornerRadius(10, corners: [.topLeft, .topRight])
        .frame(minWidth: 0, maxWidth: .infinity)
        Spacer()
        Button1(action: {
            returnAction()
        }, title: "PLAY AGAIN")
        Spacer()
    }
    
}

struct Button1: View {
    var action: ()->()
    var title: String
    var body: some View {
        Button(action: {
            action()
        }, label: {
            Text("\(title)")
        })
        .frame(width: 200, height: 50)
        .foregroundColor(.white)
        .background(Color(.orange))
        .cornerRadius(10)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {
    
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct ResultRowView: View {
    var title: String
    @Binding var number: Int
    var body: some View {
        VStack {
            Text("\(title)")
                .padding()
            Text("\(number)")
                .frame(width: 50, height: 50)
                .background(Color(.orange))
                .foregroundColor(.white)
        }
    }
}

struct UserData {
    var numberOfPlayers: Int = 0
    var directionChangeDivider: Int = 0
    var skipPlayerDivider: Int = 0
    var winner: Int = 0
    var skipped: Int = 0
    var directionChanged: Int = 0
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
