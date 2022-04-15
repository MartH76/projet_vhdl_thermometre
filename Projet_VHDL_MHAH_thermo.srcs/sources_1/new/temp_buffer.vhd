----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.03.2022 10:58:38
-- Design Name: 
-- Module Name: temp_buffer - Behavioral
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

entity temp_buffer is
  Port (
    temperature : in std_logic_vector(15 downto 0);
    ready : in std_logic;
    clk : in std_logic;
    temp_buff : out std_logic_vector(15 downto 0));
end temp_buffer;

architecture Behavioral of temp_buffer is

signal s_temp_buff : std_logic_vector(15 downto 0);
begin
process(clk, ready) 
begin
if rising_edge(clk) then 
    if ready = '1' then
        s_temp_buff <= temperature;
    else 
        s_temp_buff <= s_temp_buff;
    end if;
    temp_buff <= s_temp_buff;
end if;
end process;
end Behavioral;
