//
//  Helpers.swift
//  AOC2020
//
//  Created by Lukas Capkovic on 03/12/2020.
//  Copyright © 2020 Lukas Capkovic. All rights reserved.
//

import Foundation

struct Vec {
    var r: Int
    var c: Int
}

extension Vec: ExpressibleByArrayLiteral {
  init(arrayLiteral: Int...) {
    assert(arrayLiteral.count == 2, "Must initialize vector with 2 values.")
    self.r = arrayLiteral[0]
    self.c = arrayLiteral[1]
  }
}

extension Vec {
  static func + (left: Vec, right: Vec) -> Vec {
    return [
      left.r + right.r,
      left.c + right.c
    ]
  }
}

struct Vec2 {
    var x: Int
    var y: Int
}

extension Vec2: ExpressibleByArrayLiteral {
  init(arrayLiteral: Int...) {
    assert(arrayLiteral.count == 2, "Must initialize vector with 2 values.")
    self.x = arrayLiteral[0]
    self.y = arrayLiteral[1]
  }
}

extension Vec2 {
  static func + (left: Vec2, right: Vec2) -> Vec2 {
    return [
      left.x + right.x,
      left.y + right.y
    ]
  }
}

struct Vec3 {
    var x: Int
    var y: Int
    var z: Int
}

extension Vec3: ExpressibleByArrayLiteral {
  init(arrayLiteral: Int...) {
    assert(arrayLiteral.count == 3, "Must initialize vector with 3 values.")
    self.x = arrayLiteral[0]
    self.y = arrayLiteral[1]
    self.z = arrayLiteral[2]
  }
}

extension Vec3 {
  static func + (left: Vec3, right: Vec3) -> Vec3 {
    return [
        left.x + right.x,
        left.y + right.y,
        left.z + right.z
    ]
  }
}

struct Vec4: Hashable {
    var x: Int
    var y: Int
    var z: Int
    var w: Int
    
    func isAdjacent(to pos: Vec4) -> Bool {
        return self != pos && abs(self.x-pos.x) <= 1 && abs(self.y-pos.y) <= 1 && abs(self.z-pos.z) <= 1 && abs(self.w-pos.w) <= 1
    }
}

extension Vec4: ExpressibleByArrayLiteral {
  init(arrayLiteral: Int...) {
    assert(arrayLiteral.count == 4, "Must initialize vector with 4 values.")
    self.x = arrayLiteral[0]
    self.y = arrayLiteral[1]
    self.z = arrayLiteral[2]
    self.w = arrayLiteral[3]
  }
}

extension Vec4 {
  static func + (left: Vec4, right: Vec4) -> Vec4 {
    return [
        left.x + right.x,
        left.y + right.y,
        left.z + right.z,
        left.w + right.w
    ]
  }
}

func modInv(a: Int, m: Int) -> Int {
    var rem: Int
    if a < 0 {
        var posA = a
        while posA < 0 {
            posA += m
        }
        rem = posA
    } else {
        rem = a % m
    }
    
    for x in 1..<m {
        if rem * x % m == 1 {
            return x
        }
    }
    return 0
}

func CRT(_ _a: [Int], _ m: [Int]) -> Int {
    let N = m.reduce(1, *)
    var a = _a
    for i in 0..<a.count {
        if a[i] < 0 {
            while a[i] < 0 {
                a[i] += m[i]
            }
        }
    }
    
    var x: Int = 0
    for i in 0..<a.count {
        x += a[i] * (N / m[i]) * modInv(a: N / m[i], m: m[i])
    }
    return x % N
}

// Only for square arrays
func rotate90(arr: [[Character]]) -> [[Character]] {
    var rotated = arr
    for row in 0..<arr.count {
        for col in 0..<arr[row].count {
            rotated[col][arr.count-row-1] = arr[row][col]
        }
    }
    return rotated
}
