----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.10.2021 15:04:58
-- Design Name: 
-- Module Name: Data_controller - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Data_ctrler is
Port (unit              : in std_logic_vector(3 downto 0);
      ten               : in std_logic_vector(3 downto 0);
      hundred           : in std_logic_vector(3 downto 0);
      virgule           : in std_logic;
      clk               : in std_logic;
      rst               : in std_logic;
      signe             : in std_logic;
      AN                : in std_logic_vector(7 downto 0); -- selection afficheur
      data              : out std_logic_vector(3 downto 0); -- code d'affichage
      dp_int            : out std_logic);
end Data_ctrler;

architecture Behavioral of Data_ctrler is

begin
process(clk,rst)
    begin
    if rst = '1' then
        dp_int <= '1';  
        data <= "1111"; -- code pour tout eteindre
    else if rising_edge(clk) then
        case AN is
            when "11111101" => dp_int <= '1';  
                               data <= "1101"; -- code pour afficher 'C'
            when "11111011" => dp_int <= '1'; 
                               data <= "1110"; -- code pour afficher '°'
            when "11110111" => dp_int <= '1'; -- on met la virgule 
                               if virgule = '1' then -- on veut aficher .5 dans ce cas la
                                    data <= "0101"; -- code pour aficher 5
                               else data <= "0000";
                               end if;
            when "11101111" => dp_int <= '0';     
                            data <= ten;
            when "11011111" => dp_int <= '1';
                            data <= hundred;
            when "10111111" => dp_int <= '1';
                           data <= "1111";
            when "01111111" => dp_int <= '1';
                           if signe = '0' then -- signe '-' sur le bloc NegToPos
                             data <= "1010"; -- code data pour afficher '-'
                           else data <= "1111"; -- code data pour afficher rien
                           end if;
            when others => data <= "1111";
        end case;
    end if;
    end if;
end process;    
end Behavioral;
