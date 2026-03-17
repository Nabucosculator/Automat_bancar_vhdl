library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity comparator_16bit is
    Port ( A : in  STD_LOGIC_VECTOR (15 downto 0);
           B : in  STD_LOGIC_VECTOR (15 downto 0);
           AltB : out  STD_LOGIC);
end comparator_16bit;

architecture Behavioral of comparator_16bit is
    signal bit_compare : STD_LOGIC_VECTOR (15 downto 0);
begin

    -- Instantiate 16 instances of the 1-bit comparator
    gen_comp: for i in 0 to 15 generate
        comp_inst: entity work.comparator_1bit
            port map (
                A => A(i),
                B => B(i),
                AltB => bit_compare(i)
            );
    end generate;

    process (bit_compare)
    begin
        -- Initialize AltB to '0'
        AltB <= '0';

        -- Check each bit from MSB to LSB
        for i in 15 downto 0 loop
            if (bit_compare(i) = '1') then
                AltB <= '1';
                exit;
            elsif (A(i) /= B(i)) then
                exit;
            end if;
        end loop;
    end process;

end Behavioral;