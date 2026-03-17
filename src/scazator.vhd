library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Subtractor16Bit is
    Port (
        A : in STD_LOGIC_VECTOR(15 downto 0);  -- Primul operand de 16 bi?i
        B : in STD_LOGIC_VECTOR(15 downto 0);  -- Al doilea operand de 16 bi?i
        Bin : in STD_LOGIC;  -- Împrumut de intrare (borrow in)
        Diff : out STD_LOGIC_VECTOR(15 downto 0);  -- Diferen?a de 16 bi?i
        Bout : out STD_LOGIC  -- Împrumut de ie?ire (borrow out)
    );
end Subtractor16Bit;

architecture Behavioral of Subtractor16Bit is
    -- Semnale pentru împrumuturile interne
    signal Borrow : STD_LOGIC_VECTOR(16 downto 0);

    -- Componenta sc?z?tor pe 1 bit
    component FullSubtractor1Bit
        Port (
            A : in STD_LOGIC;
            B : in STD_LOGIC;
            Bin : in STD_LOGIC;
            D : out STD_LOGIC;
            Bout : out STD_LOGIC
        );
    end component;

begin
    -- Instan?ierea sc?z?toarelor pe 1 bit ?i conectarea acestora
    gen_subtractors: for i in 0 to 15 generate
        bit_sub: FullSubtractor1Bit
            port map (
                A => A(i),
                B => B(i),
                Bin => Borrow(i),
                D => Diff(i),
                Bout => Borrow(i+1)
            );
    end generate;

    -- Setarea împrumutului ini?ial ?i final
    Borrow(0) <= Bin;
    Bout <= Borrow(16);

end Behavioral;