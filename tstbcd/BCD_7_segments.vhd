----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.10.2021 14:10:53
-- Design Name: 
-- Module Name: BCD_7_segments - Behavioral
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

entity BCD_7_segments is
    Port (
    data : in std_logic_vector(3 downto 0);
    BCD : out std_logic_vector(6 downto 0));
end BCD_7_segments;

architecture Behavioral of BCD_7_segments is

begin
process(data)

begin
case data is 
    when "0000" => BCD <= not "0111111";
    when "0001" => BCD <= not "0000110";
    when "0010" => BCD <= not "1011011"; --2 ou Z
    when "0011" => BCD <= not "1001111";
    when "0100" => BCD <= not "1100110";
    when "0101" => BCD <= not "1101101";
    when "0110" => BCD <= not "1111101";
    when "0111" => BCD <= not "0000111";
    when "1000" => BCD <= not "1111111";
    when "1001" => BCD <= not "1101111";
    when "1010" => BCD <= not "1110000"; --K
    when "1011" => BCD <= not "1110110"; --H
    when "1111" => BCD <= not "0000000";
    when others => BCD <= "0000110"; --E
end case;
end process;

end Behavioral;
