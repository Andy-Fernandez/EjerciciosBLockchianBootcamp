/**
 * EXERCISE: Encrypted vote
 *
 * Imagine a situation where you want to ensure that the votes in an election are authentic and were, in fact, what the voters intended.
 * Also, you want to make sure the votes are not altered or revealed to anyone else.
 *
 * In this voting process, there are three parties. The voters, the election official and the candidates.
 * - Voters will vote for a candidate
 * - The electoral official will verify that the votes are authentic
 * - The candidates are those who will be chosen and voted for
 *
 * Voters will sign their vote with their private key and encrypt it with the election official's public key.
 * All votes are collected in an array and sent to the election officials.
 * The election official will decrypt each vote with his private key and verify that the vote is authentic.
 * The verification process means obtaining the public key address from the signature. If that public key matches
 * the voter's public key, then it's verify correctly and counted.
 *
 * Run the tests with the following command:
 * npx hardhat test test/voting.js
 */

var {
  sign,
  encryptWithPublicKey,
  hash,
  cipher,
  decryptWithPrivateKey,
  recoverPublicKey,
} = require("eth-crypto");

/**
 * @note This function takes each voter's vote and encrypts it with the official's public key
 *
 * @param {string} voterPrivateKey Each voter's private key
 * @param {string} candidate The candidate that the voters is voting for
 * @param {string} officialPublicKey The official's public key used to encrypt the message
 * @return {string} Returns a stringified version of the encrypted vote
 */
// async function encryptVote(voterPrivateKey, candidate, officialPublicKey) {
//   return "";
// }
var {
  sign,
  encryptWithPublicKey,
  recoverPublicKey,
} = require("eth-crypto");

async function encryptVote(voterPrivateKey, candidate, officialPublicKey) {
  // Hash the candidate's name to get a fixed-length message
  const message = candidate;
  const hashedMessage = hash.keccak256(message);

  // Sign the hash of the candidate's name
  const signature = await sign(voterPrivateKey, hashedMessage);

  // Prepare the payload
  const payload = JSON.stringify({ message: candidate, signature });

  // Encrypt the payload with the election official's public key
  const encryptedVote = await encryptWithPublicKey(officialPublicKey, payload);

  // Return a stringified version of the encrypted object
  return cipher.stringify(encryptedVote);
}


/**
 * @note This function decrypts each vote with the official's private key and counts each valid vote
 *
 * @param {string[]} publicKeyVoters Array of public keys that belong to voters
 * @param {string[]} encryptedVotes An array of encrypted and stringified votes. Each vote is the output of 'encryptVote' function
 * @param {string} officialPrivateKey The official's private key used to decrypt each vote
 *
 * @return Returns table of votes where each candidate has a number of votes
 */
// async function decryptVoteAndCount(
//   publicKeyVoters,
//   encryptedVotes,
//   officialPrivateKey
// ) {
//   return {};
// }
var {
  decryptWithPrivateKey,
  recoverPublicKey,
} = require("eth-crypto");

async function decryptVoteAndCount(
  publicKeyVoters,
  encryptedVotes,
  officialPrivateKey
) {
  const voteCount = {};

  for (const encryptedVote of encryptedVotes) {
    // Decrypt the vote
    const decryptedString = await decryptWithPrivateKey(officialPrivateKey, cipher.parse(encryptedVote));
    const decryptedVote = JSON.parse(decryptedString);

    // Recover the public key from the signature
    const voterPublicKey = await recoverPublicKey(decryptedVote.signature, hash.keccak256(decryptedVote.message));

    // Verify that the public key is from a legitimate voter
    if (publicKeyVoters.includes(voterPublicKey)) {
      // Count the vote if the public key is verified
      const candidate = decryptedVote.message;
      if (!voteCount[candidate]) {
        voteCount[candidate] = 0;
      }
      voteCount[candidate]++;
    }
  }

  return voteCount;
}


module.exports = { encryptVote, decryptVoteAndCount };
