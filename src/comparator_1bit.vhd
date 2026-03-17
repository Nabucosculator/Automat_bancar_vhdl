library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity comparator_1bit is
    Port ( A : in  STD_LOGIC;
           B : in  STD_LOGIC;
           AltB : out  STD_LOGIC);
end comparator_1bit;

architecture Behavioral of comparator_1bit is
begin
    process (A, B)
    begin
        if (A < B) then
            AltB <= '1';
        else
            AltB <= '0';
        end if;
    end process;
end Behavioral;