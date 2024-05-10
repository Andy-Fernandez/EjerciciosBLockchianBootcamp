/**
 * 1 Colliding with a secret
 *
 * Today marks the anniversary of Sarah's first software release, and to celebrate,
 * she has developed her own cryptographic hash algorithm. As she delves into the
 * intricacies of hash functions, Sarah finds herself contemplating the security
 * of her **SARAH13** hash. Designed to produce a deterministic bit array of length
 * 13, **SARAH13** is engineered to respond sensitively to even the slightest
 * modifications, leveraging the avalanche effect. When Sarah hashes her secret
 * data, it yields the hash value: SARAH(secret) = 0101011001101.
 *
 * With no additional insight into the **SARAH13** hash algorithm,
 * how many unique secrets would Sarah need to hash to have (on average) a 50%
 * chance of encountering a collision with her secret hash value?
 *
 * Put your answer at the end next to 'answerOne'
 *
 * 2 Collision of two distinct secrets
 *
 * After the recent calculation, Sarah's confidence in the security of her
 * encryption has been shaken, and further investigation reveals a more
 * significant concern.
 *
 * With no additional information about the SARAH13
 * encryption algorithm, how many distinct secrets would you need to encrypt
 * on average to have an 80% chance of a collision occurring between two
 * unique secrets?
 *
 * Put your answer at the end next to 'answerTwo'
 *
 *
 * run the tests:
 * npx hardhat test test/hashing.js
 *
 */

// module.exports = { answerOne: , answerTwo: };

function calculateAnswers() {
  const totalOutcomes = Math.pow(2, 13); // 2^13 possible hash outcomes
  const desiredProbabilityOne = 0.5; // 50% collision probability
  const desiredProbabilityTwo = 0.8; // 80% collision probability

  // Using the approximation formula for the first case
  let answerOne = Math.sqrt(-2 * totalOutcomes * Math.log(1 - desiredProbabilityOne));

  // Using the approximation formula for the second case
  let answerTwo = Math.sqrt(-2 * totalOutcomes * Math.log(1 - desiredProbabilityTwo));

  return { answerOne: Math.round(answerOne), answerTwo: Math.round(answerTwo) };
}

const answers = calculateAnswers();
console.log(`Answer One (50% collision): ${answers.answerOne}`);
console.log(`Answer Two (80% collision): ${answers.answerTwo}`);

module.exports = { answerOne: answers.answerOne, answerTwo: answers.answerTwo };

