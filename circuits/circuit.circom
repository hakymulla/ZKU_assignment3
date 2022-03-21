pragma circom 2.0.0;

include "/Users/Hakeem/Documents/zkpassignment/circomlib/circuits/comparators.circom";

template checkTriangle() {

    signal input a1;
    signal input a2;
    signal input b1;
    signal input b2;
    signal input c1;
    signal input c2;
    signal output out;

    signal one;
    signal two;
    signal three;
    signal area;

    one <== (a1 * (b2 - c2));
    two <== (b1 * (c2 - a2));
    three <== (c1 * (a2 - b2));    

    area <== one + two + three;  

    component lte = IsZero();
    lte.in <== area;
    lte.out === 0;


     /* check (a1-b1)^2 + (a2-b2)^2 <= distMax^2 */
     /* check (b1-c1)^2 + (b2-c2)^2 <= distMax^2 */

    signal diffA;
    signal diffB;
    signal diffC;
    signal diffD;

    var distMax = 10;

    diffA <== a1 - b1;
    diffB <== a2 - b2;
    diffC <== b1 - c1;
    diffD <== b2 - c2;


    component ltDist1 = LessThan(64);
    component ltDist2 = LessThan(64);

    signal firstDistSquare;
    signal secondDistSquare;
    signal thirdDistSquare;
    signal fourthDistSquare;


    firstDistSquare <== diffA * diffA;
    secondDistSquare <== diffB * diffB;
    thirdDistSquare <== diffC * diffC;
    fourthDistSquare <== diffD * diffD;


    ltDist1.in[0] <== firstDistSquare + secondDistSquare;
    ltDist1.in[1] <== distMax * distMax + 1;
    ltDist1.out === 1;

    ltDist2.in[0] <== thirdDistSquare + fourthDistSquare;
    ltDist2.in[1] <== distMax * distMax + 1;
    ltDist2.out === 1;


}


component main = checkTriangle();
