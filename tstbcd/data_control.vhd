----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.10.2021 15:12:46
-- Design Name: 
-- Module Name: data_control - Behavioral
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

entity data_control is
  Port (
    unit            : in std_logic_vector(3 downto 0);
    ten             : in std_logic_vector(3 downto 0);
    hundred         : in std_logic_vector(3 downto 0);
    thousand        : in std_logic_vector(3 downto 0);
    ten_thousand    : in std_logic_vector(3 downto 0);
    hundred_thousand: in std_logic_vector(3 downto 0);
    million         : in std_logic_vector(3 downto 0);
    ten_million     : in std_logic_vector(3 downto 0);
    dp_vector       : in std_logic_vector(7 downto 0);
    AN              : in std_logic_vector(7 downto 0);
    data            : out std_logic_vector(3 downto 0);
    DP              : out std_logic);
    
end data_control;

architecture Behavioral of data_control is

begin

process(AN)
begin
    case AN is
        when "11111110" => 
            data <= unit;
            DP <= dp_vector(0);
        when "11111101" => 
            data <= ten; 
            DP <= dp_vector(1);
        when "11111011" => 
            data <= hundred; 
            DP <= dp_vector(2);
        when "11110111" => 
            data <= thousand; 
            DP <= dp_vector(3);
        when "11101111" => 
            data <= ten_thousand; 
            DP <= dp_vector(4);
        when "11011111" => 
            data <= hundred_thousand; 
            DP <= dp_vector(5);
        when "10111111" => 
            data <= million; 
            DP <= dp_vector(6);
        when "01111111" => 
            data <= ten_million; 
            DP <= dp_vector(7);
        when others => 
            data <= "0000";
            DP <= '1';
        
end case;
end process;

end Behavioral;
