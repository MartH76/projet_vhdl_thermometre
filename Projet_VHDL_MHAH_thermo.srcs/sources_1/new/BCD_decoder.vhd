----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.10.2021 14:18:41
-- Design Name: 
-- Module Name: BCD_decoder - Behavioral
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

entity BCD_decoder is
Port ( data   : in std_logic_vector(3 downto 0); 
       clk    : in std_logic;
       rst    : in std_logic;
       display    : out std_logic_vector(6 downto 0));
end BCD_decoder;

architecture Behavioral of BCD_decoder is
begin
process(clk, rst)
    begin
    if rst = '1' then 
        display <= "1111111"; -- tout eteindre
    else if rising_edge(clk) then    
        case data is
            when "0000" => display <= "1000000";
            when "0001" => display <= "1111001";
            when "0010" => display <= "0100100";
            when "0011" => display <= "0110000";   
            when "0100" => display <= "0011001";
            when "0101" => display <= "0010010";
            when "0110" => display <= "0000010";
            when "0111" => display <= "1111000";
            when "1000" => display <= "0000000";
            when "1001" => display <= "0010000";
            when "1101" => display <= "1000110"; -- C
            when "1110" => display <= "0011100"; --'°'
            when "1010" => display <= "0111111"; -- '-'
            when others => display <= "1111111";
         end case;
     end if;
     end if;
end process;
end Behavioral;