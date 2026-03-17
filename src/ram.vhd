library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ram_conturi is
 Port (Adresa: in std_logic_vector(3 downto 0);--pin introdus de la tastatura pe biti direct
       CS, RD, WR : in std_logic;
       CLK : in std_logic;
       D_In: in std_logic_vector(15 downto 0);--suma bani intrare
       D_out: out std_logic_vector(15 downto 0);--sume bani iesire
       pin_verificare: out std_logic;--semnal daca pinul introdus a fost bun sau nu
       Cont_creat: out std_logic; -- semnal daca contul a fost creat
       Cont_creare: in std_logic --semnal daca vreau sa creez cont
       );
       
end ram_conturi;

architecture Behavioral of ram_conturi is
type MEM is array(0 to 3) of std_logic_vector(15 downto 0);
signal ROM: MEM := ("0000000000110010","0000000100101100","0000101110111000","0000000000000000");--50,300,3000,0
begin

   process(Adresa,CS,RD,WR)
   variable ok_pin:std_logic;
   variable Cont_creat_c:std_logic;
   begin
   
   if rising_edge(CLK) then
   Cont_creat_c :='1';
   ok_pin :='0';
   
   if CS = '0' then D_out <= "ZZZZZZZZZZZZZZZZ"; --daca nu e pornit RAM atunci afisam Z pe iesire
   else 
       if RD = '1' then -- daca citim
        case Adresa is
         when "1001" => D_out <= ROM(0);ok_pin := '1';
         when "1100" => D_out <= ROM(1);ok_pin := '1';
         when "1101" => D_out <= ROM(2);ok_pin := '1';
         when "1011" => D_out <= ROM(3);ok_pin := '1';
         when others => D_out <= "0000000000000000";--nu am nimerit nici un cont
            ok_pin := '0';
       end case;
       else if WR= '1' then --daca scriem
       
       if Cont_creare = '1' then
       for i in 0 to 3 loop
       
       if ROM(i) = "0000000000000000" then
       ROM(i) <= "0000000000000010";--Am creat contul si am adaugat 2 euro
       Cont_creat_c := '0';
       end if;
       
       end loop;
       end if;
       
       case Adresa is
       when "1001" => ROM(0) <= D_In;ok_pin := '1';
       when "1100" => ROM(1) <= D_In;ok_pin := '1';
       when "1101" => ROM(2) <= D_In;ok_pin := '1';
       when "1011" => ROM(3) <= D_In;ok_pin := '1';
       when others => D_out <= "0000000000000000";
       end case;
         else D_out <= "0000000000000000"; -- daca nu scriu si nu citesc 
                ok_pin := '0';
         end if;
        end if;
     end if;
     
end if;
       pin_verificare <= ok_pin;
       Cont_creat <= Cont_creat_c;
       end process;
end Behavioral;
