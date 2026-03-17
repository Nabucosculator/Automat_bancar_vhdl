library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FullSubtractor1Bit is
    Port (
        A : in STD_LOGIC;  -- Primul operand (bitul A)
        B : in STD_LOGIC;  -- Al doilea operand (bitul B)
        Bin : in STD_LOGIC;  -- Împrumut de intrare (borrow in)
        D : out STD_LOGIC;  -- Diferen?a (A - B - Bin)
        Bout : out STD_LOGIC  -- Împrumut de ie?ire (borrow out)
    );
end FullSubtractor1Bit;

architecture Behavioral of FullSubtractor1Bit is
begin
    process(A, B, Bin)
    begin
        -- Calculul diferen?ei
        D <= A xor B xor Bin;

        -- Calculul împrumutului
        Bout <= (not A and B) or (not A and Bin) or (B and Bin);
    end process;
end Behavioral;