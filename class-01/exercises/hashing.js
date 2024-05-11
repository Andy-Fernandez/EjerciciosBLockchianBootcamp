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

const { keccak256 } = require("js-sha3");

function calculateCollision50() {
    const hashLength = 13;
    const totalUniqueHashes = Math.pow(2, hashLength);
    const probabilityOfCollision = 0.5;
  
    const numberOfSecrets = Math.ceil(Math.sqrt(2 * totalUniqueHashes * Math.log(1 / (1 - probabilityOfCollision))));
  
    return numberOfSecrets;
}

function calculateCollision80() {
    const hashSize = Math.pow(2, 13);
    const probability = 0.8;

    return Math.ceil(Math.sqrt(2 * hashSize * Math.log(1 / (1 - probability))));
}

function hashAnswers() {
    const answerOne = calculateCollision50(); 
    const answerTwo = calculateCollision80(); 

    var hashAnswerOne = keccak256(String(answerOne));
    var hashAnswerTwo = keccak256(String(answerTwo));

    console.log(`Answer One (Collision 50%): ${hashAnswerOne}`);
    console.log(`Answer Two (Collision 80%): ${hashAnswerTwo}`);

    return { answerOne, answerTwo };
}

const { answerOne, answerTwo } = hashAnswers();

module.exports = { answerOne, answerTwo };


