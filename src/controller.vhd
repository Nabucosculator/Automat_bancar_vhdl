library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ATM_Controller is
    Port (
        CLK : in STD_LOGIC;
        RESET : in STD_LOGIC;
        BTN : in STD_LOGIC; -- Added button input for debouncing
        PIN_Input : in STD_LOGIC_VECTOR(3 downto 0);
        Option_ROM: in STD_LOGIC_VECTOR(1 downto 0);
        Option_Select : in STD_LOGIC_VECTOR(1 downto 0);
        ROM_Data_Out : out STD_LOGIC_VECTOR(15 downto 0);--doar simulare
        RAM_Data_Out : out STD_LOGIC_VECTOR(15 downto 0);--afisam calcule pe parcurs 
        Verified_PIN : out STD_LOGIC;--0 daca pin-ul este gresit si 1 daca este corect
        Cont_creat : out STD_LOGIC; -- Indicates if the account was successfully created (0 for success, 1 for failure)
        Suma_efectuata : out STD_LOGIC; --1 daca s-a facut suma 0 daca nu
        Diferenta_efectuata : out STD_LOGIC --1 daca s-a facut scaderea 0 daca nu
        );
end ATM_Controller; 

architecture Behavioral of ATM_Controller is

    -- Debouncer component declaration
    component MPG is
        Port (
            btn : in STD_LOGIC;
            clk : in STD_LOGIC;
            en : out STD_LOGIC
        );
    end component;

    -- Other component declarations
    component comparator_16bit
        Port (
            A : in STD_LOGIC_VECTOR(15 downto 0);
            B : in STD_LOGIC_VECTOR(15 downto 0);
            AltB : out STD_LOGIC
        );
    end component;

    component Subtractor16Bit
        Port (
            A : in STD_LOGIC_VECTOR(15 downto 0);
            B : in STD_LOGIC_VECTOR(15 downto 0);
            Bin : in STD_LOGIC;
            Diff : out STD_LOGIC_VECTOR(15 downto 0);
            Bout : out STD_LOGIC
        );
    end component;

    component ROM
        Port (
            addresa : in STD_LOGIC_VECTOR(1 downto 0);
            data_out : out STD_LOGIC_VECTOR(15 downto 0)
        );
    end component;

    component ram_conturi
        Port (
            Adresa : in STD_LOGIC_VECTOR(3 downto 0);
            CS, RD, WR : in STD_LOGIC;
            CLK : in STD_LOGIC;
            D_In : in STD_LOGIC_VECTOR(15 downto 0);
            D_out : out STD_LOGIC_VECTOR(15 downto 0);
            pin_verificare : out STD_LOGIC;
            Cont_creat : out STD_LOGIC;
            Cont_creare: in std_logic
        );
    end component;

    component sumator
        Port (
            x : in STD_LOGIC_VECTOR(15 downto 0);
            y : in STD_LOGIC_VECTOR(15 downto 0);
            output : out STD_LOGIC_VECTOR(15 downto 0)
        );
    end component;

    -- Internal signals for inter-component communication
    signal internal_ROM_data : STD_LOGIC_VECTOR(15 downto 0);
    signal internal_RAM_data : STD_LOGIC_VECTOR(15 downto 0);
    signal internal_comparator_result : STD_LOGIC;
    signal internal_subtractor_diff : STD_LOGIC_VECTOR(15 downto 0);
    signal internal_sum_result : STD_LOGIC_VECTOR(15 downto 0);
    signal internal_verified_PIN : STD_LOGIC;
    signal internal_Cont_creat : STD_LOGIC;
    signal internal_borrow_out : STD_LOGIC;
    signal RD : STD_LOGIC;
    signal WR : STD_LOGIC;
    signal calcul_intermediar : STD_LOGIC_VECTOR(15 downto 0);
    signal Cont_creare: std_logic;
    
    -- Debouncer signals
    signal debounced_BTN : STD_LOGIC;

begin

    -- Debouncer instance
    debouncer_inst : MPG
        port map (
            btn => BTN,
            clk => CLK,
            en => debounced_BTN                                                                     
        );

    -- ROM component instance
    rom_inst : ROM
        port map (
            addresa => Option_ROM,
            data_out => internal_ROM_data
        );

    -- RAM component instance
    ram_inst : ram_conturi
        port map (
            Adresa => PIN_Input,
            CS => '1',
            RD => RD,
            WR => WR,
            CLK => CLK,
            D_In => calcul_intermediar,
            D_out => internal_RAM_data,
            pin_verificare => internal_verified_PIN,
            Cont_creat => internal_Cont_creat,
            Cont_creare => Cont_creare
        );

    -- Comparator component instance
    comparator_inst : comparator_16bit
        port map (
            A => internal_ROM_data,
            B => internal_RAM_data,
            AltB => internal_comparator_result
        );

    -- Subtractor component instance
    subtractor_inst : Subtractor16Bit
        port map (
            A => internal_RAM_data,
            B => internal_ROM_data,
            Bin => '0',
            Diff => internal_subtractor_diff,
            Bout => internal_borrow_out
        );

    -- Adder component instance
    sumator_inst : sumator
        port map (
            x => internal_RAM_data,
            y => internal_ROM_data,
            output => internal_sum_result
        );

    -- Main control logic
    process (CLK, RESET)
    begin
    
    Cont_creare <= '1';--vreau sa creez cont
    RD <= '1';--verific mai intai daca pinul este corect
    WR <= '0';
    
        if RESET = '1' then
            ROM_Data_Out <= (others => '0');
            RAM_Data_Out <= (others => '0');

        elsif rising_edge(CLK) then
        
    RD <= '1';--verific mai intai daca pinul este corect
    WR <= '0';
        
        if internal_verified_PIN = '1' then --and debounced_BTN = '1' then -- Use debounced button signal
            
            Verified_PIN <= internal_verified_PIN;--pin bun sau nu  
            
                case Option_Select is
                    when "00" => -- Account creation with an initial deposit of 2 euros
                    WR <= '1';
                    RD <= '0';
                    Cont_creare <= '1';--vreau sa creez cont
                    Cont_creat <= internal_Cont_creat;--am creat cont sau nu
                    when "01" => -- Balance inquiry
                    RD <= '1';
                    WR <= '0';
                        RAM_Data_Out <= internal_RAM_data;
                    when "10" => -- Withdrawal
                        if internal_comparator_result = '1' then
                            RD <= '0';
                        WR <= '1';
                            calcul_intermediar <= internal_subtractor_diff;
                            RAM_Data_Out <= internal_subtractor_diff;--vreau sa vad valoarea
                        else
                            RAM_Data_Out <= (others => '0'); -- Insufficient funds
                        end if;
                    when "11" => -- Deposit
                        RD <= '0';
                        WR <= '1';
                        calcul_intermediar <= internal_sum_result;
                        RAM_Data_Out <= internal_sum_result;--vreau sa vad valoarea
                    when others =>
                        RAM_Data_Out <= (others => '0');
                        ROM_Data_Out <= (others => '0');
                end case;
            else
                RAM_Data_Out <= (others => '0');
            end if;
            ROM_Data_Out <= internal_ROM_data;
        end if;
    end process;

end Behavioral;