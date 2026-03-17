# Automat Bancar -- Proiect VHDL (FPGA)

## Prezentare generală

Acest proiect implementează un **sistem simplificat de automat bancar
(ATM)** utilizând **VHDL** și concepte de proiectare pentru FPGA.\
Scopul proiectului este simularea logicii de bază a unui ATM, incluzând
stocarea soldului, efectuarea operațiilor aritmetice pentru tranzacții
și coordonarea componentelor printr-o unitate de control.

Proiectul a fost realizat și testat folosind **Vivado Design Suite** și
este destinat plăcii **Nexys A7‑100T FPGA**.

Prin acest proiect se urmărește înțelegerea unor concepte fundamentale
din proiectarea sistemelor digitale:

-   proiectare hardware modulară
-   utilizarea memoriei (ROM / RAM)
-   unități aritmetice
-   logică de control
-   testarea circuitelor prin simulare

------------------------------------------------------------------------

# Arhitectura sistemului

Sistemul ATM este compus din mai multe module VHDL, fiecare având un rol
bine definit.

Componenta centrală este **controller-ul**, care coordonează fluxul de
date dintre modulele aritmetice și modulele de memorie.

Componente principale:

-   Controller (logica ATM)
-   Unități aritmetice (sumator și scăzător)
-   Module de memorie (ROM și RAM)
-   Comparator pentru verificarea soldului
-   Modul de debouncing pentru butoane

------------------------------------------------------------------------

# Structura proiectului

    automat-bancar/
    │
    ├── controller.vhd
    ├── ram.vhd
    ├── rom.vhd
    ├── sumator.vhd
    ├── scazator.vhd
    ├── comparator.vhd
    ├── comparator_1bit.vhd
    ├── scazator_1bit.vhd
    ├── debouncer.vhd
    ├── test_bench.vhd
    │
    ├── Nexys-A7-100T-Master.xdc
    │
    └── PSN_ATM_DOCUMENTATIE.pdf

------------------------------------------------------------------------

# Descrierea modulelor

## controller.vhd

Reprezintă **unitatea principală de control** a sistemului ATM.

Responsabilități: - coordonează toate modulele - controlează operațiile
de citire și scriere - gestionează fluxul tranzacțiilor - decide când
sunt executate operațiile aritmetice

Practic, acest modul funcționează ca **mașina de stări a sistemului**.

------------------------------------------------------------------------

## ram.vhd

Implementează modulul de **memorie RAM**.

Rol: - stochează valori dinamice, cum ar fi **soldul contului** -
permite operații de citire și scriere - este utilizat în timpul
procesării tranzacțiilor

------------------------------------------------------------------------

## rom.vhd

Implementează o **memorie ROM**.

Rol: - stochează **valori predefinite sau constante ale sistemului** -
memorie doar pentru citire

------------------------------------------------------------------------

## sumator.vhd

Implementează un **sumator binar**.

Rol: - efectuează operații de adunare - este utilizat în momentul
**depunerii de bani în cont**

------------------------------------------------------------------------

## scazator.vhd

Implementează un **scăzător binar**.

Rol: - efectuează operații de scădere - este utilizat în momentul
**retragerii de bani din cont**

------------------------------------------------------------------------

## scazator_1bit.vhd

Reprezintă un **scăzător pe 1 bit**.

Rol: - este utilizat pentru construirea scăzătorului pe mai mulți biți -
demonstrează principiul proiectării ierarhice

------------------------------------------------------------------------

## comparator.vhd

Implementează un **comparator pe mai mulți biți**.

Rol: - compară două valori - verifică dacă **soldul este suficient
pentru o retragere**

------------------------------------------------------------------------

## comparator_1bit.vhd

Comparator pe **1 bit**, utilizat pentru construirea comparatorului
principal.

Rol: - demonstrează proiectarea modulară - reprezintă elementul de bază
al comparatorului multi-bit

------------------------------------------------------------------------

## debouncer.vhd

Implementează un **circuit de debouncing**.

Rol: - elimină zgomotul generat de apăsarea butoanelor mecanice -
asigură semnale de intrare stabile pentru sistem

------------------------------------------------------------------------

## test_bench.vhd

Modul utilizat pentru **simulare și verificare**.

Rol: - testează funcționarea sistemului ATM - verifică corectitudinea
operațiilor - permite validarea designului înainte de implementarea
hardware

------------------------------------------------------------------------

# Constrângeri FPGA

## Nexys-A7-100T-Master.xdc

Acest fișier conține **configurația pinilor pentru placa Nexys A7**.

Definește:

-   maparea pinilor FPGA
-   configurația semnalului de ceas
-   conexiunile de intrare/ieșire

------------------------------------------------------------------------

# Documentație

Documentația proiectului se găsește în:

    PSN_ATM_DOCUMENTATIE.pdf

Aceasta descrie:

-   arhitectura sistemului
-   modul de funcționare
-   interacțiunea componentelor
-   detalii despre implementare

------------------------------------------------------------------------

# Tehnologii utilizate

-   **VHDL**
-   **Vivado Design Suite**
-   **FPGA Nexys A7**

------------------------------------------------------------------------

# Obiective de învățare

Prin realizarea acestui proiect au fost exersate:

-   proiectarea circuitelor digitale
-   arhitecturi hardware modulare
-   fluxul de dezvoltare pentru FPGA
-   implementarea sistemelor în VHDL
-   simularea și testarea circuitelor

------------------------------------------------------------------------

# Autori

Proiect realizat de:

-   **Semeniuc Giulia‑Carla**
-   **Tudor Vlad‑Andrei**
