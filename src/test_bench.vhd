library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TB_ATM_Controller is
-- Testbench does not have any ports
end TB_ATM_Controller;

architecture Behavioral of TB_ATM_Controller is

    -- Component Declaration for the Unit Under Test (UUT)
    component ATM_Controller
        Port (
            CLK : in STD_LOGIC;
            RESET : in STD_LOGIC;
            BTN : in STD_LOGIC;
            PIN_Input : in STD_LOGIC_VECTOR(3 downto 0);
            Option_ROM: in STD_LOGIC_VECTOR(1 downto 0);
            Option_Select : in STD_LOGIC_VECTOR(1 downto 0);
            ROM_Data_Out : out STD_LOGIC_VECTOR(15 downto 0);
            RAM_Data_Out : out STD_LOGIC_VECTOR(15 downto 0);
            Verified_PIN : out STD_LOGIC;
            Cont_creat : out STD_LOGIC
        );
    end component;

    -- Signals to connect to the UUT
    signal CLK : STD_LOGIC := '0';
    signal RESET : STD_LOGIC := '0';
    signal BTN : STD_LOGIC := '0';
    signal PIN_Input : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
    signal Option_ROM : STD_LOGIC_VECTOR(1 downto 0) := (others => '0');
    signal Option_Select : STD_LOGIC_VECTOR(1 downto 0) := (others => '0');
    signal ROM_Data_Out : STD_LOGIC_VECTOR(15 downto 0);
    signal RAM_Data_Out : STD_LOGIC_VECTOR(15 downto 0);
    signal Verified_PIN : STD_LOGIC;
    signal Cont_creat : STD_LOGIC;

    -- Clock period definition
    constant CLK_PERIOD : time := 10 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: ATM_Controller
        Port map (
            CLK => CLK,
            RESET => RESET,
            BTN => BTN,
            PIN_Input => PIN_Input,
            Option_ROM => Option_ROM,
            Option_Select => Option_Select,
            ROM_Data_Out => ROM_Data_Out,
            RAM_Data_Out => RAM_Data_Out,
            Verified_PIN => Verified_PIN,
            Cont_creat => Cont_creat
        );

    -- Clock process definitions
    CLK_process :process
    begin
        CLK <= '0';
        wait for CLK_PERIOD/2;
        CLK <= '1';
        wait for CLK_PERIOD/2;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        -- Reset the ATM controller
        RESET <= '1';
        wait for CLK_PERIOD;
        RESET <= '0';
        
        -- Simulate account creation
        BTN <= '1';
        PIN_Input <= "1101"; -- Example PIN
        Option_ROM <= "00";
        wait for CLK_PERIOD * 10;
        assert (Verified_PIN = '1') report "Pin invalid" severity error;
        
        Option_Select <= "00"; -- Account creation
        wait for CLK_PERIOD * 10;
        assert (Cont_creat = '0') report "Nu s-a putut crea contul" severity error;
        BTN <= '0';
        
        -- Wait for some time
        wait for CLK_PERIOD * 20;

        -- Simulate balance inquiry
        BTN <= '1';
        Option_Select <= "01"; -- Balance inquiry
        wait for CLK_PERIOD * 10;
        BTN <= '0';

        -- Wait for some time
        wait for CLK_PERIOD * 20;

        -- Simulate deposit
        BTN <= '1';
        Option_Select <= "11"; -- Deposit
        wait for CLK_PERIOD * 10;
        BTN <= '0';

        -- Wait for some time
        wait for CLK_PERIOD * 20;

        -- Simulate withdrawal
        BTN <= '1';
        Option_Select <= "10"; -- Withdrawal
        wait for CLK_PERIOD * 10;
        BTN <= '0';

        -- Wait for some time
        wait for CLK_PERIOD * 20;
        assert (RAM_Data_Out = "0000000000110010") report "Nu s-a putut face retragerea" severity error;
        -- Simulation end
        wait;
    end process;

end Behavioral;