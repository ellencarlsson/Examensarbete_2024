//
//  DetectionView.swift
//  Examensarbete_2024 Watch App
//
//  Created by Ellen Carlsson on 2024-03-27.
//

import SwiftUI

struct DetectionView: View {
    var body: some View {
        VStack {
            
            Button(action: {}) {
                Image(systemName: "arrow.backward.circle")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.black)
                
            }
            .padding(-16)
            
            //.padding(.bottom, 60)
            
            .padding(.trailing, 100)
            
            //Spacer()
            
            Text("letter")
                .foregroundColor(.black)
                .padding(.bottom, 45)
                .padding(.top, 55)
            
            //Spacer()
            
            Text("word")
                .foregroundColor(.black)
            .padding(.bottom, 10)
            //.padding(.top, 50)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(Color.white)
    }
}

#Preview {
    DetectionView()
}
