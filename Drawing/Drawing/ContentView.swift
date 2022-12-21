//
//  ContentView.swift
//  Drawing
//
//  Created by Kurt Lane on 20/12/2022.
//

import SwiftUI

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move (to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY) )
        path.addLine(to: CGPoint (x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        return path
    }
}

struct Arc: InsettableShape {
    let startAngle: Angle
    let endAngle: Angle
    let clockwise: Bool
    var insetAmount = 0.0
    
    func path(in rect: CGRect) -> Path {
        let rotationAdjustment = Angle.degrees(90)
        let modifiedStart = startAngle - rotationAdjustment
        let modifiedend = endAngle - rotationAdjustment
        
        var path = Path()
        path.addArc(center: CGPoint (x: rect.midX, y: rect.midY), radius: rect.width / 2 - insetAmount, startAngle: modifiedStart, endAngle: modifiedend, clockwise: !clockwise)
        return path
    }
    
    func inset(by amount: CGFloat) -> some InsettableShape {
        var arc = self
        arc.insetAmount += amount
        return arc
    }
}

struct Trapezoid: Shape {
    var insetAmount: Double
    var animatableData: Double {
        get { insetAmount }
        set { insetAmount = newValue }
    }
    func path(in rect: CGRect) -> Path {
        var path = Path ()
        path.move(to: CGPoint(x: 0, y: rect.maxY))
        path.addLine(to: CGPoint(x: insetAmount, y: rect.minY))
        path.addLine(to: CGPoint (x: rect.maxX - insetAmount, y: rect.minY) )
        path.addLine (to: CGPoint (x: rect.maxX, y: rect.maxY) )
        path.addLine(to: CGPoint(x: 0, y: rect.maxY) )
        return path
    }
}

struct Checkerboard: Shape {
    var rows: Int
    var columns: Int
    
    var animatableData: AnimatablePair<Double,Double> {
        get {
            AnimatablePair (Double (rows) , Double (columns))
        }
        set {
            rows = Int(newValue.first)
            columns = Int(newValue.second)
        }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let rowSize = rect.height / Double(rows)
        let columnSize = rect.width / Double(columns)
        
        for row in 0..<rows {
            for column in 0..<columns {
                if (row + column).isMultiple(of: 2) {
                    let start = columnSize * Double(column)
                    let startY = rowSize * Double(row)
                    let rect = CGRect (x: start, y: startY, width: columnSize, height: rowSize)
                    path.addRect (rect)
                }
            }
        }
        return path
    }
}

struct Spirograph: Shape {
    let innerRadius: Int
    let outerRadius: Int
    let distance: Int
    let amount: Double
    
    func god(_ a: Int, _ b: Int) -> Int {
        var a = a
        var b = b
        
        while b != 0 {
            let temp = b
            b = a % b
            a = temp
        }
        return a
    }
    
    func path (in rect: CGRect) -> Path {
        let divisor = god (innerRadius, outerRadius)
        let outerRadius = Double (self.outerRadius)
        let innerRadius = Double (self.innerRadius)
        let distance = Double (self.distance)
        let difference = innerRadius - outerRadius
        let endPoint = ceil(2 * Double.pi * outerRadius / Double(divisor)) * amount
        var path = Path()
        for theta in stride(from: 0, through: endPoint, by: 0.01) {
            var x = difference * cos(theta) + distance * cos(difference / outerRadius * theta)
            var y = difference * sin(theta) - distance * sin(difference / outerRadius * theta)
            x += rect.width / 2
            y += rect.height / 2
            if theta == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        return path
    }
    
}

struct ContentView: View {
    //@State private var amount = 0.0
    //@State private var rows = 4
    //@State private var columns = 4
    
    @State private var innerRadius = 125.0
    @State private var outerRadius = 75.0
    @State private var distance = 25.0
    @State private var amount = 1.0
    @State private var hue = 0.6
    
