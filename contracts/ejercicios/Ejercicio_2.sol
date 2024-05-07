// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

/**
 * Ejercicio 2
 *
 * Vamos a crear una serie de modifiers que nos ayudarán añadir validaciones
 * y protecciones a nuestros contratos.
 *
 * Escenarios a validar/proteger:
 * 1
 * - acceso: que solo el admin sea quien pueda ejecutar una función
 *   nombre modifer: soloAdmin
 *   aplicar al método: metodoAccesoProtegido
 *
 * 2
 * - permiso: que personas de una lista puedan llamar a un método
 *   nombre modifer: soloListaBlanca
 *   aplicar al método: metodoPermisoProtegido
 *   Adicional:
 *   - definir un setter para incluir addresses en la lista blanca protegido por soloAdmin
 *   - nombre del método: incluirEnListaBlanca
 *
 * 3
 * - tiempo: que un método sea llamado dentro de un rango de tiempo
 *   nombre modifer: soloEnTiempo
 *   aplicar al método: metodoTiempoProtegido
 *
 * 4
 * - pausa: que un método pueda ser pausado y reanudado
 *   nombre modifer: pausa
 *   aplicar al método: metodoPausaProtegido
 *   Adicional:
 *   - definir un método para cambiar ese booleano que tenga el modifier de soloAdmin
 *   - nombre del metodo: cambiarPausa
 *
 *
 * Notas:
 *  - para el modifier de tiempo, se puede usar block.timestamp
 *  - para el modifier de pausa, se puede usar un booleano
 *  - dejar los cuerpos de todos los métodos en blanco
 *
 * Testing: Ejecutar el siguiente comando:
 * - npx hardhat test test/EjercicioTesting_2.js
 */

contract Ejercicio_2 {
    address public admin = 0x08Fb288FcC281969A0BBE6773857F99360f2Ca06;
    mapping(address => bool) public whitelist;
    bool public paused = false;
    uint256 public startTime = block.timestamp;
    uint256 public duration = 30 days;

    // Events for logging actions
    event AddedToWhitelist(address indexed account);
    event RemovedFromWhitelist(address indexed account);
    event PauseChanged(bool newStatus);

    modifier soloAdmin() {
        require(msg.sender == admin, "No eres el admin");
        _;
    }

    modifier soloListaBlanca() {
        require(whitelist[msg.sender], "Fuera de la lista blanca");
        _;
    }

    modifier soloEnTiempo() {
        require(block.timestamp <= startTime + duration, "Fuera de tiempo");
        _;
    }

    modifier enPausa() {
        require(!paused, "El metodo esta pausado");
        _;
    }


    // Admin functions
    function cambiarAdmin(address nuevoAdmin) public soloAdmin {
        admin = nuevoAdmin;
    }

    function incluirEnListaBlanca(address _account) public soloAdmin {
        whitelist[_account] = true;
        emit AddedToWhitelist(_account);
    }

    function excluirDeListaBlanca(address _account) public soloAdmin {
        whitelist[_account] = false;
        emit RemovedFromWhitelist(_account);
    }

    function cambiarPausa(bool _nuevoEstado) public soloAdmin {
    paused = _nuevoEstado;
}



    // Protected methods
    function metodoAccesoProtegido() public soloAdmin {
        // logic for admin-only access
    }

    function metodoPermisoProtegido() public soloListaBlanca {
        // logic for whitelist-only access
    }

    function metodoTiempoProtegido() public soloEnTiempo {
        // logic available only within a specific time frame
    }

    function metodoPausaProtegido() public enPausa {
        // logic that can be paused
    }
}
