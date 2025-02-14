// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

/**
 * Ejercicio #1 sobre Mapping
 *
 * Vamos a usar mappings para manejar la propiedad de activos de usuario.
 * Usaremos los tres niveles de mapping más usados:
 * - single mapping
 * - double mapping
 * - triple mapping
 *
 * Mapping simple:
 * Vamos a guardar la cantidad de activos que tiene cada usuario
 * Los usuarios se ven representados por sus billeteras
 * Los cantidad de activos es un número entero
 * map: usuario => cantidad
 *
 * Completar:
 * 1 - Llama a este mapping 'activosSimple'. Y define su llave y valor de manera apropiada
 * 2 - Haz public al mapping 'activosSimple'
 * 3 - Crear un método setter para el mapping llamado guardarActivoSimple. recibe un address y un uint256 como parametros
 * 4 - Validar que el address no sea 0x00. Mensaje de error: "El address no puede ser 0x00". Usar requiere o revert
 *
 * Mapping doble:
 * Usaremos un mapping doble para guardar la cantidad de cada tipo de activo que tiene cada usuario
 * Es decir, un usuario puede tener varios tipos de activos y para cada activo hay cantidades distintas
 * Los usuarios se ven representados por sus billeteras
 * Los activos se represetan con códigos que van del 1 al 999999 (activoId)
 * La cantidad de activos es un número entero
 * map: usuario => activoId => cantidad
 *
 * Completar:
 * 1 - Llamar a este mapping 'activosDouble' y definir sus dos keys y valor apropiados
 * 2 - Hacer public el mapping 'activosDouble'
 * 3 - Crear un método setter llamado 'guardarActivoDoble'. Recibe un address, un uint256 y un uint256
 * 4 - Validar que el address no sea 0x00. Mensaje de error: "El address no puede ser 0x00". Usar revert o require
 * 5 - Validar que los códigos de activo estén entre 1 y 999999. Mensaje de error: "Codigo de activo invalido". Usar revert o require
 *
 * Mapping triple:
 * Usaremos un mapping triple para guardar la cantidad de cada tipo de activo que tiene cada usuario de cada ciudad
 * Es decir, en cada ciudad hay un usuario que tiene varios tipos de activos y cada uno de ellos puede tener una cantidad distinta
 * Las ciudades se representan con códigos que van del 1 al 999999
 * Los usuarios se ven representados por sus billeteras
 * Los activos se represetan con códigos que van del 1 al 999999
 * La cantidad de activos es un número entero
 * map: ciudadId => usuario => activoId => cantidad
 *
 * Completar:
 *  1 - Crear el mapping llamado 'activosTriple' y definir sus tres llaves y el valor apropiados
 *  2 - Haz public el mapping 'activosTriple'
 *  3 - Crear un método setter 'guardarActivoTriple' que reciba un address, un uint256, un uint256 y un uint256
 *  4 - Validar que el address no sea 0x00. Mensaje de error: "El address no puede ser 0x00". Usar revert o require
 *  5 - Validar que los códigos de activo estén entre 1 y 999999. Mensaje de error: "Codigo de activo invalido". Usar revert o require
 *  6 - Validar que los códigos de ciudad estén entre 1 y 999999. Mensaje de error: "Codigo de ciudad invalido". Crear un Custom Error llamado CiudadInvalidaError(uint256 ciudadId)
 *
 *
 * npx hardhat test test/EjercicioTesting_1.js
 */

// contract Ejercicio_1 {
//     // Mapping simple
//     // map: address => uint256 activosSimple;

//     function guardarActivoSimple() public /**...address, uint256 */ {

//     }

//     // Mapping double
//     // map: usuario => activoId => cantidad activosDouble;

//     function guardarActivoDoble() public {}

//     // Mapping double
//     // error Ciudad...

//     // map: ciudadId => usuario => activoId => cantidad activosTriple;

//     function guardarActivoTriple() public {}
// }

contract Ejercicio_1 {
    // Mapping simple: usuario => cantidad
    mapping(address => uint256) public activosSimple;

    // Function to update single mapping
    function guardarActivoSimple(address usuario, uint256 cantidad) public {
        require(usuario != address(0), "El address no puede ser 0x00");
        activosSimple[usuario] = cantidad;
    }

    // Mapping doble: usuario => (activoId => cantidad)
    mapping(address => mapping(uint256 => uint256)) public activosDouble;

    // Function to update double mapping
    function guardarActivoDoble(address usuario, uint256 activoId, uint256 cantidad) public {
        require(usuario != address(0), "El address no puede ser 0x00");
        require(activoId >= 1 && activoId <= 999999, "Codigo de activo invalido");
        activosDouble[usuario][activoId] = cantidad;
    }

    // Custom error for city code validation
    error CiudadInvalidaError(uint256 ciudadId);

    // Mapping triple: ciudadId => (usuario => (activoId => cantidad))
    mapping(uint256 => mapping(address => mapping(uint256 => uint256))) public activosTriple;

    // Function to update triple mapping
    function guardarActivoTriple(uint256 ciudadId, address usuario, uint256 activoId, uint256 cantidad) public {
        require(usuario != address(0), "El address no puede ser 0x00");
        require(activoId >= 1 && activoId <= 999999, "Codigo de activo invalido");
        if (!(ciudadId >= 1 && ciudadId <= 999999)) {
            revert CiudadInvalidaError(ciudadId);
        }
        activosTriple[ciudadId][usuario][activoId] = cantidad;
    }
}