    var body: some View {
        //Paths
        //        Path { path in
        //            path.move (to: CGPoint (x: 200, y: 100))
        //            path.addLine(to: CGPoint(x: 100, y: 300))
        //            path.addLine(to: CGPoint(x: 300, y: 300))
        //            path.addLine(to: CGPoint(x: 200, y: 100))
        //            //path.closeSubpath()
        //        }
        //.fill(.blue)
        //.stroke(.blue, lineWidth: 10)
        //.stroke(.blue, style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
        
        //Shapes
        //        Triangle()
        //            .stroke(.red, style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
        //            .frame (width: 300, height: 300)
        //        Arc(startAngle: .degrees(0), endAngle: .degrees(110), clockwise: true)
        //            .stroke(.blue, lineWidth: 10)
        //            .frame (width: 300, height: 300)
        
        //        VStack {
        //            Arc(startAngle: .degrees(0), endAngle: .degrees(amount), clockwise: true)
        //                .strokeBorder(.blue, lineWidth: 40)
        //            Slider(value: $amount, in: 0...360)
        //                .padding()
        //        }
        
        //        VStack {
        //            ZStack {
        //                Circle()
        //                    .fill(.red)
        //                    .frame(width: 200 * amount)
        //                    .offset(x: -50, y: -80)
        //                    .blendMode(.screen)
        //                Circle()
        //                    .fill(.green)
        //                    .frame(width: 200 * amount)
        //                    .offset(x: 50, y: -80)
        //                    .blendMode(.screen)
        //                Circle()
        //                    .fill(.blue)
        //                    .frame(width: 200 * amount)
        //                    .blendMode(.screen)
        //            }
        //            .frame(width: 300, height: 300)
        //            Slider (value: $amount)
        //            .padding ( )
        //        }
        //        .frame (maxWidth: .infinity, maxHeight: .infinity)
        //        .background(.black)
        //        .ignoresSafeArea()
        
        //        Trapezoid(insetAmount: amount)
        //            .frame (width: 200, height: 100)
        //            .onTapGesture {
        //                withAnimation {
        //                    amount = Double.random(in: 10...90)
        //                }
        //            }
        
        //        Checkerboard(rows: rows, columns: columns)
        //            .onTapGesture {
        //                withAnimation(.linear(duration: 3.0)) {
        //                    rows = Int.random(in: 8...90)//8
        //                    columns = Int.random(in: 8...90)//16
        //                }
        //            }
        
        VStack(spacing: 0) {
            Spacer()
            Spirograph (innerRadius: Int (innerRadius) , outerRadius: Int (outerRadius) , distance:
                            Int(distance), amount: amount)
            .stroke(Color(hue: hue, saturation: 1, brightness: 1), lineWidth: 1)
            .frame(width: 300.0, height: 300.0)
            Spacer()
            Group {
                Text("Inner radius: \(Int(innerRadius))")
                Slider (value: $innerRadius, in: 10...150, step: 1)
                    .padding ([.horizontal, .bottom])
                    .tint(Color(hue: hue, saturation: 1, brightness: 1))
                Text ("Outer radius: \(Int(outerRadius))")
                Slider (value: $outerRadius, in: 10...150, step: 1)
                    .padding ([.horizontal, .bottom])
                    .tint(Color(hue: hue, saturation: 1, brightness: 1))
                Text ("Distance: \(Int (distance))")
                Slider (value: $distance, in: 1...150, step: 1)
                    .padding ([.horizontal, .bottom])
                    .tint(Color(hue: hue, saturation: 1, brightness: 1))
                Text ("Amount: \(amount, format: .number.precision(.fractionLength(2)))")
                Slider(value: $amount)
                    .padding ([.horizontal, .bottom])
                    .tint(Color(hue: hue, saturation: 1, brightness: 1))
                Text("Color")
                Slider (value: $hue)
                    .padding ([.horizontal, .bottom])
                    .tint(Color(hue: hue, saturation: 1, brightness: 1))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
