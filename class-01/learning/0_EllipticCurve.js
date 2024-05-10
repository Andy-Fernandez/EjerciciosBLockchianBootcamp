/**
 * Read the file class-01/learning/EllipticCurve.md and implement the
 * algorithm in javascript
 *
 * Build an Elliptic Curve that does:
 * - Point Addition
 * - Scalar Multiplication
 *
 * To verify your Elliptic Curve use the following values:
 *
 * y^2 = x^3 - 3*x + 4 (mod 17)
 *
 * Point A = (1, 6)
 * Point B = (9, 14)
 *
 * Point Addition:
 * Point A + Point B = (8, 4)
 *
 * Scalar Multiplication:
 * Point A * 4 = (12, 8)
 *
 * You need to use this file to solve the exercise exercise/keyExchangeProtocol.js
 */

class ECC {
  constructor(a, b, p) {
      this.a = a;
      this.b = b;
      this.p = p;
  }

  pointAddition(point1, point2) {
      if (!point1) return point2;
      if (!point2) return point1;

      const { x: x1, y: y1 } = point1;
      const { x: x2, y: y2 } = point2;

      if (x1 === x2 && y1 === y2) {
          return this.pointDoubling(point1);
      }

      if (x1 === x2) {
          return null; // Point at infinity
      }

      const m = this.mod((y2 - y1) * this.modInverse(x2 - x1, this.p), this.p);
      const x3 = this.mod(m * m - x1 - x2, this.p);
      const y3 = this.mod(m * (x1 - x3) - y1, this.p);

      return { x: x3, y: y3 };
  }

  pointDoubling(point) {
      if (!point) return null;

      const { x: x1, y: y1 } = point;
      if (y1 === 0) return null; // Point at infinity

      const m = this.mod((3 * x1 * x1 + this.a) * this.modInverse(2 * y1, this.p), this.p);
      const x3 = this.mod(m * m - 2 * x1, this.p);
      const y3 = this.mod(m * (x1 - x3) - y1, this.p);

      return { x: x3, y: y3 };
  }

  scalarMultiplication(point, n) {
      let result = null;
      let addend = point;

      while (n > 0) {
          if (n & 1) { // n is odd
              result = this.pointAddition(result, addend);
          }
          addend = this.pointDoubling(addend);
          n >>= 1; // Divide n by 2
      }

      return result;
  }

  modInverse(a, m) {
      let m0 = m, t, q;
      let x0 = 0, x1 = 1;

      if (m === 1) return 0;

      while (a > 1) {
          q = Math.floor(a / m);
          t = m;
          m = a % m, a = t;
          t = x0;
          x0 = x1 - q * x0;
          x1 = t;
      }

      return x1 < 0 ? x1 + m0 : x1;
  }

  mod(n, m) {
      return (n % m + m) % m;
  }
}

const curve = new ECC(-3, 4, 17);
const pointA = { x: 1, y: 6 };
const pointB = { x: 9, y: 14 };


// Verificar la adición de puntos
const pointSum = curve.pointAddition(pointA, pointB);
console.log("Point A + Point B:", pointSum); // Debería imprimir (8, 4)

// Verificar la multiplicación escalar
const scalarResult = curve.scalarMultiplication(pointA, 4);
console.log("Point A * 4:", scalarResult); // Debería imprimir (12, 8)