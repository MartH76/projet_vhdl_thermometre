----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.10.2021 15:25:52
-- Design Name: 
-- Module Name: AN_counter - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity AN_counter is
    Port (
    clk: in std_logic;
    rst: in std_logic;
    clk_1kHz: in std_logic;
    AN: out std_logic_vector(7 downto 0));
end AN_counter;

architecture Behavioral of AN_counter is
signal i: integer;
signal An_temp1,AN_temp2: std_logic_vector(7 downto 0) := "11111110";
begin
process(clk_1kHz,rst)
begin
    if rst='1' then
    AN<="11111110";
    AN_temp1<="11111110";
    AN_temp2<="11111110";
    elsif rising_edge(clk_1kHz) then
        AN_temp2(7 downto 1)<=AN_temp1(6 downto 0);
        AN_temp2(0)<=AN_temp1(7);
        AN_temp1<=AN_temp2;
        AN<=AN_temp2;
    end if;
end process;
end Behavioral;
