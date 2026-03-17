library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ROM is
    Port (
        addresa : in STD_LOGIC_VECTOR(1 downto 0);  -- Adresa de 2 bi?i pentru 4 loca?ii (00, 01, 10, 11)
        data_out : out STD_LOGIC_VECTOR(15 downto 0)  -- Ie?irea datelor de 16 bi?i
    );
end ROM;

architecture Behavioral of ROM is
    type rom_array is array (0 to 3) of STD_LOGIC_VECTOR(15 downto 0);  -- ROM cu 4 loca?ii de 16 bi?i
    constant ROM_CONTENTS : rom_array := (
        "0000000001100100",  -- 100
        "0000000011111010",  -- 250
        "0000000111110100",  -- 500
        "0000001111101000"   --1000
    );
begin
    process(addresa)
    begin
        case addresa is
            when "00" =>
                data_out <= ROM_CONTENTS(0);
            when "01" =>
                data_out <= ROM_CONTENTS(1);
            when "10" =>
                data_out <= ROM_CONTENTS(2);
            when "11" =>
                data_out <= ROM_CONTENTS(3);
            when others =>
                data_out <= (others => '0');  -- Valoare implicit? pentru adrese invalide
        end case;
    end process;
end Behavioral;