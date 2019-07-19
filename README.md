# dice-mvvm-ios

Simple Dice Roll app in Swift using MVVM

## Purpose

This is an illustration of a viewmodel as a transform from input to output.
The inspiration was the idea of a BCD (Binary Coded Decimal) to 7-element dice circuit.
This circuit can map the numbers 1-6 to their patterns in 'dice' format, using only an AND gate and an OR gate.

## Dice Format

The dice format is as follows:

```
A   D
B X E
C   F
```

Where the numbers 1-6 are represented by:

```
.   .   2   .   3   .   4   4   5   5   6   6
. 1 .   . . .   . 3 .   . . .   . 5 .   6 . 6
.   .   .   2   .   3   4   4   5   5   6   6
```

### Logic

The 'pins' of the dice layout map to the inputs (`i1`, `i2`, `i4` in binary) as follows:

```
A = F = i2 OR i4
B = E = i2 AND i4
C = D = i4
    X = i1
```

## Code

The code encapsulates this logic in the `ViewModel` inside a reactive mapping. The drivers for each of the 4 output pins bind to views in `ViewController`, and drive their `isHidden` property.
The dice roller returns an `Observable` which cycles through random numbers (1-6) and lands on the final number, then completes.

## Requirements

### Cocoapods

You must first run `pod install` before opening the `xcworkspace` file
